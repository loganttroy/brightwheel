create database brightwheel;
create schema salesforce;
create table brightwheel.salesforce.brightwheel_salesforce_leads
(
    id	int,
    is_deleted varchar,
    last_name varchar,
    first_name varchar,
    title varchar,
    company varchar,
    street varchar,
    city varchar,
    state varchar,
    postal_code varchar,
    country varchar,
    phone varchar,
    mobile_phone varchar,
    email varchar,
    website varchar,
    lead_source varchar,
    status varchar,
    is_converted varchar,
    created_date timestamp,
    last_modified_date timestamp,
    last_activity_date timestamp,
    last_viewed_date timestamp,
    last_referenced_date timestamp,
    email_bounced_reason varchar,
    email_bounced_date timestamp,
    outreach_stage_c varchar,
    current_enrollment_c int,
    capacity_c int,
    lead_source_last_updated_c timestamp,
    brightwheel_school_uuid_c int
);
copy brightwheel.salesforce.brightwheel_salesforce_leads from '<your_repo_path>/existing_salesforce_leads.csv' with (format csv, header true);