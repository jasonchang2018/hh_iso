create or replace view
    edwprodhh.pub_jchang.export_iso
as
select      debtor_idx
from        edwprodhh.pub_jchang.iso_request_log
where       upload_date = current_date()
;