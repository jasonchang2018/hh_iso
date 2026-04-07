create or replace table
    edwprodhh.iso.header
as
with MH01 as
(
    select      response_id,
                response_line,
                record_key,
                record_number,
                record_type,

                nullif(trim(substring(response_line,    1,      10)),   '')     as record_key,
                nullif(trim(substring(response_line,    11,     9)),    '')     as customer_code,
                nullif(trim(substring(response_line,    20,     55)),   '')     as customer_name,
                nullif(trim(substring(response_line,    75,     8)),    '')     as process_date,
                nullif(trim(substring(response_line,    83,     430)),  '')     as filler

    from        edwprodhh.iso.parse_match_report_flatten
    where       record_type = 'MH01'
)
, MZ01 as
(
    select      response_id,
                response_line,
                record_key,
                record_number,
                record_type,

                nullif(trim(substring(response_line,    1,      10)),   '')     as record_key,
                nullif(trim(substring(response_line,    11,     6)),    '')     as records_transmitted,
                nullif(trim(substring(response_line,    17,     9)),    '')     as actual_records_transmitted,
                nullif(trim(substring(response_line,    26,     487)),  '')     as filler

    from        edwprodhh.iso.parse_match_report_flatten
    where       record_type = 'MZ01'
)

select      MH01.response_id,
            MH01.customer_code,
            MH01.customer_name,
            to_date(MH01.process_date, 'MMDDYYYY')                  as process_date,
            ltrim(MZ01.records_transmitted,         '0')::number    as records_transmitted,
            ltrim(MZ01.actual_records_transmitted,  '0')::number    as actual_records_transmitted,
from        MH01
            left join
                MZ01
                on MH01.response_id = MZ01.response_id
order by    1
;