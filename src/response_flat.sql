create or replace table
    edwprodhh.iso.response_flat
as
with response_keys as
(
    select      response_id,
                response_line,
                substring(response_line,    1,      10)                                 as record_key,
                substring(response_line,    1,      6)                                  as record_number,
                substring(response_line,    7,      4)                                  as record_type,
                row_number() over (partition by response_id order by record_number asc) as index
    from        edwprodhh.iso.response
    order by    3
)
, lvl1 as
(
    select      *,
                max(case when record_type = 'MA01' then index end) over (partition by response_id order by index asc) as index_ma01
    from        response_keys
)
, lvl2 as
(
    select      *,
                max(case when record_type = 'MO01' then index end) over (partition by response_id, index_ma01 order by index asc) as index_mo01,
                max(case when record_type = 'MA03' then index end) over (partition by response_id, index_ma01 order by index asc) as index_ma03
    from        lvl1
)
, lvl3 as
(
    select      *,

                max(case when record_type = 'MSP1' then index end) over (partition by response_id, index_ma01, index_mo01 order by index asc) as index_msp1,
                max(case when record_type = 'MACL' then index end) over (partition by response_id, index_ma01, index_mo01 order by index asc) as index_macl,
                max(case when record_type = 'MS01' then index end) over (partition by response_id, index_ma01, index_mo01 order by index asc) as index_ms01,
                max(case when record_type = 'MS02' then index end) over (partition by response_id, index_ma01, index_mo01 order by index asc) as index_ms02,

                max(case when record_type = 'MO02' then index end) over (partition by response_id, index_ma01, index_ma03 order by index asc) as index_mo02,

                coalesce(
                    case when record_type in ('MO01', 'MSP1', 'MACL') then record_type else NULL end,
                    lag(case when record_type in ('MO01', 'MSP1', 'MACL') then record_type else NULL end) ignore nulls over (partition by response_id, index_ma01, index_mo01 order by index asc)
                )   as lag_party_indicator,

                coalesce(
                    case when record_type in ('MC01', 'MV01') then record_type else NULL end,
                    lag(case when record_type in ('MC01', 'MV01') then record_type else NULL end) ignore nulls over (partition by response_id, index_ma01, index_mo01 order by index asc)
                )   as lag_coverage_indicator,

                coalesce(
                    case when record_type in ('MS01', 'MS02') then record_type else NULL end,
                    lag(case when record_type in ('MS01', 'MS02') then record_type else NULL end) ignore nulls over (partition by response_id, index_ma01, index_mo01 order by index asc)
                )   as lag_match_indicator

    from        lvl2
)
, lvl4 as
(
    select      *,
                max(case when record_type = 'MC02' then index end) over (partition by response_id, index_ma01, index_ma03, index_mo02 order by index asc) as index_mc02,
                max(case when record_type = 'MV02' then index end) over (partition by response_id, index_ma01, index_ma03, index_mo02 order by index asc) as index_mv02,
    from        lvl3
    order by    response_id, index   
)
select      *
from        lvl4
order by    response_id, index
;