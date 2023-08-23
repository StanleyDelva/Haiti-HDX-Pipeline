with
    asylum_apps as (
        select
            _date_year,
            _country_name_origin,
            _country_name_asylum,
            _inneed_asylum_seekers_applications
        from {{ ref("stg_asylum_applications") }}
    )
select distinct *
from asylum_apps
order by _date_year desc
