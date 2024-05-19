with nv as (
    select
        null as accepts_financial_aid,
        null as ages_served,
        null::numeric as capacity,
        certificate_expiration_date,
        null as city,
        address_street_and_city as address1,
        null as address2,
        company,
        phone,
        null as phone2,
        county,
        null as curriculum_type,
        null as email,
        null as first_name, -- TODO extract from primary contact name
        null as "language",
        null as last_name,
        license_status,
        license_issued,
        license_number,
        null::date as license_renewed,
        license_type,
        null as licensee_name,
        null::numeric as max_age,
        null::numeric as min_age,
        null as operator,
        null as provider_id,
        null as schedule,
        "state",
        title,
        null as website,
        zip,
        null as facility_type
    from {{ ref('core__source1_nv_monthly_extract_cleansed') }}
),
ok as (
    select
        accepts_financial_aid,
        null as ages_served, --TODO
        capacity,
        null::date as certificate_expiration_date,
        city,
        address1 as address1,
        address2 as address2,
        company,
        phone,
        null as phone2,
        null as county,
        null as curriculum_type,
        email,
        null as first_name, -- TODO extract from primary caregiver name
        null as "language",
        null as last_name,
        null as license_status,
        license_issued,
        license_number,
        null::date as license_renewed,
        license_type,
        null as licensee_name,
        null::numeric as max_age, --TODO from ages allowed
        null::numeric as min_age,
        null as operator,
        null as provider_id,
        null as schedule, --TODO
        "state",
        title,
        null as website,
        zip,
        null as facility_type
    from {{ ref('core__source2_ok_monthly_extract_cleansed') }}
),
tx as (
    select
        null as accepts_financial_aid,
        null as ages_served, --TODO
        capacity,
        null::date as certificate_expiration_date,
        city,
        "address" as address1,
        null as address2, --TODO
        company,
        phone,
        null as phone2,
        county,
        null as curriculum_type,
        email,
        null as first_name,
        null as "language",
        null as last_name,
        license_status,
        license_issued,
        null::numeric as license_number,
        null::date as license_renewed,
        license_type,
        null as licensee_name,
        null::numeric as max_age,
        null::numeric as min_age,
        null as operator,
        null as provider_id,
        null as schedule,
        "state",
        null as title,
        null as website,
        zip,
        null as facility_type
    from {{ ref('core__source3_tx_monthly_extract_cleansed') }}
),
final as (
    select * from nv
    union all 
    select * from ok 
    union all 
    select * from tx
)
select * from final