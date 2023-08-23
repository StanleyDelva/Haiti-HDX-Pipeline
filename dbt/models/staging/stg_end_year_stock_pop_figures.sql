with
    end_year_stock_pop_figures as (
        select *
        from
            {{
                source(
                    "haiti_idp_dataset",
                    "End-year_stock_population_figures_for_forcibly_displaced_and_stateless_persons_residing_in_Haiti",
                )
            }} end_year_stock_population_figures_for_forcibly_displaced_and_stateless_persons_residing_in_haiti
        union all
        select *
        from 
        {{
            source(
                "haiti_idp_dataset",
                "End-year_stock_population_figures_for_forcibly_displaced_persons_originating_from_Haiti",
            )
        }} end_year_stock_population_figures_for_forcibly_displaced_persons_originating_from_haiti
    )

select *
from end_year_stock_pop_figures
