create or replace procedure
    edwprodhh.iso.insert_response_from_stage(EXECUTE_TIME TIMESTAMP_LTZ(9))
returns     boolean
language    sql
as
begin

    insert into
        edwprodhh.iso.response
    select      sha2(METADATA$FILENAME)                                             as response_id,
                $1                                                                  as response_body,
                row_number() over (partition by METADATA$FILENAME order by seq)     as line_number,
                METADATA$FILENAME                                                   as file_name,
                :execute_time::date                                                 as upload_date
    from        (
                    select      $1,
                                metadata$filename,
                                METADATA$FILE_ROW_NUMBER as seq
                    from        @edwprodhh.iso.stg_response
                                (file_format => edwprodhh.iso.format_txt)
                    where       METADATA$FILENAME not in (select file_name from edwprodhh.iso.response_files)
                )
    ;

    insert into
        edwprodhh.iso.response_files
    (
        response_id,
        file_name,
        upload_date
    )
    select      distinct
                response_id,
                file_name,
                upload_date
    from        edwprodhh.iso.response
    where       upload_date = current_date()
                and file_name not in (select file_name from edwprodhh.iso.response_files)
    ;

end
;



create or replace task
    edwprodhh.iso.sp_insert_response_from_stage
    warehouse = analysis_wh
    schedule = 'USING CRON 0 1 * * * America/Chicago'
as
call    edwprodhh.iso.insert_response_from_stage(current_timestamp())
;