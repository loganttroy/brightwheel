# Overview
This repo is an analysis pipeline sor sales-leads at Brightwheel, as part of the Analytics Engineer interview process. As I have understood the prompt, the goal is to aggregate existing Salesforce leads along with monthly extract upsert files for analysis. While this common schema could allow overwriting the Salesforce source of truth for leads (and presumably this process does happen monthly), the schema here would need some slight adjustment to be backwards-compatible with the Salesforce schema.

# Personal notes
I'll admit it was challenging to focus my development at an appropriate level for this exercise given the precision of some aspects of the instructions (e.g. exact coalesced schema), but the vagueness of other parts (e.g. ontological definitions). The time constraint was also particularly challenging given the process of setting my personal computer up for development, and standing up a brand new dbt project. I've obviously done both before, but it was a challenge to not have various macros and tests that I've written into the dbt projects I work on. That said, I'm happy having gotten to a reasonably complete final consolidated schema, and hopefully this write-up will shed more light on where I would take this project with more time!

# Setup
- This is a Postgres-specific implementation
- I have included the monthly extract files as dbt 'seed' files here for simplicity and evaluation. To do so, I manipulated the column headers locally and would expected similar behavior from the monthly load into our database
- The existing Salesforce leads were loaded directly to the Postgres database to exhibit dbt's source-tracking functionality
- Postgres setup instructions are found in the appendix file 'postgres_setup.sql'

# Tradeoffs
As expected, the coding exercise was aimed at quickly consolidating leads for analysis in a common schema; the more complex ELT and incremental/CDC/upsert logic was not covered, but will be discussed in the 'Next steps' section. Even within the coding exercise, some tradeoffs had to be made:
- Focusing on following dbt's style guide (e.g. abstracting strings out to Jinja variables) as much as possible to keep the code maintainable
- Erring on the side of certainty with field-mappings and business logic to ensure trust with the business, especially given the absence of an accessible stakeholder or more context to iterate with. This has resulted in certain columns remaining blank when the ontology is not clear, e.g. the "operator" field vs. "company"

# Assumptions
These assumptions are notated in the codebase as well, but consolidated here for review
- "License monitoring since" field in source 2 lists the date the license was issued
- I have trimmed license numbers of any non-numeric characters as the spec requests a numeric datatype, making the assumption that the leading 'K' for source 2 is unnecessary and that source 1's credential numbers are still unique after removing the '-'
- That 'text' (my implementation) is an acceptable substitute for 'varchar' (the spec) given that they are compatible and have the same underlying implementation in Postgres

# Next steps
Next steps center around some main themes: 
1) Industrializing the incremental upsert process for high data volumes
    - Discussed in 'Production strategy' section
2) Expanding business logic and field mappings for a more complete data schema
    - Source 1 (NV)'s address1 and city data are left blank, but should be inferred by splitting the full address field on a list of expected roadway names (i.e. 'Road','RD','AVE','Avenue', etc.) given there is no delimiting comma
    - Source 1's first_name and last_name fields were left blank because the 'primary_contact' often includes multiple individuals, some of whom don't have both names given. However, each record does have at least one individual's full name listed; these names could be extracted by splitting the field by commas, &'s, and 'and's and taking the first occurance of a full name.
    - The 'ages served', min_age, and max_age fields was left blank but could be extracted for source 2 by concatenating the 'ages allowed' fields and doing a containment check for the enumerated strings and their age ranges. For source 3, we could do a simpler mapping from the one-hot age columns (assuming the column descriptions of 'Infant', 'Toddler', etc. have the same age range as source lists)
    - The 'schedule' field is blank, but only source 2 provides schedule info; depending what stakeholders care about most (i.e. weekend vs weekday, summer or no, daily hours), we could complete the field, or expand and add more fields
    - Source 2's county field is empty but could probably be inferred by its zip code if we added a mapping file to the dbt project as a seed file and then joined to enrich the source 2 data
    - Likewise, source 1 and 3's address info could be verified against the zip by a similar process
3) Increasing test coverage of pipelines/data validation of source data
- Checking data for valid phone numbers/emails
- Enforcing non-null and unique checks on any surrogate keys used for our productionized system
4) Suggesting data enrichment ideas
- Since the business wants leads to be available for outreach, our underlying data sources should maybe require the 'email' field--right now, many are null
- The data here is not actually uploaded back to Salesforce, but given the business's questions, it seems that the data model should be loaded back, and that the current timestamp should be imputed for the current_date field

# Production strategy
A robust production strategy was not implemented in this exercise due to various complexities that must be addresssed, including:
- Undefined keys for data extracts making it difficult to determine which records to update based on monthly extracts (the spec recommends address-phone, but doesn't provide guidance for when a lead's address or phone number changes)
- Data volume (100GB) making a brute-force (column-by-column check) upsert unwise
- Additionally, it was my interpretation that the monthly files include *unaltered records from previous months*, given the instruction that they are each ~100GBs. If the file already includes only updated/new records, then it may be more feasible to do a brute-force upsert without needing to define a well-formed surrogate key

To implement a robust production strategy, I would recommend the following:
- Work with stakeholders to define the fields that should uniquely key a "lead" in Salesforce (e.g. license #)
- Implement our 'publish__updated_salesforce_leads' model with dbt's incremental logic, inserting new leads and updating leads that have changed in the underlying extract files

# Other considerations
- Some column names (e.g. 'state') in the spec are reserved words in Postgres and should be changed
- Existing Salesforce data was not cleaned, only monthly extracts were cleaned