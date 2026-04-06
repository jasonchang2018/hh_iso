create or replace temp table
    edwprodhh.pub_jchang.temp_iso_test_fields
as
select      'A'                         as debtor_idx,
            'PETRO'                     as first_name,
            'STABILE'                   as last_name,
            '74-05 64TH LN'             as address_1,
            NULL                        as address_2,
            'GLENDALE'                  as city,
            'NY'                        as state,
            NULL                        as zip_code,
            NULL                        as dob,
            '209-777-9981'              as phone_number,
            'KREST03_S@YAHOO.COM'       as email_address,
            'A1A1'                      as drl,
            '2025-01-01'                as lst_chg_dt
union all
select      'B'                         as debtor_idx,
            'JIMJON'                    as first_name,
            'JACKSON'                   as last_name,
            '3 E MAIN ST'               as address_1,
            NULL                        as address_2,
            'CHICAGO HEIGHTS'           as city,
            'IL'                        as state,
            NULL                        as zip_code,
            '01/01/1990'                as dob,
            '987-234-9873'              as phone_number,
            NULL                        as email_address,
            'B2B2'                      as drl,
            '2025-02-01'                as lst_chg_dt
union all
select      'C'                         as debtor_idx,
            'MODENN'                    as first_name,
            'JACKSON'                   as last_name,
            '18654 GIRAFF STREET'       as address_1,
            NULL                        as address_2,
            'ALBION'                    as city,
            NULL                        as state,
            NULL                        as zip_code,
            NULL                        as dob,
            '987-234-9873'              as phone_number,
            'KREST03_S@YAHOO.COM'       as email_address,
            'C3C3'                      as drl,
            '2025-03-01'                as lst_chg_dt
union all
select      'D'                         as debtor_idx,
            'YUMAIKEL'                  as first_name,
            'ZAMBRANO SANTOS'           as last_name,
            '8955 BROADWAY ST.'         as address_1,
            'UNIT 10173'                as address_2,
            'HOUSTON'                   as city,
            'TX'                        as state,
            '77061'                     as zip_code,
            '12/11/1988'                as dob,
            NULL                        as phone_number,
            NULL                        as email_address,
            'D4D4'                      as drl,
            '2025-04-01'                as lst_chg_dt
;



