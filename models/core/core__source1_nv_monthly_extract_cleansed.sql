{% set provisional_license_string = '(Provisional)' %}

with final as (
    select 
        trim(split_part("name",'-',1)) as company_name,
        trim(split_part("name",'-',2)) as company_location,
        case when credential_type like '%{{ provisional_license_string }}%' then 'Provisional' else 'Full Permit' end as license_status,
        trim(replace(credential_type,'{{provisional_license_string}}','')) as credential_type,
        credential_number,
        "status" as company_status,
        expiration_date::date as license_expiration_date,
        case when disciplinary_action = 'N' then 0 when disciplinary_action = 'Y' then 1 else -1 end as has_disciplinary_action,
        trim(split_part("address",' ',-1)) as address_zip,
        trim(split_part("address",',',-2)) as address_street_and_city, -- TODO need to separate out later
        "state" as address_state,
        county as addresss_county,
        replace(phone,'-','') as phone,
        first_issue_date::date as license_issue_date,
        primary_contact_name,
        primary_contact_role
    from {{ ref('base__source1_nv_monthly_extract') }}
)
select * from final