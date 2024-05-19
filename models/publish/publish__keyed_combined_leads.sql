with final as (
    select 
        -- Compute uniqueness key to identify duplicate/delta leads
        md5(concat(phone,'|',address1,'|',address2,'|',city,'|',"state")) as lead_uniqueness_id,
        *
    from {{ ref('publish__updated_salesforce_leads') }}
)
select * from final