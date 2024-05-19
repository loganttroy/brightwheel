{% set provisional_license_string = '(PROVISIONAL)' %}
{% set company_name_location_delimeter = ' - ' %}
{% set phone_number_extra_characters = '()- ' %}

with final as (
    select 
        trim(split_part("name",'{{ company_name_location_delimeter }}',1)) as company,
        trim(split_part("name",'{{ company_name_location_delimeter }}',2)) as company_location,
        case when credential_type like '%{{ provisional_license_string }}%' then 'Provisional' else 'Full Permit' end as license_status,
        trim(replace(credential_type,'{{provisional_license_string}}','')) as license_type,
        replace(credential_number,'-','')::numeric as license_number,
        "status" as company_status,
        expiration_date::date as certificate_expiration_date,
        case when disciplinary_action = 'N' then 0 when disciplinary_action = 'Y' then 1 else -1 end as has_disciplinary_action,
        trim(split_part("address",' ',-1))::varchar as zip,
        trim(split_part("address",',',-2)) as address_street_and_city, -- TODO need to separate out later
        "state",
        county,
        translate(phone,'{{ phone_number_extra_characters }}','')::varchar as phone,
        first_issue_date::date as license_issued,
        primary_contact_name,
        primary_contact_role as title
    from {{ ref('base__source1_nv_monthly_extract') }}
)
select * from final