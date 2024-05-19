with final as (
    select * 
    from {{ source('salesforce','brightwheel_salesforce_leads')}}
)
select * from final