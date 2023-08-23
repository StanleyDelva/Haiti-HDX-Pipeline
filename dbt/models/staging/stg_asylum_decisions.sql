with
    asylum_decisions as (
        select *
        from
            {{
                source(
                    "haiti_idp_dataset",
                    "Asylum_decisions_taken_on_asylum_claims_of_asylum_seekers_originating_from_Haiti",
                )
            }} asylum_decisions_taken_on_asylum_claims_of_asylum_seekers_originating_from_haiti
        union all
        select *
        from
            {{
                source(
                    "haiti_idp_dataset",
                    "Asylum_decisions_taken_on_asylum_claims_of_asylum_seekers_residing_in_Haiti",
                )
            }} asylum_decisions_taken_on_asylum_claims_of_asylum_seekers_residing_in_haiti

    )

select *
from asylum_decisions
