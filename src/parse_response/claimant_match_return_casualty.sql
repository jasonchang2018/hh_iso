create or replace procedure
    edwprodhh.iso.update_claimant_match_return_casualty()
returns     boolean
language    sql
as
begin

    insert into
        edwprodhh.iso.claimant_match_return_casualty
    (
        RESPONSE_ID,
        INDEX_MA01,
        INDEX_MA03,
        INDEX_MO02,
        INDEX_MC02,
        ADJUSTING_COMPANY_NAME,
        ADJUSTER_LAST_NAME,
        ADJUSTER_FIRST_NAME,
        ADJUSTER_MIDDLE_INITIAL_NAME,
        ADJUSTER_TELEPHONE_NUMBER,
        LOSS_TYPE,
        COVERAGE_TYPE,
        ALLEGED_INJURIES_PROPERTY_DAMAGE,
        CLAIM_STATUS,
        TORT_THRESHOLD_TYPE,
        TORT_THRESHOLD_STATE,
        SUIT_INDICATOR,
        ESTIMATED_LOSS_AMOUNT,
        SETTLEMENT_AMOUNT,
        DATE_CLAIM_CLOSED,
        LOSS_TIME_START_DATE,
        LOSS_TIME_END_DATE,
        TOTAL_LOST_DAYS,
        COURT_FILED,
        COURT_FILE_DATE,
        COURT_COUNTY,
        COURT_STATE,
        DOCKET_NUMBER,
        ADJUSTER_EMAIL_ADDRESS,
        ERISA_CLAIM_INDICATOR
    )
    with filtered as
    (
        select      *
        from        edwprodhh.iso.response_flat
        where       index_mo02 is not null
                    and response_id not in (select response_id from edwprodhh.iso.claimant_match_return_casualty)
    )
    , MC02 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,
                    index_ma01,
                    index_ma03,
                    index_mo02,
                    index_mc02,
                    
                    nullif(trim(substring(response_body,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_body,    11,     55)),   '')     as adjusting_company_name,
                    nullif(trim(substring(response_body,    66,     30)),   '')     as adjuster_last_name,
                    nullif(trim(substring(response_body,    96,     20)),   '')     as adjuster_first_name,
                    nullif(trim(substring(response_body,    116,    20)),   '')     as adjuster_middle_initial_name,
                    nullif(trim(substring(response_body,    136,    10)),   '')     as adjuster_telephone_number,
                    nullif(trim(substring(response_body,    146,    4)),    '')     as loss_type,
                    nullif(trim(substring(response_body,    150,    4)),    '')     as coverage_type,
                    nullif(trim(substring(response_body,    154,    50)),   '')     as alleged_injuries_property_damage,
                    nullif(trim(substring(response_body,    204,    2)),    '')     as filler,
                    nullif(trim(substring(response_body,    206,    3)),    '')     as filler,
                    nullif(trim(substring(response_body,    209,    3)),    '')     as claim_status,
                    nullif(trim(substring(response_body,    212,    2)),    '')     as tort_threshold_type,
                    nullif(trim(substring(response_body,    214,    2)),    '')     as tort_threshold_state,
                    nullif(trim(substring(response_body,    216,    1)),    '')     as suit_indicator,
                    nullif(trim(substring(response_body,    217,    11)),   '')     as estimated_loss_amount,
                    nullif(trim(substring(response_body,    228,    11)),   '')     as filler,
                    nullif(trim(substring(response_body,    239,    11)),   '')     as settlement_amount,
                    nullif(trim(substring(response_body,    250,    8)),    '')     as date_claim_closed,
                    nullif(trim(substring(response_body,    258,    8)),    '')     as loss_time_start_date,
                    nullif(trim(substring(response_body,    266,    8)),    '')     as loss_time_end_date,
                    nullif(trim(substring(response_body,    274,    5)),    '')     as total_lost_days,
                    nullif(trim(substring(response_body,    279,    10)),   '')     as court_filed,
                    nullif(trim(substring(response_body,    289,    8)),    '')     as court_file_date,
                    nullif(trim(substring(response_body,    297,    25)),   '')     as court_county,
                    nullif(trim(substring(response_body,    322,    2)),    '')     as court_state,
                    nullif(trim(substring(response_body,    324,    22)),   '')     as docket_number,
                    nullif(trim(substring(response_body,    346,    50)),   '')     as adjuster_email_address,
                    nullif(trim(substring(response_body,    396,    1)),    '')     as erisa_claim_indicator,
                    nullif(trim(substring(response_body,    397,    116)),  '')     as filler

        from        filtered
        where       record_type = 'MC02'
    )
    select      MC02.response_id,
                MC02.index_MA01,
                MC02.index_MA03,
                MC02.index_MO02,
                MC02.index_MC02,
                
                MC02.adjusting_company_name,
                MC02.adjuster_last_name,
                MC02.adjuster_first_name,
                MC02.adjuster_middle_initial_name,
                MC02.adjuster_telephone_number,
                MC02.loss_type,
                MC02.coverage_type,
                MC02.alleged_injuries_property_damage,
                MC02.claim_status,
                MC02.tort_threshold_type,
                MC02.tort_threshold_state,
                MC02.suit_indicator,
                MC02.estimated_loss_amount,
                MC02.settlement_amount,
                MC02.date_claim_closed,
                MC02.loss_time_start_date,
                MC02.loss_time_end_date,
                MC02.total_lost_days,
                MC02.court_filed,
                MC02.court_file_date,
                MC02.court_county,
                MC02.court_state,
                MC02.docket_number,
                MC02.adjuster_email_address,
                MC02.erisa_claim_indicator

    from        MC02
    order by    1,2,3,4,5
    ;


end
;



create or replace task
    edwprodhh.iso.sp_update_claimant_match_return_casualty
    warehouse = analysis_wh
    after edwprodhh.iso.sp_update_response_flat
as
call edwprodhh.iso.update_claimant_match_return_casualty();
;