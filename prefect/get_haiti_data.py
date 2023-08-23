import os
import shutil
from hdx.utilities.easy_logging import setup_logging
from hdx.api.configuration import Configuration
from hdx.data.dataset import Dataset
from prefect import task, flow
from google.cloud.storage import Client
from prefect_gcp import GcpCredentials
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp.bigquery import bigquery_load_cloud_storage
from prefect_dbt.cli import DbtCoreOperation

os.environ[
    "GOOGLE_APPLICATION_CREDENTIALS"
] = "/Users/young/AppData/Roaming/gcloud/haiti-insights-c832f2d05399.json"


@task(name="Download csvs to local directory")
def get_haiti_displace_data():
    setup_logging()
    Configuration.create(
        hdx_site="prod", user_agent="DE_Personal_Project", hdx_read_only=True
    )
    dataset = Dataset.read_from_hdx("unhcr-population-data-for-hti")
    resources = dataset.get_resources()

    if not os.path.exists("../displacement_csvs"):
        os.makedirs("../displacement_csvs")

    dest_path = "../displacement_csvs"
    # Download csv files on displacement; will use dbt to delete duplicate rows
    for x in range(1, 11):
        url, path = resources[x].download(dest_path)
        print("Resource URL %s downloaded to %s" % (url, path))

    return None


@task(name="Upload csvs to Google Cloud Storage bucket")
def load_data_to_gcs(pref_gcs_block_name: str, from_path: str) -> None:
    """Load the displacement data to Google Bucket - delete first row of
    all csvs first to not mess up Biguery schema auto-detect
    """

    # Change this to your CSV file base directory
    base_directory = "../displacement_csvs"
    for dir_path, dir_name_list, file_name_list in os.walk(base_directory):
        for file_name in file_name_list:
            # If this is not a CSV file
            if not file_name.endswith(".csv"):
                # Skip it
                continue
            file_path = os.path.join(dir_path, file_name)
            with open(file_path, "r") as ifile:
                line_list = ifile.readlines()
            with open(file_path, "w") as ofile:
                # skip first row of csv file
                ofile.writelines(line_list[1:])

    gcs_block = GcsBucket.load(pref_gcs_block_name)
    gcs_block.upload_from_folder(from_path)

    shutil.rmtree(from_path)
    return None


@flow(log_prints=True, name="Make tables and load data in Big Query")
def makeBigQueryTables(pref_gcs_block_name: str, dataset_id: str, bucket_name: str):
    gcp_credentials = GcpCredentials.load("gcp-credentials")
    storage_client = Client()

    bucket = storage_client.bucket(bucket_name)
    blobs = bucket.list_blobs()

    for blob in blobs:
        file_name = blob.name
        print(f"\nBLOB NAME: {blob.name}\n")
        table_id = file_name.replace(" ", "_").replace(".csv", "")
        print(f"\nTABLE NAME: {table_id}\n")

        print(f"\nSOURCE URI: gs://{bucket_name}/{file_name}\n")
        try:
            result = bigquery_load_cloud_storage(
                uri=f"gs://{bucket_name}/{file_name}",
                dataset=dataset_id,
                table=table_id,
                gcp_credentials=gcp_credentials,
                location="us-east4",
            )

            print(result)

        except Exception as e:
            print("ERROR LOADING JOB: ", e)


@task(log_prints=True, name="Perform dbt transformations")
def dbt_transformation() -> object:
    """Triggers the dbt dependency and build commands"""
    result = DbtCoreOperation(
        commands=[
            "dbt debug",
            "dbt build",
            "dbt run",
        ],
        project_dir="../dbt/",
        profiles_dir="../dbt/",
    ).run()
    return result


@flow()
def getLoad_haiti_data(
    pref_gcs_block_name: str = "haiti-data-lake",
    haiti_data_path: str = "../displacement_csvs",
    dataset_id: str = "haiti_idp_dataset",
    bucket_name: str = "haiti-tracking-data",
):
    get_haiti_displace_data()

    load_data_to_gcs(
        wait_for=[get_haiti_displace_data],
        pref_gcs_block_name=pref_gcs_block_name,
        from_path=haiti_data_path,
    )

    makeBigQueryTables(
        wait_for=[load_data_to_gcs],
        pref_gcs_block_name=pref_gcs_block_name,
        dataset_id=dataset_id,
        bucket_name=bucket_name,
    )

    dbt_transformation(wait_for=[makeBigQueryTables])


if __name__ == "__main__":
    getLoad_haiti_data()
