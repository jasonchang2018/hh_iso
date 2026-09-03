create or replace procedure
    edwprodhh.iso.calculate_request()
returns     boolean
language    sql
as
begin


    truncate table edwprodhh.iso.request;

    insert into
        edwprodhh.iso.request
    (
        DEBTOR_IDX,
        RECORD_TYPE,
        CONCAT_NO_RN,
        SORTER_1,
        SORTER_2,
        RN,
        SEQUENCE_NUMBER,
        CONCAT_YES_RN,
        LENGTH_512,
        UPLOAD_DATE
    )
    with eligible as
    (
        with previous_packets as
        (
            select      distinct
                        debtor.packet_idx,
                        dimdebtor.drl
            from        edwprodhh.pub_jchang.master_debtor as debtor
                        left join
                            edwprodhh.dw.dimdebtor as dimdebtor
                            on debtor.debtor_idx = dimdebtor.debtor_idx
                        inner join
                            edwprodhh.iso.request_log as iso_request_log
                            on debtor.debtor_idx = iso_request_log.debtor_idx
            where       iso_request_log.upload_date >= current_date() - 365
        )
        select      debtor.debtor_idx
        from        edwprodhh.pub_jchang.master_debtor as debtor
                    left join
                        edwprodhh.dw.dimdebtor as dimdebtor
                        on debtor.debtor_idx = dimdebtor.debtor_idx
        where       case    when    debtor.pl_group = 'ADVOCATE HC - TPL'
                            then    case    when    dimdebtor.desk in ('LN1')
                                            then    TRUE
                                            else    FALSE
                                            end
                            when    debtor.pl_group = 'IU HEALTH - TPL'
                            then    case    when    debtor.client_idx not in ('HH-2175NLIPB') --exclude PB
                                            and     dimdebtor.desk in ('IU1')
                                            then    TRUE
                                            else    FALSE
                                            end
                            when    debtor.pl_group = 'U OF MISSISSIPPI MEDICAL CENTER - TPL'
                            then    case    when    debtor.client_idx not in ('HH-2170NLIPB', 'HH-2171NLIPB') --exclude PB
                                            and     dimdebtor.desk in ('UM1')
                                            then    TRUE
                                            else    FALSE
                                            end
                            else    FALSE
                            end
                    and debtor.packet_idx   not in (select packet_idx from previous_packets)
                    and dimdebtor.drl       not in (select drl from previous_packets)
                    --** Need to exclude based on values in F303-F310 and F323-330. Waiting on Dan and Heather
        limit       50
    )
    , patient_names as
    (
        select      debtor.debtor_idx,

                    nullif(trim(upper(dimdebtor.spc_fld_1)), '') as fullname,

                    case    when    regexp_like(fullname, '.*\\,.*')
                            then    nullif(trim(regexp_substr(fullname, '^([^,]*)', 1, 1, 'e')), '')
                            else    nullif(trim(regexp_substr(fullname, '(([^\\s]*)([\\,\\s]+(JR|SR|I+)\\.?)?)$', 1, 1, 'e')), '')
                            end     as lastname,

                    case    when    regexp_like(fullname, '.**\\,.*')
                            then    nullif(trim(regexp_replace(replace(fullname, lastname, ''), '^\\s*\\,\\s*')), '')
                            else    nullif(trim(replace(fullname, lastname, '')), '')
                            end     as non_lastname,

                    case    when    regexp_like(non_lastname, '.*\\s.*')
                            then    regexp_substr(non_lastname, '([^\\s]*)$', 1, 1, 'e')
                            end     as middlename,

                    case    when    regexp_like(non_lastname, '.*\\s.*')
                            then    nullif(trim(left(non_lastname, length(non_lastname) - length(middlename))), '')
                            else    non_lastname
                            end     as firstname

        from        edwprodhh.pub_jchang.master_debtor as debtor
                    inner join
                        eligible
                        on debtor.debtor_idx = eligible.debtor_idx
                    left join
                        edwprodhh.dw.dimdebtor as dimdebtor
                        on debtor.debtor_idx = dimdebtor.debtor_idx

    )
    , uh01 as
    (
        with fields as
        (
            select      ''                                                                                  as debtor_idx,
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
            select      debtor.debtor_idx,
                        'UA01'                                                                                  as record_type,
                        
                        rpad(left('I',                                                      1),     1,  ' ')    as report_type, --*
                        rpad(left('H39500001',                                              9),     9,  ' ')    as customer_code, --*
                        
                        case    when    debtor.pl_group = 'U OF MISSISSIPPI MEDICAL CENTER - TPL'   then    rpad(left('UMMC'  || coalesce(dimdebtor.drl, ''),                     30),   30,  ' ')
                                when    debtor.pl_group = 'IU HEALTH - TPL'                         then    rpad(left('IU'    || coalesce(dimdebtor.drl, ''),                     30),   30,  ' ')
                                when    debtor.pl_group = 'ADVOCATE HC - TPL'                       then    rpad(left('ADV'   || trim(ltrim(coalesce(dimdebtor.drl, ''), '0')),   30),   30,  ' ')
                                else    NULL
                                end                                                                             as policy_number, --*

                        rpad(left('PAPP',                                                   4),     4,  ' ')    as policy_type, --*
                        rpad(left('',                                                       8),     8,  ' ')    as policy_inception_date,
                        rpad(left('',                                                       8),     8,  ' ')    as policy_expiration_date,
                        rpad(left('',                                                       1),     1,  ' ')    as policy_renewal_indicator,
                        rpad(left('',                                                       1),     1,  ' ')    as assigned_risk_policy_indicator,
                        rpad(left(coalesce(policy_number, ''),                              30),    30, ' ')    as claim_number, --*
                        rpad(left(coalesce(to_varchar(debtor.lst_chg_dt, 'MMDDYYYY'), ''),  8),     8,  ' ')    as date_of_loss, --*
                        rpad(left('',                                                       4),     4,  ' ')    as time_of_loss,
                        rpad(left('',                                                       1),     1,  ' ')    as cat_indicator,
                        rpad(left('',                                                       3),     3,  ' ')    as cat_number,
                        rpad(left('',                                                       8),     8,  ' ')    as company_received_date,
                        rpad(left('',                                                       50),    50, ' ')    as loss_description,
                        rpad(left('',                                                       50),    50, ' ')    as location_of_loss_address_1,
                        rpad(left('',                                                       50),    50, ' ')    as location_of_loss_address_2,
                        rpad(left('',                                                       25),    25, ' ')    as location_of_loss_city,
                        rpad(left(coalesce(debtor.state, ''),                               2),     2,  ' ')    as location_of_loss_state,
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

            from        edwprodhh.pub_jchang.master_debtor as debtor
                        inner join
                            eligible
                            on debtor.debtor_idx = eligible.debtor_idx
                        left join
                            edwprodhh.dw.dimdebtor as dimdebtor
                            on debtor.debtor_idx = dimdebtor.debtor_idx
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
            select      debtor.debtor_idx,
                        'UO01'                                                                                  as record_type,

                        rpad(left('CI',                                                                 2),     2,      ' ')    as role_in_the_claim, --* Confirm how to determine this? doc/Appendix 2
                        rpad(left('I',                                                                  1),     1,      ' ')    as individual_business_indicator, --*

                        case    when    individual_business_indicator = 'I'
                                then    ''
                                else    rpad(left('',                                                       70),    70,     ' ')
                                end     as business_name, --*
                                
                        case    when    individual_business_indicator = 'I'
                                then    rpad(left(coalesce(patient_names.lastname, debtor.lastname, ''),    30),    30,     ' ')
                                else    ''
                                end     as last_name, --*
                                
                        case    when    individual_business_indicator = 'I'
                                then    rpad(left(coalesce(patient_names.firstname, debtor.firstname, ''),  20),    20,     ' ')
                                else    ''
                                end     as first_name, --*
                                
                        case    when    individual_business_indicator = 'I'
                                then    rpad(left('',                                                       20),    20,     ' ')
                                else    ''
                                end     as middle_name, --*

                        rpad(left(coalesce(to_varchar(
                            coalesce(
                                dimdebtor.dob,
                                DIMFISCAL_HH_A.DOB_F16,
                                DIMFISCAL_HH_B.PATIENT_DOB,
                                DIMFISCAL_HH_D.DOB_F1169
                            ), 'MMDDYYYY'), ''),                                                                    8),     8,      ' ')    as date_of_birth, --*
                        rpad(left('',                                                                               1),     1,      ' ')    as gender,
                        -- rpad(left(coalesce(dimdebtor.ssn, ''),                                                      9),     9,      ' ')    as social_security_number, --* jeff needs to unmask
                        rpad(left('',                                                                               9),     9,      ' ')    as social_security_number, --* jeff needs to unmask
                        rpad(left('',                                                                               9),     9,      ' ')    as tax_identification_number,
                        rpad(left('',                                                                               20),    20,     ' ')    as drivers_license_number,
                        rpad(left('',                                                                               2),     2,      ' ')    as drivers_license_state,
                        rpad(left('',                                                                               50),    50,     ' ')    as occupation_rating,
                        rpad(left('',                                                                               15),    15,     ' ')    as medical_professional_license,
                        rpad(left(coalesce(debtor.address_1, ''),                                                   50),    50,     ' ')    as address_information_line_1, --*
                        rpad(left('',                                                                               50),    50,     ' ')    as address_information_line_2,
                        rpad(left(trim(regexp_substr(coalesce(debtor.city, ''), '^[^\\,]*')),                       25),    25,     ' ')    as city, --*
                        rpad(left(coalesce(debtor.state, ''),                                                       2),     2,      ' ')    as state, --*
                        rpad(left(coalesce(debtor.zip_code, ''),                                                    9),     9,      ' ')    as postal_code, --*
                        rpad(left('',                                                                               3),     3,      ' ')    as country_code,
                        rpad(left(coalesce(edwprodhh.pub_jchang.contact_address_format_phone(dimdebtor.phone), ''), 10),    10,     ' ')    as home_telephone, --*
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

            from        edwprodhh.pub_jchang.master_debtor as debtor
                        inner join
                            eligible
                            on debtor.debtor_idx = eligible.debtor_idx
                        left join
                            edwprodhh.dw.dimdebtor as dimdebtor
                            on debtor.debtor_idx = dimdebtor.debtor_idx
                        left join
                            edwprodhh.dw.dimfiscal_hh_a as dimfiscal_hh_a
                            on dimdebtor.debtor_idx = dimfiscal_hh_a.debtor_idx
                        left join
                            edwprodhh.dw.dimfiscal_hh_b as dimfiscal_hh_b
                            on dimdebtor.debtor_idx = dimfiscal_hh_b.debtor_idx
                        left join
                            edwprodhh.dw.dimfiscal_hh_d as dimfiscal_hh_d
                            on dimdebtor.debtor_idx = dimfiscal_hh_d.debtor_idx
                        left join
                            patient_names
                            on debtor.debtor_idx = patient_names.debtor_idx
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
            select      debtor.debtor_idx,
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
                        
                        

            from        edwprodhh.pub_jchang.master_debtor as debtor
                        inner join
                            eligible
                            on debtor.debtor_idx = eligible.debtor_idx
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
            select      ''                                                                                  as debtor_idx,
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
                    length(concat_yes_rn) = 512                                             as length_512,
                    current_date() + 1                                                      as upload_date
                    
        from        unioned_post_trailer
        order by    rn
    )
    select      debtor_idx,
                record_type,
                concat_no_rn,
                sorter_1,
                sorter_2,
                rn,
                sequence_number,
                concat_yes_rn,
                length_512,
                upload_date
    from        sorters
    order by    rn
    ;


    insert into
        edwprodhh.iso.request_log
    (
        DEBTOR_IDX,
        RECORD_TYPE,
        CONCAT_NO_RN,
        SORTER_1,
        SORTER_2,
        RN,
        SEQUENCE_NUMBER,
        CONCAT_YES_RN,
        LENGTH_512,
        UPLOAD_DATE
    )
    select      debtor_idx,
                record_type,
                concat_no_rn,
                sorter_1,
                sorter_2,
                rn,
                sequence_number,
                concat_yes_rn,
                length_512,
                upload_date
    from        edwprodhh.iso.request
    order by    rn
    ;


end
;



create table
    edwprodhh.iso.request_log
(
    DEBTOR_IDX          VARCHAR(50),
    RECORD_TYPE         VARCHAR(4),
    CONCAT_NO_RN        VARCHAR(16777216),
    SORTER_1            NUMBER(1,0),
    SORTER_2            NUMBER(2,0),
    RN                  NUMBER(18,0),
    SEQUENCE_NUMBER     VARCHAR(16777216),
    CONCAT_YES_RN       VARCHAR(16777216),
    LENGTH_512          BOOLEAN,
    UPLOAD_DATE         DATE
)
;



create or replace view
    edwprodhh.iso.request_export
as
select      concat_yes_rn
from        edwprodhh.iso.request_log
where       upload_date = current_date()
order by    rn
;



create or replace task
    edwprodhh.iso.sp_calculate_request
    warehouse = analysis_wh
    after edwprodhh.iso.iso_root
as
call    edwprodhh.iso.calculate_request()
;