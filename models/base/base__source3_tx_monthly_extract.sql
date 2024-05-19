with final as (
    select * from {{ ref("seed__source3") }}
)
select * from final