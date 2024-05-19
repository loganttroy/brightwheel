with final as (
    select * from {{ ref("seed__source1") }}
)
select * from final