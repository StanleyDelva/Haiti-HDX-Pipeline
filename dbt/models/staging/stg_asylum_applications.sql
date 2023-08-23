with
    asylum_applications as (
        select
            _date_year,
            _country_name_origin,
            _country_name_asylum,
            _indicator_procedure_name,
            _indicator_application_type,
            _indicator_application_data,
            _inneed_asylum_seekers_applications
        from
            {{
                source(
                    "haiti_idp_dataset",
                    "Asylum_applications_by_asylum_seekers_originating_from_Haiti",
                )
            }} asylum_applications_by_asylum_seekers_residing_in_haiti
        union all
        select
            _date_year,
            _country_name_origin,
            _country_name_asylum,
            _indicator_procedure_name,
            _indicator_application_type,
            _indicator_application_data,
            _inneed_asylum_seekers_applications
        from
            {{
                source(
                    "haiti_idp_dataset",
                    "Asylum_applications_by_asylum_seekers_residing_in_Haiti",
                )
            }} asylum_applications_by_asylum_seekers_residing_in_haiti
    )

select *
from asylum_applications
