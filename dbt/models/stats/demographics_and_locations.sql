with
    demographics_and_locations as (
        select
            _date_year,
            _country_name_origin,
            _country_name_asylum,
            _indicator_population_type,
            string_field_6 as current_location,
            string_field_8 as accommodationtype,
            _affected_f_infants_age_0_4,
            _affected_f_children_age_5_11,
            _affected_f_adolescents_age_12_17,
            _affected_f_adults_age_18_59,
            _affected_f_elderly_age_60,
            _affected_f_unknown_age,
            _affected_f_total,
            _affected_m_infants_age_0_4,
            _affected_m_children_age_5_11,
            _affected_m_adolescents_age_12_17,
            _affected_m_adults_age_18_59,
            _affected_m_elderly_age_60,
            _affected_m_unknown_age,
            _affected_m_total,
            _affected_all_total
        from {{ ref("stg_demographics_and_locations") }}
    )
select distinct *
from demographics_and_locations
order by _date_year desc
