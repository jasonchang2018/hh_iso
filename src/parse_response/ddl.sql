create stage
    edwprodhh.iso.stg_response
;

create table
    edwprodhh.iso.response
(
    response_id     varchar,
    response_body   varchar,
    line_number     number,
    file_name       varchar,
    upload_date     date
)
;

create table
    edwprodhh.iso.response_files
(
    response_id     varchar,
    file_name       varchar,
    upload_date     date
)
;

create or replace file format
    edwprodhh.iso.format_txt
type                            = 'CSV'
field_delimiter                 = '\u0000'  -- an impossible delimiter; treats entire row as one value.
-- record_delimiter                = NONE      -- forces all lines as one value.
record_delimiter                = '\n'
skip_header                     = 0
field_optionally_enclosed_by    = NONE
escape_unenclosed_field         = NONE
;


-- snowsql -q "PUT file://\\\\hh-fileserver01\\group\\Analytics_Team\\PROD\\ISO_RESPONSE\\CSUSUFOT.CSHRSS* @edwprodhh.iso.stg_response auto_compress=false;"
-- snowsql -q "PUT file://G:\\Analytics_Team\\PROD\\ISO_RESPONSE\\CSUSUFOT.CSHRSS* @edwprodhh.iso.stg_response auto_compress=false;"
-- snowsql -q "PUT file://C:\\Users\\jchang\\Desktop\\Projects\\iso\\doc\\response\\CSUSUFOT.CSHRSS* @edwprodhh.iso.stg_response auto_compress=false;" --worked on 7/20 after disconnecting from VPN
list @edwprodhh.iso.stg_response;