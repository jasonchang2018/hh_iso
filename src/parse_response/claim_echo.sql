create or replace procedure
    edwprodhh.iso.update_claim_echo()
returns     boolean
language    sql
as
begin

    insert into
        edwprodhh.iso.claim_echo
    (
        RESPONSE_ID,
        INDEX_MA01,
        ISO_FILE_NUMBER,
        RETURN_REASON_CODE,
        CUSTOMER_CODE,
        POLICY_NUMBER,
        POLICY_TYPE,
        POLICY_INCEPTION_DATE,
        POLICY_EXPIRATION_DATE,
        POLICY_RENEWAL_INDICATOR,
        ASSIGNED_RISK_POLICY_INDICATOR,
        CLAIM_NUMBER,
        DATE_OF_LOSS,
        TIME_OF_LOSS,
        TIMESTAMP_OF_LOSS,
        CAT_INDICATOR,
        CAT_NUMBER,
        COMPANY_RECEIVED_DATE,
        LOSS_DESCRIPTION,
        LOCATION_OF_LOSS_ADDRESS_1,
        LOCATION_OF_LOSS_ADDRESS_2,
        LOCATION_OF_LOSS_CITY,
        LOCATION_OF_LOSS_STATE,
        LOCATION_OF_LOSS_POSTAL_CODE,
        LOCATION_OF_LOSS_COUNTRY,
        HIT_AND_RUN_INDICATOR,
        AGENCY_NOTIFIED_OF_LOSS,
        POLICE_FIRE_REPORT_CASE_NUMBER,
        ROUTING_MISC_INFO_AREA,
        _8_F_FUND_CLAIM,
        VESSEL_CALL_NUMBER,
        CLAIM_SCORING_SCORE_REQUESTED_INDICATOR,
        CLAIM_SCORING_SCORE,
        CLAIM_SCORING_HANDLING_CHARACTERISTICS_INDICATOR,
        CLAIM_SCORING_LIFE_OF_CLAIM_EXCEEDED_INDICATOR,
        CLAIM_SCORING_E_MAIL_NOTIFICATION_SENT_INDICATOR,
        CLAIM_SCORING_NUMBER_OF_TIMES_SCORED,
        MOLD_INDICATOR,
        STATEMENT_OF_DISPUTE_INDICATOR,
        DATE_OF_FIRST_CLAIM_PAYMENT,
        WEB_OVERLAY_INDICATOR,
        CLAIM_REFERRED_TO_NICB_INDICATOR,
        VEHICLE_RECALL_INFORMATION_INDICATOR,
        ISO_RECEIVED_DATE,
        MASS_TORT_INDICATOR,
        SELF_INSURED_INDICATOR,
        COBC_ASSIGNED_SECTION_111_REPORTER_ID_RRE_CODE,
        TAX_IDENTIFICATION_NUMBER_TIN,
        SITE_ID,
        PHYSICAL_RISK_ADDRESS_INFO_LINE_1,
        PHYSICAL_RISK_ADDRESS_INFO_LINE_2,
        PHYSICAL_RISK_CITY,
        PHYSICAL_RISK_STATE,
        PHYSICAL_RISK_POSTAL_CODE,
        PHYSICAL_RISK_COUNTRY_CODE,
        MAILING_ADDRESS_LINE_1,
        MAILING_ADDRESS_LINE_2,
        CITY,
        STATE,
        POSTAL_CODE,
        COUNTRY_CODE,
        SIU_COMPANY_NAME,
        SIU_INVESTIGATOR_LAST_NAME,
        SIU_INVESTIGATOR_FIRST_NAME,
        SIU_INVESTIGATOR_MIDDLE_NAME,
        SIU_INVESTIGATOR_BUSINESS_PHONE,
        SIU_INVESTIGATOR_CELL_PHONE,
        CLAIM_ASSOCIATED_WITH_FRAUD_RING_INVESTIGATION,
        NMVTIS_OPERATORS_REPORTING_ENTITY_ID,
        _4_BYTE_CAT_CODE,
        ADDITIONAL_LOSS_DESCRIPTION,
        DATE_OF_POLICY_RENEWAL,
        UNDERLYING_CARRIER_NAME,
        UNDERLYING_CARRIER_ADDRESS_LINE1,
        UNDERLYING_CARRIER_ADDRESS_LINE2,
        UNDERLYING_CARRIER_CITY,
        UNDERLYING_CARRIER_STATE,
        UNDERLYING_CARRIER_POSTAL_CODE,
        UNDERLYING_CARRIER_COUNTRY,
        UNDERLYING_CARRIER_BUSINESS_PHONE
    )
    with filtered as
    (
        select      *
        from        edwprodhh.iso.response_flat
        where       index_ma01 is not null
                    and response_id not in (select response_id from edwprodhh.iso.claim_echo)
    )
    , MA01 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,

                    nullif(trim(substring(response_body,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_body,    11,     11)),   '')     as iso_file_number,
                    nullif(trim(substring(response_body,    22,     1)),    '')     as return_reason_code,
                    nullif(trim(substring(response_body,    23,     9)),    '')     as customer_code,
                    nullif(trim(substring(response_body,    32,     30)),   '')     as policy_number,
                    nullif(trim(substring(response_body,    62,     4)),    '')     as policy_type,
                    nullif(trim(substring(response_body,    66,     8)),    '')     as policy_inception_date,
                    nullif(trim(substring(response_body,    74,     8)),    '')     as policy_expiration_date,
                    nullif(trim(substring(response_body,    82,     1)),    '')     as policy_renewal_indicator,
                    nullif(trim(substring(response_body,    83,     1)),    '')     as assigned_risk_policy_indicator,
                    nullif(trim(substring(response_body,    84,     30)),   '')     as claim_number,
                    nullif(trim(substring(response_body,    114,    8)),    '')     as date_of_loss,
                    nullif(trim(substring(response_body,    122,    4)),    '')     as time_of_loss,
                    nullif(trim(substring(response_body,    126,    1)),    '')     as cat_indicator,
                    nullif(trim(substring(response_body,    127,    3)),    '')     as cat_number,
                    nullif(trim(substring(response_body,    130,    8)),    '')     as company_received_date,
                    nullif(trim(substring(response_body,    138,    50)),   '')     as loss_description,
                    nullif(trim(substring(response_body,    188,    50)),   '')     as location_of_loss_address_1,
                    nullif(trim(substring(response_body,    238,    50)),   '')     as location_of_loss_address_2,
                    nullif(trim(substring(response_body,    288,    25)),   '')     as location_of_loss_city,
                    nullif(trim(substring(response_body,    313,    2)),    '')     as location_of_loss_state,
                    nullif(trim(substring(response_body,    315,    9)),    '')     as location_of_loss_postal_code,
                    nullif(trim(substring(response_body,    324,    3)),    '')     as location_of_loss_country,
                    nullif(trim(substring(response_body,    327,    1)),    '')     as hit_and_run_indicator,
                    nullif(trim(substring(response_body,    328,    3)),    '')     as filler,
                    nullif(trim(substring(response_body,    331,    35)),   '')     as agency_notified_of_loss,
                    nullif(trim(substring(response_body,    366,    15)),   '')     as police_fire_report_case_number,
                    nullif(trim(substring(response_body,    381,    20)),   '')     as routing_misc_info_area,
                    nullif(trim(substring(response_body,    401,    1)),    '')     as _8_f_fund_claim,
                    nullif(trim(substring(response_body,    402,    50)),   '')     as vessel_call_number,
                    nullif(trim(substring(response_body,    452,    1)),    '')     as filler,
                    nullif(trim(substring(response_body,    453,    1)),    '')     as claim_scoring_score_requested_indicator,
                    nullif(trim(substring(response_body,    454,    3)),    '')     as claim_scoring_score,
                    nullif(trim(substring(response_body,    457,    1)),    '')     as claim_scoring_handling_characteristics_indicator,
                    nullif(trim(substring(response_body,    458,    1)),    '')     as claim_scoring_life_of_claim_exceeded_indicator,
                    nullif(trim(substring(response_body,    459,    1)),    '')     as claim_scoring_e_mail_notification_sent_indicator,
                    nullif(trim(substring(response_body,    460,    2)),    '')     as claim_scoring_number_of_times_scored,
                    nullif(trim(substring(response_body,    462,    1)),    '')     as mold_indicator,
                    nullif(trim(substring(response_body,    463,    1)),    '')     as statement_of_dispute_indicator,
                    nullif(trim(substring(response_body,    464,    8)),    '')     as date_of_first_claim_payment,
                    nullif(trim(substring(response_body,    472,    1)),    '')     as web_overlay_indicator,
                    nullif(trim(substring(response_body,    473,    1)),    '')     as claim_referred_to_nicb_indicator,
                    nullif(trim(substring(response_body,    474,    1)),    '')     as vehicle_recall_information_indicator,
                    nullif(trim(substring(response_body,    475,    8)),    '')     as iso_received_date,
                    nullif(trim(substring(response_body,    483,    1)),    '')     as mass_tort_indicator,
                    nullif(trim(substring(response_body,    484,    1)),    '')     as self_insured_indicator,
                    nullif(trim(substring(response_body,    485,    9)),    '')     as cobc_assigned_section_111_reporter_id_rre_code,
                    nullif(trim(substring(response_body,    494,    9)),    '')     as tax_identification_number_tin,
                    nullif(trim(substring(response_body,    503,    9)),    '')     as site_id,
                    nullif(trim(substring(response_body,    512,    1)),    '')     as filler

        from        filtered
        where       record_type = 'MA01'
    )
    , MA05 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    
                    nullif(trim(substring(response_body,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_body,    11,     50)),   '')     as physical_risk_address_info_line_1,
                    nullif(trim(substring(response_body,    61,     50)),   '')     as physical_risk_address_info_line_2,
                    nullif(trim(substring(response_body,    111,    25)),   '')     as physical_risk_city,
                    nullif(trim(substring(response_body,    136,    2)),    '')     as physical_risk_state,
                    nullif(trim(substring(response_body,    138,    9)),    '')     as physical_risk_postal_code,
                    nullif(trim(substring(response_body,    147,    3)),    '')     as physical_risk_country_code,
                    nullif(trim(substring(response_body,    150,    50)),   '')     as mailing_address_line_1,
                    nullif(trim(substring(response_body,    200,    50)),   '')     as mailing_address_line_2,
                    nullif(trim(substring(response_body,    250,    25)),   '')     as city,
                    nullif(trim(substring(response_body,    275,    2)),    '')     as state,
                    nullif(trim(substring(response_body,    277,    9)),    '')     as postal_code,
                    nullif(trim(substring(response_body,    286,    3)),    '')     as country_code,
                    nullif(trim(substring(response_body,    289,    70)),   '')     as siu_company_name,
                    nullif(trim(substring(response_body,    359,    30)),   '')     as siu_investigator_last_name,
                    nullif(trim(substring(response_body,    389,    20)),   '')     as siu_investigator_first_name,
                    nullif(trim(substring(response_body,    409,    20)),   '')     as siu_investigator_middle_name,
                    nullif(trim(substring(response_body,    429,    10)),   '')     as siu_investigator_business_phone,
                    nullif(trim(substring(response_body,    439,    10)),   '')     as siu_investigator_cell_phone,
                    nullif(trim(substring(response_body,    449,    1)),    '')     as claim_associated_with_fraud_ring_investigation,
                    nullif(trim(substring(response_body,    450,    7)),    '')     as nmvtis_operators_reporting_entity_id,
                    nullif(trim(substring(response_body,    457,    50)),   '')     as filler,
                    nullif(trim(substring(response_body,    507,    6)),    '')     as filler

        from        filtered
        where       record_type = 'MA05'
    )
    , MA07 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    
                    nullif(trim(substring(response_body,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_body,    11,     4)),    '')     as _4_byte_cat_code,
                    nullif(trim(substring(response_body,    15,     200)),  '')     as additional_loss_description,
                    nullif(trim(substring(response_body,    215,    16)),   '')     as filler,
                    nullif(trim(substring(response_body,    231,    8)),    '')     as date_of_policy_renewal,
                    nullif(trim(substring(response_body,    239,    30)),   '')     as underlying_carrier_name,
                    nullif(trim(substring(response_body,    269,    50)),   '')     as underlying_carrier_address_line1,
                    nullif(trim(substring(response_body,    319,    50)),   '')     as underlying_carrier_address_line2,
                    nullif(trim(substring(response_body,    369,    25)),   '')     as underlying_carrier_city,
                    nullif(trim(substring(response_body,    394,    2)),    '')     as underlying_carrier_state,
                    nullif(trim(substring(response_body,    396,    9)),    '')     as underlying_carrier_postal_code,
                    nullif(trim(substring(response_body,    405,    3)),    '')     as underlying_carrier_country,
                    nullif(trim(substring(response_body,    408,    10)),   '')     as underlying_carrier_business_phone,
                    nullif(trim(substring(response_body,    418,    95)),   '')     as filler

        from        filtered
        where       record_type = 'MA07'
    )
    select      MA01.response_id,
                MA01.index_ma01,

                MA01.iso_file_number,
                MA01.return_reason_code,
                MA01.customer_code,
                MA01.policy_number,
                MA01.policy_type,
                MA01.policy_inception_date,
                MA01.policy_expiration_date,
                MA01.policy_renewal_indicator,
                MA01.assigned_risk_policy_indicator,
                MA01.claim_number,
                to_date(MA01.date_of_loss, 'MMDDYYYY') as date_of_loss,
                MA01.time_of_loss,
                to_timestamp(MA01.date_of_loss||MA01.time_of_loss, 'MMDDYYYYHH24MI') as timestamp_of_loss,
                MA01.cat_indicator,
                MA01.cat_number,
                MA01.company_received_date,
                MA01.loss_description,
                MA01.location_of_loss_address_1,
                MA01.location_of_loss_address_2,
                MA01.location_of_loss_city,
                MA01.location_of_loss_state,
                MA01.location_of_loss_postal_code,
                MA01.location_of_loss_country,
                MA01.hit_and_run_indicator,
                MA01.agency_notified_of_loss,
                MA01.police_fire_report_case_number,
                MA01.routing_misc_info_area,
                MA01._8_f_fund_claim,
                MA01.vessel_call_number,
                MA01.claim_scoring_score_requested_indicator,
                MA01.claim_scoring_score,
                MA01.claim_scoring_handling_characteristics_indicator,
                MA01.claim_scoring_life_of_claim_exceeded_indicator,
                MA01.claim_scoring_e_mail_notification_sent_indicator,
                MA01.claim_scoring_number_of_times_scored,
                MA01.mold_indicator,
                MA01.statement_of_dispute_indicator,
                MA01.date_of_first_claim_payment,
                MA01.web_overlay_indicator,
                MA01.claim_referred_to_nicb_indicator,
                MA01.vehicle_recall_information_indicator,
                to_date(MA01.iso_received_date, 'MMDDYYYY') as iso_received_date,
                MA01.mass_tort_indicator,
                MA01.self_insured_indicator,
                MA01.cobc_assigned_section_111_reporter_id_rre_code,
                MA01.tax_identification_number_tin,
                MA01.site_id,
                MA05.physical_risk_address_info_line_1,
                MA05.physical_risk_address_info_line_2,
                MA05.physical_risk_city,
                MA05.physical_risk_state,
                MA05.physical_risk_postal_code,
                MA05.physical_risk_country_code,
                MA05.mailing_address_line_1,
                MA05.mailing_address_line_2,
                MA05.city,
                MA05.state,
                MA05.postal_code,
                MA05.country_code,
                MA05.siu_company_name,
                MA05.siu_investigator_last_name,
                MA05.siu_investigator_first_name,
                MA05.siu_investigator_middle_name,
                MA05.siu_investigator_business_phone,
                MA05.siu_investigator_cell_phone,
                MA05.claim_associated_with_fraud_ring_investigation,
                MA05.nmvtis_operators_reporting_entity_id,
                MA07._4_byte_cat_code,
                MA07.additional_loss_description,
                MA07.date_of_policy_renewal,
                MA07.underlying_carrier_name,
                MA07.underlying_carrier_address_line1,
                MA07.underlying_carrier_address_line2,
                MA07.underlying_carrier_city,
                MA07.underlying_carrier_state,
                MA07.underlying_carrier_postal_code,
                MA07.underlying_carrier_country,
                MA07.underlying_carrier_business_phone
    from        MA01
                left join
                    MA05
                    on  MA01.response_id    = MA05.response_id
                    and MA01.index_ma01     = MA05.index_ma01
                left join
                    MA07
                    on  MA01.response_id    = MA07.response_id
                    and MA01.index_ma01     = MA07.index_ma01
    order by    1,2
    ;


end
;



create or replace task
    edwprodhh.iso.sp_update_claim_echo
    warehouse = analysis_wh
    after edwprodhh.iso.sp_update_response_flat
as
call edwprodhh.iso.update_claim_echo();
;