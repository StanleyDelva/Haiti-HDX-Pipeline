with
    demographics_and_locations as (
        select *
        from
            {{
                source(
                    "haiti_idp_dataset",
                    "Demographics_and_locations_of_forcibly_displaced_and_stateless_persons_residing_in_Haiti",
                )
            }} demographics_and_locations_of_forcibly_displaced_and_stateless_persons_residing_in_haiti
        union all
        select *
        from 
            {{
                source(
                    "haiti_idp_dataset",
                    "Demographics_and_locations_of_forcibly_displaced_persons_originating_from_Haiti",
                )
            }} demographics_and_locations_of_forcibly_displaced_persons_originating_from_haiti
    )
select *
from demographics_and_locations
