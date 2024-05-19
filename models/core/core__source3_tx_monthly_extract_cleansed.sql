{% set phone_number_extra_characters = '()- ' %}
{% set license_type_prefix = 'Licensed' %}


with final as (
    select 
        "address" as address1,
        city,
        "state" as address_state,
        zip,
        county,
        translate(phone,'{{ phone_number_extra_characters }}','') as phone,
        trim(split_part("type",'{{ license_type_prefix }}',2)) as license_type,
        "status" as license_status,
        issue_date::date as issue_date,
        capacity::int as capacity,
        email_address as email,
        facility_id
        -- TODO map Infant-school columns to ages
    from {{ ref('base__source3_tx_monthly_extract') }}
)
select * from final