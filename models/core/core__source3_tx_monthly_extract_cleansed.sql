{% set phone_number_extra_characters = '()- ' %}
{% set license_type_prefix = 'Licensed' %}

with final as (
    select 
        "address",
        city,
        "state",
        zip::varchar,
        county,
        translate(phone,'{{ phone_number_extra_characters }}','')::varchar as phone,
        trim(split_part("type",'{{ license_type_prefix }}',2)) as license_type,
        "status" as license_status,
        issue_date::date as license_issued,
        capacity::numeric as capacity,
        email_address as email,
        facility_id,
        operation_name as company
        -- TODO map Infant-school columns to ages
    from {{ ref('base__source3_tx_monthly_extract') }}
)
select * from final