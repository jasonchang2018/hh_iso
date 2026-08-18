create or replace view
    edwprodhh.iso.export_cubs
as
with requests as
(
    select      debtor_idx,
                min(upload_date) as request_date
    from        edwprodhh.iso.request_log
    where       nullif(trim(debtor_idx), '') is not null
    group by    1
    order by    1
)
, responses as
(
    with map_requests as
    (
        with parsed as
        (
            select      distinct
                        debtor_idx,
                        nullif(trim(left(right(concat_no_rn, length(concat_no_rn)-14), 30)), '') as policy_number
            from        edwprodhh.iso.request_log
            where       nullif(trim(debtor_idx), '') is not null
                        and nullif(trim(left(concat_no_rn, 4)), '') = 'UA01'
        )
        , unique_debtor_idx as
        (
            select      *
            from        parsed
            qualify     row_number() over (partition by debtor_idx order by policy_number asc) = 1
        )
        select      *
        from        unique_debtor_idx
        qualify     row_number() over (partition by policy_number order by debtor_idx asc) = 1
    )
    select      map_requests.debtor_idx,
                -- echo.policy_number,
                min(response_files.upload_date) as response_date
    from        edwprodhh.iso.claim_echo as echo
                left join
                    map_requests
                    on echo.policy_number = map_requests.policy_number
                left join
                    (
                        select      response_id,
                                    min(upload_date) as upload_date
                        from        edwprodhh.iso.response_files
                        group by    1
                        order by    1
                    )   as response_files
                    on echo.response_id = response_files.response_id
    where       exists (
                    select      1
                    from        edwprodhh.iso.claim_match as match
                    where       echo.response_id = match.response_id
                                and echo.index_ma01 = match.index_ma01
                )
    group by    1
    order by    1
)
, joined as
(
    select      coalesce(requests.debtor_idx, responses.debtor_idx) as debtor_idx,
                requests.request_date,
                responses.response_date
    from        requests
                left join
                    responses
                    on requests.debtor_idx = responses.debtor_idx
    order by    1
)
select      *
from        joined
where       coalesce(request_date, '1970-01-01') >= current_date() - 30
            or coalesce(response_date, '1970-01-01') >= current_date() - 30
;