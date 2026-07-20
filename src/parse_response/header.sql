create or replace procedure
    edwprodhh.iso.update_header()
returns     boolean
language    sql
as
begin

    insert into
        edwprodhh.iso.header
    (
        RESPONSE_ID,
        CUSTOMER_CODE,
        CUSTOMER_NAME,
        PROCESS_DATE,
        RECORDS_TRANSMITTED,
        ACTUAL_RECORDS_TRANSMITTED
    )
    with filtered as
    (
        select      *
        from        edwprodhh.iso.response_flat
        where       response_id not in (select response_id from edwprodhh.iso.header)
    )
    , MH01 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,

                    nullif(trim(substring(response_body,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_body,    11,     9)),    '')     as customer_code,
                    nullif(trim(substring(response_body,    20,     55)),   '')     as customer_name,
                    nullif(trim(substring(response_body,    75,     8)),    '')     as process_date,
                    nullif(trim(substring(response_body,    83,     430)),  '')     as filler

        from        filtered
        where       record_type = 'MH01'
    )
    , MZ01 as
    (
        select      response_id,
                    response_body,
                    record_key,
                    record_number,
                    record_type,

                    nullif(trim(substring(response_body,    1,      10)),   '')     as record_key,
                    nullif(trim(substring(response_body,    11,     6)),    '')     as records_transmitted,
                    nullif(trim(substring(response_body,    17,     9)),    '')     as actual_records_transmitted,
                    nullif(trim(substring(response_body,    26,     487)),  '')     as filler

        from        filtered
        where       record_type = 'MZ01'
    )
    select      MH01.response_id,
                MH01.customer_code,
                MH01.customer_name,
                to_date(MH01.process_date, 'MMDDYYYY')                  as process_date,
                ltrim(MZ01.records_transmitted,         '0')::number    as records_transmitted,
                ltrim(MZ01.actual_records_transmitted,  '0')::number    as actual_records_transmitted
    from        MH01
                left join
                    MZ01
                    on MH01.response_id = MZ01.response_id
    order by    1
    ;


end
;



create or replace task
    edwprodhh.iso.sp_update_header
    warehouse = analysis_wh
    after edwprodhh.iso.sp_update_response_flat
as
call edwprodhh.iso.update_header();
;