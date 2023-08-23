with
    solutions_for_refugees_and_idps as (
        select
            _date_year,
            _country_name_origin,
            _country_name_asylum,
            _affected_resettled,
            _affected_naturalized,
            _affected_refugees_returnees,
            _affected_idps_returnees,
            (
                _affected_resettled
                + _affected_naturalized
                + _affected_refugees_returnees
                + _affected_idps_returnees
            ) as affected_resolved_total
        from {{ ref("stg_solutions_for_refugees_and_IDPs") }}
    )
select distinct *
from solutions_for_refugees_and_idps
order by _date_year desc
