{% set financial_aid_acceptance_string = 'Accepts Subsidy' %}
{% set license_monitoring_since_string = 'Monitoring since' %}
{% set phone_number_extra_characters = '()- ' %}
{% set primary_caregiver_delimeter = '\n' %}

with final as (
    select 
        trim(split_part(type_license,'-',1)) as license_type,
        trim(replace(split_part(type_license,'-',2),'K',''))::numeric as license_number, --TODO check assumption
        case when accepts_subsidy = '{{ financial_aid_acceptance_string }}' then 'Y' when accepts_subsidy is null then 'N' else 'Unknown' end as accepts_financial_aid,
        trim(split_part(primary_caregiver,'{{ primary_caregiver_delimeter }}',1)) as contact_name,
        trim(split_part(primary_caregiver,'{{ primary_caregiver_delimeter }}',-1)) as title,
        translate(phone,'{{ phone_number_extra_characters }}','')::varchar as phone,
        email,
        address1,
        address2::varchar,
        city,
        "state",
        zip::varchar,
        total_cap::numeric as capacity,
        ages_accepted_1,
        aa2,
        aa3,
        aa4,
        company,
        trim(split_part(license_monitoring_since,'{{ license_monitoring_since_string }}',2))::date as license_issued -- TODO check assumption
    from {{ ref('base__source2_ok_monthly_extract') }}
)
select * from final