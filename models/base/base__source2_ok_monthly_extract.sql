with final as (
    select * from {{ ref("seed__source2") }}
)
select * from final