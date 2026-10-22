with dates as
(
    select      regexp_replace(echo.policy_number, '^(ADV|UMMC|IU)', '') as mrn,
                echo.iso_received_date as request_date,
                case    when    match.response_id is not null
                        then    to_date(regexp_substr(regexp_substr(files.file_name, 'D\\d{6}'), '\\d{6}'), 'yymmdd')
                        else    NULL
                        end     as response_date,
    from        edwprodhh.iso.claim_echo as echo
                left join
                    edwprodhh.iso.claim_match as match
                    on echo.response_id = match.response_id
                    and echo.index_ma01 = match.index_ma01
                inner join
                    edwprodhh.iso.response_files as files
                    on echo.response_id = files.response_id
)
select      *
from        dates
order by    random()
;