create or replace procedure
    edwprodhh.iso.update_service_provider_echo()
returns     boolean
language    sql
as
begin

    truncate table edwprodhh.iso.service_provider_echo;

    insert into
        edwprodhh.iso.service_provider_echo
    (
        RESPONSE_ID,
        INDEX_MA01,
        INDEX_MO01,
        INDEX_MSP1,
        ROLE_IN_THE_CLAIM,
        INDIVIDUAL_BUSINESS_INDICATOR,
        BUSINESS_NAME_OR,
        LAST_NAME,
        FIRST_NAME,
        MIDDLE_NAME,
        DATE_OF_BIRTH_DOB,
        GENDER,
        SOCIAL_SECURITY_NUMBER_SSN,
        SSN_CODE,
        SSN_ISSUED_FROM_DATE,
        SSN_ISSUED_TO_DATE,
        SSN_ISSUING_STATE,
        TAX_IDENTIFICATION_NUMBER_TIN,
        TIN_CODE,
        TIN_ISSUING_CITY,
        TIN_ISSUING_STATE,
        DRIVERS_LICENSE_NUMBER,
        DRIVERS_LICENSE_STATE,
        MEDICAL_PROFESSIONAL_LICENSE,
        ADDRESS_INFORMATION_LINE_1,
        ADDRESS_INFORMATION_LINE_2,
        CITY,
        STATE,
        POSTAL_CODE,
        COUNTRY_CODE,
        HOME_TELEPHONE,
        BUSINESS_TELEPHONE,
        CELLULAR_TELEPHONE,
        PAGER_NUMBER,
        PAGER_PIN,
        DATE_OF_FIRST_DOCTOR_VISIT_AFTER_ACCIDENT,
        PARTY_SUBJECT_TO_SIU_INVESTIGATION,
        CLAIM_OR_PART_OF_CLAIM_FOR_THIS_PARTY_NOT_PAID_AFTER_INVESTIGATION,
        PARTY_WAS_SUBJECT_TO_AN_ENFORCEMENT_ACTION_CRIMINAL_INDICTMENT_PROFESSIONAL_DISCIPLINARY_ACTION,
        CLAIM_FOR_THIS_PARTY_MEETS_CRITERIA_FOR_FRAUD_BUREAU_REPORTING,
        PARTY_ASSOCIATED_WITH_NICB_ALERT,
        WAS_DRIVER_DISTRACTED,
        MEDICAID_ELIGIBLE_INDICATOR,
        DATE_OF_DEATH,
        MEDICARE_ELIGIBLE_INDICATOR,
        DO_NOT_SEND_THIS_PARTY_TO_CMS_INDICATOR,
        INJURED_PARTY_HICN_MBI,
        STOP_QUERYING_CMS_TO_DETERMINE_MEDICARE_ELIGIBILITY_FOR_THIS_PARTY,
        EMAIL_ADDRESS,
        DRIVERS_LICENSE_CLASS,
        CLAIMANT_INSURANCE_COMPANY,
        CLAIMANT_POLICY_NUMBER,
        INDIVIDUAL_BUSINESS_INDICATOR_2,
        BUSINESS_NAME_2,
        LAST_NAME_2,
        FIRST_NAME_2,
        MIDDLE_NAME_2,
        DATE_OF_BIRTH_DOB_2,
        GENDER_2,
        SOCIAL_SECURITY_NUMBER_SSN_2,
        SSN_CODE_2,
        SSN_ISSUED_FROM_DATE_2,
        SSN_ISSUED_TO_DATE_2,
        SSN_ISSUING_STATE_2,
        DEATH_MASTER_LAST_NAME_2,
        DEATH_MASTER_FIRST_NAME_2,
        DATE_OF_DEATH_2,
        CITY_OF_DEATH_2,
        STATE_OF_DEATH_2,
        TAX_IDENTIFICATION_NUMBER_TIN_2,
        TIN_CODE_2,
        TIN_ISSUING_CITY_2,
        TIN_ISSUING_STATE_2,
        MEDICAL_PROFESSIONAL_LICENSE_2,
        ADDRESS_INFORMATION_LINE_1_2,
        ADDRESS_INFORMATION_LINE_2_2,
        CITY_2,
        STATE_2,
        POSTAL_CODE_2,
        COUNTRY_CODE_2,
        HOME_TELEPHONE_2,
        BUSINESS_TELEPHONE_2,
        CELLULAR_TELEPHONE_2,
        EMAIL_ADDRESS_2,
        DRIVERS_LICENSE_NUMBER_2,
        DRIVERS_LICENSE_STATE_2,
        DRIVERS_LICENSE_CLASS_2    
    )
    with MSP1 as
    (
        select      response_id,
                    response_line,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    index_mo01,
                    index_msp1,
                    
                    nullif(trim(substring(response_line,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_line,    11,     2)),    '')     as role_in_the_claim,
                    nullif(trim(substring(response_line,    13,     1)),    '')     as individual_business_indicator,
                    nullif(trim(substring(response_line,    14,     70)),   '')     as business_name_or,
                    nullif(trim(substring(response_line,    14,     30)),   '')     as last_name,
                    nullif(trim(substring(response_line,    44,     20)),   '')     as first_name,
                    nullif(trim(substring(response_line,    64,     20)),   '')     as middle_name,
                    nullif(trim(substring(response_line,    84,     8)),    '')     as date_of_birth_dob,
                    nullif(trim(substring(response_line,    92,     1)),    '')     as gender,
                    nullif(trim(substring(response_line,    93,     9)),    '')     as social_security_number_ssn,
                    nullif(trim(substring(response_line,    102,    1)),    '')     as ssn_code,
                    nullif(trim(substring(response_line,    103,    4)),    '')     as ssn_issued_from_date,
                    nullif(trim(substring(response_line,    107,    4)),    '')     as ssn_issued_to_date,
                    nullif(trim(substring(response_line,    111,    2)),    '')     as ssn_issuing_state,
                    nullif(trim(substring(response_line,    113,    9)),    '')     as tax_identification_number_tin,
                    nullif(trim(substring(response_line,    122,    1)),    '')     as tin_code,
                    nullif(trim(substring(response_line,    123,    25)),   '')     as tin_issuing_city,
                    nullif(trim(substring(response_line,    148,    2)),    '')     as tin_issuing_state,
                    nullif(trim(substring(response_line,    150,    20)),   '')     as drivers_license_number,
                    nullif(trim(substring(response_line,    170,    2)),    '')     as drivers_license_state,
                    nullif(trim(substring(response_line,    172,    15)),   '')     as medical_professional_license,
                    nullif(trim(substring(response_line,    187,    50)),   '')     as address_information_line_1,
                    nullif(trim(substring(response_line,    237,    50)),   '')     as address_information_line_2,
                    nullif(trim(substring(response_line,    287,    25)),   '')     as city,
                    nullif(trim(substring(response_line,    312,    2)),    '')     as state,
                    nullif(trim(substring(response_line,    314,    9)),    '')     as postal_code,
                    nullif(trim(substring(response_line,    323,    3)),    '')     as country_code,
                    nullif(trim(substring(response_line,    326,    10)),   '')     as home_telephone,
                    nullif(trim(substring(response_line,    336,    10)),   '')     as business_telephone,
                    nullif(trim(substring(response_line,    346,    10)),   '')     as cellular_telephone,
                    nullif(trim(substring(response_line,    356,    10)),   '')     as pager_number,
                    nullif(trim(substring(response_line,    366,    7)),    '')     as pager_pin,
                    nullif(trim(substring(response_line,    373,    8)),    '')     as date_of_first_doctor_visit_after_accident,
                    nullif(trim(substring(response_line,    381,    132)),  '')     as filler

        from        edwprodhh.iso.response_flat
        where       record_type = 'MSP1'
    )
    , MSP1_MEX1 as
    (
        select      response_id,
                    response_line,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    index_mo01,
                    index_msp1,
                    
                    nullif(trim(substring(response_line,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_line,    11,     1)),    '')     as party_subject_to_siu_investigation,
                    nullif(trim(substring(response_line,    12,     1)),    '')     as claim_or_part_of_claim_for_this_party_not_paid_after_investigation,
                    nullif(trim(substring(response_line,    13,     1)),    '')     as party_was_subject_to_an_enforcement_action_criminal_indictment_professional_disciplinary_action,
                    nullif(trim(substring(response_line,    14,     1)),    '')     as claim_for_this_party_meets_criteria_for_fraud_bureau_reporting,
                    nullif(trim(substring(response_line,    15,     1)),    '')     as party_associated_with_nicb_alert,
                    nullif(trim(substring(response_line,    16,     47)),   '')     as filler,
                    nullif(trim(substring(response_line,    63,     1)),    '')     as was_driver_distracted,
                    nullif(trim(substring(response_line,    64,     1)),    '')     as filler,
                    nullif(trim(substring(response_line,    65,     1)),    '')     as medicaid_eligible_indicator,
                    nullif(trim(substring(response_line,    66,     8)),    '')     as date_of_death,
                    nullif(trim(substring(response_line,    74,     1)),    '')     as medicare_eligible_indicator,
                    nullif(trim(substring(response_line,    75,     1)),    '')     as do_not_send_this_party_to_cms_indicator,
                    nullif(trim(substring(response_line,    76,     12)),   '')     as injured_party_hicn_mbi,
                    nullif(trim(substring(response_line,    88,     1)),    '')     as stop_querying_cms_to_determine_medicare_eligibility_for_this_party,
                    nullif(trim(substring(response_line,    89,     50)),   '')     as email_address,
                    nullif(trim(substring(response_line,    139,    2)),    '')     as drivers_license_class,
                    nullif(trim(substring(response_line,    141,    201)),  '')     as filler,
                    nullif(trim(substring(response_line,    342,    114)),  '')     as filler,
                    nullif(trim(substring(response_line,    456,    30)),   '')     as claimant_insurance_company,
                    nullif(trim(substring(response_line,    486,    25)),   '')     as claimant_policy_number,
                    nullif(trim(substring(response_line,    511,    2)),    '')     as filler

        from        edwprodhh.iso.response_flat
        where       record_type = 'MEX1'
                    and lag_party_indicator = 'MSP1'
    )
    , MSP1_MK01 as
    (
        select      response_id,
                    response_line,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    index_mo01,
                    index_msp1,
                    
                    nullif(trim(substring(response_line,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_line,    11,     1)),    '')     as individual_business_indicator,
                    nullif(trim(substring(response_line,    12,     70)),   '')     as business_name_or,
                    nullif(trim(substring(response_line,    12,     30)),   '')     as last_name,
                    nullif(trim(substring(response_line,    42,     20)),   '')     as first_name,
                    nullif(trim(substring(response_line,    62,     20)),   '')     as middle_name,
                    nullif(trim(substring(response_line,    82,     8)),    '')     as date_of_birth_dob,
                    nullif(trim(substring(response_line,    90,     1)),    '')     as gender,
                    nullif(trim(substring(response_line,    91,     9)),    '')     as social_security_number_ssn,
                    nullif(trim(substring(response_line,    100,    1)),    '')     as ssn_code,
                    nullif(trim(substring(response_line,    101,    4)),    '')     as ssn_issued_from_date,
                    nullif(trim(substring(response_line,    105,    4)),    '')     as ssn_issued_to_date,
                    nullif(trim(substring(response_line,    109,    2)),    '')     as ssn_issuing_state,
                    nullif(trim(substring(response_line,    111,    30)),   '')     as death_master_last_name,
                    nullif(trim(substring(response_line,    141,    20)),   '')     as death_master_first_name,
                    nullif(trim(substring(response_line,    161,    8)),    '')     as date_of_death,
                    nullif(trim(substring(response_line,    169,    25)),   '')     as city_of_death,
                    nullif(trim(substring(response_line,    194,    2)),    '')     as state_of_death,
                    nullif(trim(substring(response_line,    196,    9)),    '')     as tax_identification_number_tin,
                    nullif(trim(substring(response_line,    205,    1)),    '')     as tin_code,
                    nullif(trim(substring(response_line,    206,    25)),   '')     as tin_issuing_city,
                    nullif(trim(substring(response_line,    231,    2)),    '')     as tin_issuing_state,
                    nullif(trim(substring(response_line,    233,    15)),   '')     as medical_professional_license,
                    nullif(trim(substring(response_line,    248,    50)),   '')     as address_information_line_1,
                    nullif(trim(substring(response_line,    298,    50)),   '')     as address_information_line_2,
                    nullif(trim(substring(response_line,    348,    25)),   '')     as city,
                    nullif(trim(substring(response_line,    373,    2)),    '')     as state,
                    nullif(trim(substring(response_line,    375,    9)),    '')     as postal_code,
                    nullif(trim(substring(response_line,    384,    3)),    '')     as country_code,
                    nullif(trim(substring(response_line,    387,    10)),   '')     as home_telephone,
                    nullif(trim(substring(response_line,    397,    10)),   '')     as business_telephone,
                    nullif(trim(substring(response_line,    407,    10)),   '')     as cellular_telephone,
                    nullif(trim(substring(response_line,    417,    50)),   '')     as email_address,
                    nullif(trim(substring(response_line,    467,    20)),   '')     as drivers_license_number,
                    nullif(trim(substring(response_line,    487,    2)),    '')     as drivers_license_state,
                    nullif(trim(substring(response_line,    489,    2)),    '')     as drivers_license_class,
                    nullif(trim(substring(response_line,    491,    22)),   '')     as filler

        from        edwprodhh.iso.response_flat
        where       record_type = 'MK01'
                    and lag_party_indicator = 'MSP1'
    )
    select      MSP1.response_id,
                MSP1.index_MA01,
                MSP1.index_MO01,
                MSP1.index_MSP1,

                MSP1.role_in_the_claim,
                MSP1.individual_business_indicator,
                MSP1.business_name_or,
                MSP1.last_name,
                MSP1.first_name,
                MSP1.middle_name,
                MSP1.date_of_birth_dob,
                MSP1.gender,
                MSP1.social_security_number_ssn,
                MSP1.ssn_code,
                MSP1.ssn_issued_from_date,
                MSP1.ssn_issued_to_date,
                MSP1.ssn_issuing_state,
                MSP1.tax_identification_number_tin,
                MSP1.tin_code,
                MSP1.tin_issuing_city,
                MSP1.tin_issuing_state,
                MSP1.drivers_license_number,
                MSP1.drivers_license_state,
                MSP1.medical_professional_license,
                MSP1.address_information_line_1,
                MSP1.address_information_line_2,
                MSP1.city,
                MSP1.state,
                MSP1.postal_code,
                MSP1.country_code,
                MSP1.home_telephone,
                MSP1.business_telephone,
                MSP1.cellular_telephone,
                MSP1.pager_number,
                MSP1.pager_pin,
                MSP1.date_of_first_doctor_visit_after_accident,
                MSP1_MEX1.party_subject_to_siu_investigation,
                MSP1_MEX1.claim_or_part_of_claim_for_this_party_not_paid_after_investigation,
                MSP1_MEX1.party_was_subject_to_an_enforcement_action_criminal_indictment_professional_disciplinary_action,
                MSP1_MEX1.claim_for_this_party_meets_criteria_for_fraud_bureau_reporting,
                MSP1_MEX1.party_associated_with_nicb_alert,
                MSP1_MEX1.was_driver_distracted,
                MSP1_MEX1.medicaid_eligible_indicator,
                MSP1_MEX1.date_of_death,
                MSP1_MEX1.medicare_eligible_indicator,
                MSP1_MEX1.do_not_send_this_party_to_cms_indicator,
                MSP1_MEX1.injured_party_hicn_mbi,
                MSP1_MEX1.stop_querying_cms_to_determine_medicare_eligibility_for_this_party,
                MSP1_MEX1.email_address,
                MSP1_MEX1.drivers_license_class,
                MSP1_MEX1.claimant_insurance_company,
                MSP1_MEX1.claimant_policy_number,
                MSP1_MK01.individual_business_indicator         as individual_business_indicator_2,
                MSP1_MK01.business_name_or                      as business_name_2,
                MSP1_MK01.last_name                             as last_name_2,
                MSP1_MK01.first_name                            as first_name_2,
                MSP1_MK01.middle_name                           as middle_name_2,
                MSP1_MK01.date_of_birth_dob                     as date_of_birth_dob_2,
                MSP1_MK01.gender                                as gender_2,
                MSP1_MK01.social_security_number_ssn            as social_security_number_ssn_2,
                MSP1_MK01.ssn_code                              as ssn_code_2,
                MSP1_MK01.ssn_issued_from_date                  as ssn_issued_from_date_2,
                MSP1_MK01.ssn_issued_to_date                    as ssn_issued_to_date_2,
                MSP1_MK01.ssn_issuing_state                     as ssn_issuing_state_2,
                MSP1_MK01.death_master_last_name                as death_master_last_name_2,
                MSP1_MK01.death_master_first_name               as death_master_first_name_2,
                MSP1_MK01.date_of_death                         as date_of_death_2,
                MSP1_MK01.city_of_death                         as city_of_death_2,
                MSP1_MK01.state_of_death                        as state_of_death_2,
                MSP1_MK01.tax_identification_number_tin         as tax_identification_number_tin_2,
                MSP1_MK01.tin_code                              as tin_code_2,
                MSP1_MK01.tin_issuing_city                      as tin_issuing_city_2,
                MSP1_MK01.tin_issuing_state                     as tin_issuing_state_2,
                MSP1_MK01.medical_professional_license          as medical_professional_license_2,
                MSP1_MK01.address_information_line_1            as address_information_line_1_2,
                MSP1_MK01.address_information_line_2            as address_information_line_2_2,
                MSP1_MK01.city                                  as city_2,
                MSP1_MK01.state                                 as state_2,
                MSP1_MK01.postal_code                           as postal_code_2,
                MSP1_MK01.country_code                          as country_code_2,
                MSP1_MK01.home_telephone                        as home_telephone_2,
                MSP1_MK01.business_telephone                    as business_telephone_2,
                MSP1_MK01.cellular_telephone                    as cellular_telephone_2,
                MSP1_MK01.email_address                         as email_address_2,
                MSP1_MK01.drivers_license_number                as drivers_license_number_2,
                MSP1_MK01.drivers_license_state                 as drivers_license_state_2,
                MSP1_MK01.drivers_license_class                 as drivers_license_class_2

    from        MSP1
                left join
                    MSP1_MEX1
                    on  MSP1.response_id    = MSP1_MEX1.response_id
                    and MSP1.index_MA01     = MSP1_MEX1.index_MA01
                    and MSP1.index_MO01     = MSP1_MEX1.index_MO01
                    and MSP1.index_MSP1     = MSP1_MEX1.index_MSP1
                left join
                    MSP1_MK01
                    on  MSP1.response_id    = MSP1_MK01.response_id
                    and MSP1.index_MA01     = MSP1_MK01.index_MA01
                    and MSP1.index_MO01     = MSP1_MK01.index_MO01
                    and MSP1.index_MSP1     = MSP1_MK01.index_MSP1
    order by    1,2,3,4
    ;


end
;



-- create or replace task
--     edwprodhh.iso.sp_update_service_provider_echo
--     warehouse = analysis_wh
--     after edwprodhh.iso.sp_update_response_flat
-- as
-- call edwprodhh.iso.update_service_provider_echo();
-- ;