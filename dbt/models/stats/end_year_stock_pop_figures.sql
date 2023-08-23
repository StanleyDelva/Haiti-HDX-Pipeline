with
    end_year_stock_pop_figures as (
        select
            _date_year,
            _country_name_origin,
            _country_name_asylum,
            _affected_refugees,
            _affected_asylum_seekers,
            _affected_stateless,
            _affected_others,
            (
                _affected_refugees
                + _affected_asylum_seekers
                + _affected_stateless
                + _affected_others
            ) as affected_total
        from {{ ref("stg_end_year_stock_pop_figures") }}
    )
select distinct *
from end_year_stock_pop_figures
order by _date_year desc
