create schema edwprodhh.iso;

create stage edwprodhh.iso.stg_response;


-- snowsql -q "PUT file://\\\\hh-fileserver01\\TempUL2\\IU_Health_Complex\\837_FILES_IN\\2026\\*_i*.837 @edwprodhh.iso.stg_response auto_compress=false;"
list @edwprodhh.iso.stg_response;

create or replace file format
    edwprodhh.iso.format_txt
type                            = 'CSV'
field_delimiter                 = '\u0000'  -- an impossible delimiter; treats entire row as one value.
record_delimiter                = '\n'
skip_header                     = 0
field_optionally_enclosed_by    = NONE
escape_unenclosed_field         = NONE
;


create or replace task
    edwprodhh.iso.iso_root
    warehouse = analysis_wh
    schedule = 'USING CRON 0 1 * * * America/Chicago'
as
select 1 as val
;