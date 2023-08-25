with
    asylum_decisions as (
        select
            _date_year,
            _country_name_origin,
            _country_name_asylum,
            _inneed_asylum_seekers_total_decided,
            _inneed_asylum_seekers_otherwise_closed,
            _inneed_asylum_seekers_rejected,
            _inneed_asylum_seekers_recognized,
            _inneed_asylum_seekers_recognized_other
        from {{ ref("stg_asylum_decisions") }}
    )
select distinct *
from asylum_decisions
order by _date_year desc
