select      regexp_substr(echo.policy_number, '^(ADV|UMMC|IU)') as client,
            date_trunc('week', to_date(regexp_substr(regexp_substr(file_name, 'D\\d{6}'), '\\d{6}'), 'yymmdd')) as request_date,
            count(distinct echo.response_id, echo.index_ma01) as n_requests,
            count(distinct match.response_id, match.index_ma01) as n_matched,
            n_matched / n_requests as p_matched
from        edwprodhh.iso.claim_echo as echo
            left join
                edwprodhh.iso.claim_match as match
                on echo.response_id = match.response_id
                and echo.index_ma01 = match.index_ma01
            inner join
                edwprodhh.iso.response_files as files
                on echo.response_id = files.response_id
group by    1,2
order by    1,2
;