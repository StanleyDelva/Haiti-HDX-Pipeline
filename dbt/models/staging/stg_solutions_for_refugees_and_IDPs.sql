with
    solutions_for_refugees_and_idps as (
        select *
        from 
            {{
                source(
                    "haiti_idp_dataset",
                    "Solutions_for_refugees_and_IDPs_originating_from_Haiti",
                )
            }} solutions_for_refugees_and_idps_originating_from_haiti
        union all
        select *
        from 
            {{
                source(
                    "haiti_idp_dataset",
                    "Solutions_for_refugees_and_IDPs_residing_in_Haiti",
                )
            }} solutions_for_refugees_and_idps_residing_in_haiti
    )

select *
from solutions_for_refugees_and_idps