with uh01 as
(
    with fields as
    (
        select      '' as debtor_idx,
                    'UH01'                                                                              as record_type,

                    rpad(left('H39500001',                                      9),     9,      ' ')    as customer_code, --*
                    rpad(left(to_varchar(current_timestamp(), 'YYYYMMDD'),      8),     8,      ' ')    as process_date, --*
                    rpad(left(to_varchar(current_timestamp(), 'hh24miss'),      6),     6,      ' ')    as transmission_time, --*
                    rpad(left('US01',                                           4),     4,      ' ')    as version, --*
                    rpad(left('',                                               475),   475,    ' ')    as filler --*
    )
    --array_to_string(array_construct_compact(*), '') converts NULLs to empty string, so I don't have to add COALESCE() to each term.
    --array_to_string(array_construct_compact(*), '') returns a NULL if any term is NULL.
    select      debtor_idx,
                record_type,
                regexp_replace(array_to_string(array_construct_compact(*), ''), '^' || debtor_idx, '') as concat_no_rn,
    from        fields
)
, ua01 as
(
    with fields as
    (
        select      debtor_idx,
                    'UA01'                                                                                  as record_type,
                    
                    rpad(left('I',                                                      1),     1,  ' ')    as report_type, --*
                    rpad(left('H39500001',                                              9),     9,  ' ')    as customer_code, --*
                    rpad(left('UMMC'  || coalesce(drl, ''),                             30),   30,  ' ')    as policy_number, --*
                    rpad(left('PAPP',                                                   4),     4,  ' ')    as policy_type, --*
                    rpad(left('',                                                       8),     8,  ' ')    as policy_inception_date,
                    rpad(left('',                                                       8),     8,  ' ')    as policy_expiration_date,
                    rpad(left('',                                                       1),     1,  ' ')    as policy_renewal_indicator,
                    rpad(left('',                                                       1),     1,  ' ')    as assigned_risk_policy_indicator,
                    rpad(left(coalesce(policy_number, ''),                              30),    30, ' ')    as claim_number, --*
                    rpad(left(coalesce(to_varchar(lst_chg_dt::date, 'MMDDYYYY'), ''),   8),     8,  ' ')    as date_of_loss, --*
                    rpad(left('',                                                       4),     4,  ' ')    as time_of_loss,
                    rpad(left('',                                                       1),     1,  ' ')    as cat_indicator,
                    rpad(left('',                                                       3),     3,  ' ')    as cat_number,
                    rpad(left('',                                                       8),     8,  ' ')    as company_received_date,
                    rpad(left('',                                                       50),    50, ' ')    as loss_description,
                    rpad(left('',                                                       50),    50, ' ')    as location_of_loss_address_1,
                    rpad(left('',                                                       50),    50, ' ')    as location_of_loss_address_2,
                    rpad(left('',                                                       25),    25, ' ')    as location_of_loss_city,
                    rpad(left(coalesce(state, ''),                                      2),     2,  ' ')    as location_of_loss_state,
                    rpad(left('',                                                       9),     9,  ' ')    as location_of_loss_postal_code,
                    rpad(left('',                                                       3),     3,  ' ')    as location_of_loss_country,
                    rpad(left('',                                                       4),     4,  ' ')    as filler, --*
                    rpad(left('',                                                       35),    35, ' ')    as agency_notified_of_loss,
                    rpad(left('',                                                       15),    15, ' ')    as police_fire_report_case_number,
                    rpad(left('',                                                       20),    20, ' ')    as routing_misc_info_area,
                    rpad(left('',                                                       1),     1,  ' ')    as no_search_indicator,
                    rpad(left('',                                                       8),     8,  ' ')    as date_of_first_claim_payment,
                    rpad(left('',                                                       1),     1,  ' ')    as _8f_fund_claim,
                    rpad(left('',                                                       50),    50, ' ')    as vessel_name_call_number,
                    rpad(left('',                                                       1),     1,  ' ')    as filler, --*
                    rpad(left('',                                                       1),     1,  ' ')    as legacy_conversion_indicator,
                    rpad(left('',                                                       1),     1,  ' ')    as request_claim_scoring_indicator,
                    rpad(left('',                                                       1),     1,  ' ')    as police_report_in_this_occurrence_indicator,
                    rpad(left('',                                                       1),     1,  ' ')    as single_vehicle_accident_indicator,
                    rpad(left('',                                                       1),     1,  ' ')    as phantom_vehicle_accident_indicator,
                    rpad(left('',                                                       1),     1,  ' ')    as was_the_accident_witnessed,
                    rpad(left('',                                                       1),     1,  ' ')    as is_mold_damage_being_claimed_in_addition_to_the_coverage_and_loss_being_reported,
                    rpad(left('',                                                       1),     1,  ' ')    as filler,
                    rpad(left('',                                                       2),     2,  ' ')    as filler,
                    rpad(left('',                                                       1),     1,  ' ')    as hit_and_run_indicator,
                    rpad(left('',                                                       1),     1,  ' ')    as request_recall_information_indicator,
                    rpad(left('',                                                       1),     1,  ' ')    as mass_tort_indicator,
                    rpad(left('',                                                       1),     1,  ' ')    as self_insured_indicator,
                    rpad(left('',                                                       9),     9,  ' ')    as cobc_assigned_section_111_reporter_id,
                    rpad(left('',                                                       9),     9,  ' ')    as tax_identification_number,
                    rpad(left('',                                                       9),     9,  ' ')    as site_id,
                    rpad(left('',                                                       7),     7,  ' ')    as nmvtis_operators_reporting_entity_id,
                    rpad(left('',                                                       9),     9,  ' ')    as filler,
                    rpad(left('',                                                       5),     5,  ' ')    as filler

        from        edwprodhh.pub_jchang.temp_iso_test_fields
    )
    select      debtor_idx,
                record_type,
                regexp_replace(array_to_string(array_construct_compact(*), ''), '^' || debtor_idx, '') as concat_no_rn,
    from        fields
)
, uo01 as
(
    with fields as
    (
        select      debtor_idx,
                    'UO01'                                                                                  as record_type,

                    rpad(left('CI',                                                                 2),     2,      ' ')    as role_in_the_claim, --* Confirm how to determine this? doc/Appendix 2
                    rpad(left('I',                                                                  1),     1,      ' ')    as individual_business_indicator, --*

                    case    when    individual_business_indicator = 'I'
                            then    ''
                            else    rpad(left('',                                                   70),    70,     ' ')
                            end     as business_name, --*
                            
                    case    when    individual_business_indicator = 'I'
                            then    rpad(left(coalesce(last_name, ''),                              30),    30,     ' ')
                            else    ''
                            end     as last_name, --*
                            
                    case    when    individual_business_indicator = 'I'
                            then    rpad(left(coalesce(first_name, ''),                             20),    20,     ' ')
                            else    ''
                            end     as first_name, --*
                            
                    case    when    individual_business_indicator = 'I'
                            then    rpad(left('',                                                   20),    20,     ' ')
                            else    ''
                            end     as middle_name, --*

                    rpad(left(coalesce(to_varchar(dob::date, 'MMDDYYYY'), ''),                                  8),     8,      ' ')    as date_of_birth, --*
                    rpad(left('',                                                                               1),     1,      ' ')    as gender,
                    rpad(left('',                                                                               9),     9,      ' ')    as social_security_number, --* jeff needs to unmask
                    rpad(left('',                                                                               9),     9,      ' ')    as tax_identification_number,
                    rpad(left('',                                                                               20),    20,     ' ')    as drivers_license_number,
                    rpad(left('',                                                                               2),     2,      ' ')    as drivers_license_state,
                    rpad(left('',                                                                               50),    50,     ' ')    as occupation_rating,
                    rpad(left('',                                                                               15),    15,     ' ')    as medical_professional_license,
                    rpad(left(coalesce(address_1, ''),                                                          50),    50,     ' ')    as address_information_line_1, --*
                    rpad(left(coalesce(address_2, ''),                                                          50),    50,     ' ')    as address_information_line_2,
                    rpad(left(trim(regexp_substr(coalesce(city, ''), '^[^\\,]*')),                              25),    25,     ' ')    as city, --*
                    rpad(left(coalesce(state, ''),                                                              2),     2,      ' ')    as state, --*
                    rpad(left(coalesce(zip_code, ''),                                                           9),     9,      ' ')    as postal_code, --*
                    rpad(left('',                                                                               3),     3,      ' ')    as country_code,
                    rpad(left(coalesce(edwprodhh.pub_jchang.contact_address_format_phone(phone_number), ''),    10),    10,     ' ')    as home_telephone, --*
                    rpad(left('',                                                                               10),    10,     ' ')    as business_telephone,
                    rpad(left('',                                                                               10),    10,     ' ')    as cellular_telephone,
                    rpad(left('',                                                                               10),    10,     ' ')    as pager_number,
                    rpad(left('',                                                                               7),     7,      ' ')    as pager_pin,
                    rpad(left('',                                                                               2),     2,      ' ')    as vehicle_operator_relationship_to_owner,
                    rpad(left('',                                                                               2),     2,      ' ')    as filler, --*
                    rpad(left('',                                                                               1),     1,      ' ')    as no_search_indicator,
                    rpad(left('',                                                                               9),     9,      ' ')    as passport_number,
                    rpad(left('',                                                                               5),     5,      ' ')    as routing_misc_information,
                    rpad(left('',                                                                               20),    20,     ' ')    as vehicle_this_party_was_occupant_of,
                    rpad(left('',                                                                               8),     8,      ' ')    as date_this_party_reported_the_loss,
                    rpad(left('',                                                                               10),    10,     ' ')    as fax_number,
                    rpad(left('',                                                                               1),     1,      ' ')    as search_party_in_csln_ocse_database_indicator,
                    rpad(left('',                                                                               1),     1,      ' ')    as filler, --*
                    rpad(left('',                                                                               70),    70,     ' ')    as filler --*

        from        edwprodhh.pub_jchang.temp_iso_test_fields
    )
    select      debtor_idx,
                record_type,
                regexp_replace(array_to_string(array_construct_compact(*), ''), '^' || debtor_idx, '') as concat_no_rn,
    from        fields
)
, uc01 as
(
    with fields as
    (
        select      debtor_idx,
                    'UC01'                                                                                  as record_type,

                    rpad(left('',               9),     9,      ' ')    as filler,
                    rpad(left('',               30),    30,     ' ')    as adjuster_last_name,
                    rpad(left('',               20),    20,     ' ')    as adjuster_first_name,
                    rpad(left('',               20),    20,     ' ')    as adjuster_middle_initial_name,
                    rpad(left('',               10),    10,     ' ')    as adjuster_telephone_number,
                    rpad(left('MPAY',           4),     4,      ' ')    as loss_type, --* Confirm this with Heather. Maybe I need to submit multiple claims with different codes? Appendix A
                    rpad(left('MPAY',           4),     4,      ' ')    as coverage_type, --* Confirm this with Heather. Maybe I need to submit multiple claims with different codes? Appendix A
                    rpad(left('Auto Accident',  50),    50,     ' ')    as alleged_injuries_property_damage, --*
                    rpad(left('',               2),     2,      ' ')    as part_of_body,
                    rpad(left('',               3),     3,      ' ')    as filler, --*
                    rpad(left('',               3),     3,      ' ')    as claim_status,
                    rpad(left('',               2),     2,      ' ')    as tort_threshold_type,
                    rpad(left('',               2),     2,      ' ')    as tort_threshold_state,
                    rpad(left('',               1),     1,      ' ')    as suit_indicator,
                    rpad(left('',               11),    11,     ' ')    as estimated_loss_amount,
                    rpad(left('',               11),    11,     ' ')    as reserve_amount,
                    rpad(left('',               11),    11,     ' ')    as settlement_amount,
                    rpad(left('',               8),     8,      ' ')    as date_claim_closed,
                    rpad(left('',               20),    20,     ' ')    as routing_miscellaneous_information,
                    rpad(left('',               8),     8,      ' ')    as loss_time_start_date,
                    rpad(left('',               8),     8,      ' ')    as loss_time_end_date,
                    rpad(left('',               5),     5,      ' ')    as total_lost_days,
                    rpad(left('',               10),    10,     ' ')    as court_filed,
                    rpad(left('',               8),     8,      ' ')    as court_filed_date,
                    rpad(left('',               1),     1,      ' ')    as was_there_physical_damage_to_the_vehicle_this_person_was_occupant_of,
                    rpad(left('',               6),     6,      ' ')    as icd_9_code,
                    rpad(left('',               6),     6,      ' ')    as icd_9_code,
                    rpad(left('',               6),     6,      ' ')    as icd_9_code,
                    rpad(left('',               6),     6,      ' ')    as icd_9_code,
                    rpad(left('',               6),     6,      ' ')    as icd_9_code,
                    rpad(left('',               1),     1,      ' ')    as was_the_death_a_result_of_the_injury,
                    rpad(left('',               8),     8,      ' ')    as date_of_attorney_involvement,
                    rpad(left('',               8),     8,      ' ')    as date_of_notice_to_employer,
                    rpad(left('',               5),     5,      ' ')    as cpt_code,
                    rpad(left('',               3),     3,      ' ')    as benefit_type_code,
                    rpad(left('',               2),     2,      ' ')    as employment_status_code,
                    rpad(left('',               8),     8,      ' ')    as date_of_retirement,
                    rpad(left('',               8),     8,      ' ')    as date_of_strike,
                    rpad(left('',               1),     1,      ' ')    as pre_existing_disability_code,
                    rpad(left('',               1),     1,      ' ')    as was_this_person_employed_by_the_insured_at_the_time_of_loss,
                    rpad(left('',               8),     8,      ' ')    as employee_date_of_hire,
                    rpad(left('',               8),     8,      ' ')    as date_terminated_or_laid_off,
                    rpad(left('',               1),     1,      ' ')    as was_an_ambulance_service_used,
                    rpad(left('',               1),     1,      ' ')    as involved_party_disabled_as_part_of_accident,
                    rpad(left('',               11),    11,     ' ')    as paid_amount_for_medical_bills,
                    rpad(left('',               11),    11,     ' ')    as paid_amount_for_indemnity,
                    rpad(left('',               11),    11,     ' ')    as total_paid_amount_for_loss,
                    rpad(left('',               25),    25,     ' ')    as court_county,
                    rpad(left('',               2),     2,      ' ')    as court_state,
                    rpad(left('',               22),    22,     ' ')    as docket_number,
                    rpad(left('',               50),    50,     ' ')    as adjuster_email_address,
                    rpad(left('',               1),     1,      ' ')    as erisa_claim_indicator,
                    rpad(left('',               12),    12,     ' ')    as filler,
                    rpad(left('',               3),     3,      ' ')    as filler --*
                    
                    

        from        edwprodhh.pub_jchang.temp_iso_test_fields
    )
    select      debtor_idx,
                record_type,
                regexp_replace(array_to_string(array_construct_compact(*), ''), '^' || debtor_idx, '') as concat_no_rn,
    from        fields
)
, unioned_pre_trailer as
(
    select      *
    from        uh01
    union all   
    select      *
    from        ua01
    union all   
    select      *
    from        uo01
    union all   
    select      *
    from        uc01
)
, uz01 as
(
    with fields as
    (
        select      '' as debtor_idx,
                    'UZ01'                                                                              as record_type,

                    -- lpad(left('123',                                            6),     6,      '0')    as records_transmitted, --*
                    lpad(left((select count(*) from unioned_pre_trailer) + 1,   6),     6,      '0')    as records_transmitted, --*
                    rpad(left('',                                               496),   496,    ' ')    as filler --*
    )
    select      debtor_idx,
                record_type,
                regexp_replace(array_to_string(array_construct_compact(*), ''), '^' || debtor_idx, '') as concat_no_rn,
    from        fields
)
, unioned_post_trailer as
(
    select      *
    from        unioned_pre_trailer
    union all   
    select      *
    from        uz01
)
, sorters as
(
    select      *,

                case    when    record_type = 'UH01'                    then    1
                        when    record_type = 'UZ01'                    then    3
                        when    record_type not in ('UH01', 'UZ01')     then    2
                        end                                                             as sorter_1,

                case    when    record_type = 'UA01'                    then    1
                        when    record_type = 'UA03'                    then    2
                        when    record_type = 'UA07'                    then    3
                        when    record_type = 'UO01'                    then    4
                        when    record_type = 'UEX1'                    then    5
                        when    record_type = 'UK01'                    then    6
                        when    record_type = 'UV01'                    then    7
                        when    record_type = 'UV16'                    then    8
                        when    record_type = 'UC01'                    then    9
                        when    record_type = 'UEX3'                    then    10
                        when    record_type = 'UEX4'                    then    11
                        when    record_type = 'UO01'                    then    12
                        end                                                             as sorter_2,

                row_number() over (order by sorter_1, debtor_idx, sorter_2)             as rn,
                lpad(rn, 6, '0')                                                        as sequence_number,
                concat_ws('', sequence_number, concat_no_rn)                            as concat_yes_rn,
                length(concat_yes_rn) = 512                                             as length_512
                
    from        unioned_post_trailer
    order by    rn
)
select      concat_yes_rn
from        sorters
order by    rn
;