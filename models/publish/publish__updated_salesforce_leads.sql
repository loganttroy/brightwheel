with final as (
    select 
        *,
        'FALSE' as is_deleted,
        'Unassigned' as lead_status, -- TODO - check business assumption
        'FALSE' as is_converted,
        null::timestamp as created_date, -- TODO get from enhanced load process
        null::timestamp as last_modified_date,
        null::timestamp as last_activity_date,
        null::timestamp as last_viewed_date,
        null::timestamp as last_referenced_date,
        null as email_bounced_reason,
        null::timestamp as email_bounced_date,
        null as outreach_stage,
        null as lead_source_last_updated
    from {{ ref('core__combined_leads') }}
    union all
    select * from {{ ref('core__salesforce_leads_standardized') }}
)
select * from final