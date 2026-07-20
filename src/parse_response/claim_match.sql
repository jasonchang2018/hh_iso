create or replace procedure
    edwprodhh.iso.update_claim_match()
returns     boolean
language    sql
as
begin

    insert into
        edwprodhh.iso.claim_match
    (
        RESPONSE_ID,
        INDEX_MA01,
        INDEX_MA03,
        ISO_FILE_NUMBER,
        INSURING_COMPANY_NAME,
        INSURING_COMPANY_ADDRESS,
        INSURING_COMPANY_ADDRESS_2,
        INSURING_COMPANY_CITY,
        INSURING_COMPANY_STATE_PROVINCE,
        INSURING_COMPANY_POSTAL_CODE,
        INSURING_COMPANY_COUNTRY,
        INSURING_COMPANY_PHONE,
        POLICY_NUMBER,
        POLICY_TYPE,
        POLICY_INCEPTION_DATE,
        POLICY_EXPIRATION_DATE,
        POLICY_RENEWAL_INDICATOR_Y_N,
        ASSIGNED_RISK_POLICY_INDICATOR,
        CLAIM_NUMBER,
        DATE_OF_LOSS,
        TIME_OF_LOSS,
        TIMESTAMP_OF_LOSS,
        CAT_INDICATOR,
        CAT_NUMBER,
        COMPANY_RECEIVED_DATE,
        AGENCY_NOTIFIED_OF_LOSS,
        POLICE_FIRE_REPORT_CASE_NUMBER,
        LOSS_DESCRIPTION,
        HIT_AND_RUN_INDICATOR,
        _8_F_FUND_CLAIM,
        VESSEL_CALL_NUMBER,
        MOLD_INDICATOR,
        STATEMENT_OF_DISPUTE_INDICATOR,
        CLAIM_REFERRED_TO_NICB_INDICATOR,
        MASS_TORT_INDICATOR,
        LOSS_LOCATION_ADDRESS_LINE_1,
        LOSS_LOCATION_ADDRESS_LINE_2,
        LOSS_LOCATION_CITY,
        LOSS_LOCATION_STATE,
        LOSS_LOCATION_COUNTRY,
        LOSS_LOCATION_POSTAL_CODE,
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
        _4_BYTE_CAT_CODE,
        EXTENDED_LOSS_DESCRIPTION,
        DATE_OF_POLICY_RENEWAL
    )
    with filtered as
    (
        select      *
        from        edwprodhh.iso.response_flat
        where       index_ma03 is not null
                    and response_id not in (select response_id from edwprodhh.iso.claim_match)
    )
    , MA03 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    index_ma03,
                    
                    nullif(trim(substring(response_body,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_body,    11,     11)),   '')     as iso_file_number,
                    nullif(trim(substring(response_body,    22,     55)),   '')     as insuring_company_name,
                    nullif(trim(substring(response_body,    77,     50)),   '')     as insuring_company_address,
                    nullif(trim(substring(response_body,    127,    50)),   '')     as insuring_company_address_2,
                    nullif(trim(substring(response_body,    177,    25)),   '')     as insuring_company_city,
                    nullif(trim(substring(response_body,    202,    2)),    '')     as insuring_company_state_province,
                    nullif(trim(substring(response_body,    204,    9)),    '')     as insuring_company_postal_code,
                    nullif(trim(substring(response_body,    213,    3)),    '')     as insuring_company_country,
                    nullif(trim(substring(response_body,    216,    10)),   '')     as insuring_company_phone,
                    nullif(trim(substring(response_body,    226,    30)),   '')     as policy_number,
                    nullif(trim(substring(response_body,    256,    4)),    '')     as policy_type,
                    nullif(trim(substring(response_body,    260,    8)),    '')     as policy_inception_date,
                    nullif(trim(substring(response_body,    268,    8)),    '')     as policy_expiration_date,
                    nullif(trim(substring(response_body,    276,    1)),    '')     as policy_renewal_indicator_y_n,
                    nullif(trim(substring(response_body,    277,    1)),    '')     as assigned_risk_policy_indicator,
                    nullif(trim(substring(response_body,    278,    30)),   '')     as claim_number,
                    nullif(trim(substring(response_body,    308,    8)),    '')     as date_of_loss,
                    nullif(trim(substring(response_body,    316,    4)),    '')     as time_of_loss,
                    nullif(trim(substring(response_body,    320,    1)),    '')     as cat_indicator,
                    nullif(trim(substring(response_body,    321,    3)),    '')     as cat_number,
                    nullif(trim(substring(response_body,    324,    8)),    '')     as company_received_date,
                    nullif(trim(substring(response_body,    332,    35)),   '')     as agency_notified_of_loss,
                    nullif(trim(substring(response_body,    367,    15)),   '')     as police_fire_report_case_number,
                    nullif(trim(substring(response_body,    382,    50)),   '')     as loss_description,
                    nullif(trim(substring(response_body,    432,    1)),    '')     as hit_and_run_indicator,
                    nullif(trim(substring(response_body,    433,    3)),    '')     as filler,
                    nullif(trim(substring(response_body,    436,    1)),    '')     as _8_f_fund_claim,
                    nullif(trim(substring(response_body,    437,    50)),   '')     as vessel_call_number,
                    nullif(trim(substring(response_body,    487,    1)),    '')     as mold_indicator,
                    nullif(trim(substring(response_body,    488,    1)),    '')     as statement_of_dispute_indicator,
                    nullif(trim(substring(response_body,    489,    1)),    '')     as claim_referred_to_nicb_indicator,
                    nullif(trim(substring(response_body,    490,    1)),    '')     as mass_tort_indicator,
                    nullif(trim(substring(response_body,    491,    21)),   '')     as filler,
                    nullif(trim(substring(response_body,    512,    1)),    '')     as filler

        from        filtered
        where       record_type = 'MA03'
    )
    , MA04 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    index_ma03,
                    
                    nullif(trim(substring(response_body,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_body,    11,     50)),   '')     as loss_location_address_line_1,
                    nullif(trim(substring(response_body,    61,     50)),   '')     as loss_location_address_line_2,
                    nullif(trim(substring(response_body,    111,    25)),   '')     as loss_location_city,
                    nullif(trim(substring(response_body,    136,    2)),    '')     as loss_location_state,
                    nullif(trim(substring(response_body,    138,    3)),    '')     as loss_location_country,
                    nullif(trim(substring(response_body,    141,    9)),    '')     as loss_location_postal_code,
                    nullif(trim(substring(response_body,    150,    363)),  '')     as filler

        from        filtered
        where       record_type = 'MA04'
    )
    , MA06 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    index_ma03,
                    
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
                    nullif(trim(substring(response_body,    450,    63)),   '')     as filler

        from        filtered
        where       record_type = 'MA06'
    )
    , MA08 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    index_ma03,
                    
                    nullif(trim(substring(response_body,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_body,    11,     4)),    '')     as _4_byte_cat_code,
                    nullif(trim(substring(response_body,    15,     200)),  '')     as extended_loss_description,
                    nullif(trim(substring(response_body,    215,    16)),   '')     as filler,
                    nullif(trim(substring(response_body,    231,    8)),    '')     as date_of_policy_renewal,
                    nullif(trim(substring(response_body,    239,    266)),  '')     as filler

        from        filtered
        where       record_type = 'MA08'
    )
    select      MA03.response_id,
                MA03.index_MA01,
                MA03.index_MA03,

                MA03.iso_file_number,
                MA03.insuring_company_name,
                MA03.insuring_company_address,
                MA03.insuring_company_address_2,
                MA03.insuring_company_city,
                MA03.insuring_company_state_province,
                MA03.insuring_company_postal_code,
                MA03.insuring_company_country,
                MA03.insuring_company_phone,
                MA03.policy_number,
                MA03.policy_type,
                to_date(nullif(ltrim(MA03.policy_inception_date,   0), ''), 'MMDDYYYY') as policy_inception_date,
                to_date(nullif(ltrim(MA03.policy_expiration_date,  0), ''), 'MMDDYYYY') as policy_expiration_date,
                MA03.policy_renewal_indicator_y_n,
                MA03.assigned_risk_policy_indicator,
                MA03.claim_number,
                to_date(MA03.date_of_loss, 'MMDDYYYY') as date_of_loss,
                MA03.time_of_loss,
                to_timestamp(MA03.date_of_loss||MA03.time_of_loss, 'MMDDYYYYHH24MI') as timestamp_of_loss,
                MA03.cat_indicator,
                MA03.cat_number,
                to_date(nullif(ltrim(MA03.company_received_date,  0), ''), 'MMDDYYYY') as company_received_date,
                MA03.agency_notified_of_loss,
                MA03.police_fire_report_case_number,
                MA03.loss_description,
                MA03.hit_and_run_indicator,
                MA03._8_f_fund_claim,
                MA03.vessel_call_number,
                MA03.mold_indicator,
                MA03.statement_of_dispute_indicator,
                MA03.claim_referred_to_nicb_indicator,
                MA03.mass_tort_indicator,
                MA04.loss_location_address_line_1,
                MA04.loss_location_address_line_2,
                MA04.loss_location_city,
                MA04.loss_location_state,
                MA04.loss_location_country,
                MA04.loss_location_postal_code,
                MA06.physical_risk_address_info_line_1,
                MA06.physical_risk_address_info_line_2,
                MA06.physical_risk_city,
                MA06.physical_risk_state,
                MA06.physical_risk_postal_code,
                MA06.physical_risk_country_code,
                MA06.mailing_address_line_1,
                MA06.mailing_address_line_2,
                MA06.city,
                MA06.state,
                MA06.postal_code,
                MA06.country_code,
                MA06.siu_company_name,
                MA06.siu_investigator_last_name,
                MA06.siu_investigator_first_name,
                MA06.siu_investigator_middle_name,
                MA06.siu_investigator_business_phone,
                MA06.siu_investigator_cell_phone,
                MA06.claim_associated_with_fraud_ring_investigation,
                MA08._4_byte_cat_code,
                MA08.extended_loss_description,
                MA08.date_of_policy_renewal,

    from        MA03
                left join
                    MA04
                    on  MA03.response_id    = MA04.response_id
                    and MA03.index_MA01     = MA04.index_MA01
                    and MA03.index_MA03     = MA04.index_MA03
                left join
                    MA06
                    on  MA03.response_id    = MA06.response_id
                    and MA03.index_MA01     = MA06.index_MA01
                    and MA03.index_MA03     = MA06.index_MA03
                left join
                    MA08
                    on  MA03.response_id    = MA08.response_id
                    and MA03.index_MA01     = MA08.index_MA01
                    and MA03.index_MA03     = MA08.index_MA03
    order by    1,2,3
    ;


end
;



create or replace task
    edwprodhh.iso.sp_update_claim_match
    warehouse = analysis_wh
    after edwprodhh.iso.sp_update_response_flat
as
call edwprodhh.iso.update_claim_match();
;