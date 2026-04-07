create table
    edwprodhh.pub_jchang.iso_request_log
(
    debtor_idx      varchar,
    upload_date     date
)
;


--Need to set as a task like IDOR
insert into
    edwprodhh.pub_jchang.iso_request_log
with previous_packets as
(
    select      distinct
                debtor.packet_idx,
                dimdebtor.drl
    from        edwprodhh.pub_jchang.master_debtor as debtor
                left join
                    edwprodhh.dw.dimdebtor as dimdebtor
                    on debtor.debtor_idx = dimdebtor.debtor_idx
                inner join
                    edwprodhh.pub_jchang.iso_request_log as iso_request_log
                    on debtor.debtor_idx = iso_request_log.debtor_idx
)
--* Need list of fields to include.
select      debtor.debtor_idx,
            current_date() as upload_date
from        edwprodhh.pub_jchang.master_debtor as debtor
            left join
                edwprodhh.dw.dimdebtor as dimdebtor
                on debtor.debtor_idx = dimdebtor.debtor_idx
where       case    when    debtor.pl_group = 'ADVOCATE HC - TPL'
                    then    case    when    dimdebtor.desk in ('LN1')
                                    and     debtor.balance_dimdebtor >= 500
                                    then    TRUE
                                    else    FALSE
                                    end
                    when    debtor.pl_group = 'IU HEALTH - TPL'
                    then    case    when    debtor.client_idx not in ('HH-2175NLIPB') --exclude PB
                                    and     dimdebtor.desk in ('IU1')
                                    and     debtor.balance_dimdebtor >= 500
                                    then    TRUE
                                    else    FALSE
                                    end
                    when    debtor.pl_group = 'U OF MISSISSIPPI MEDICAL CENTER - TPL'
                    then    case    when    debtor.client_idx not in ('HH-2170NLIPB', 'HH-2171NLIPB') --exclude PB
                                    and     dimdebtor.desk in ('UM1')
                                    and     debtor.balance_dimdebtor >= 500
                                    then    TRUE
                                    else    FALSE
                                    end
                    else    FALSE
                    end
            and debtor.packet_idx   not in (select packet_idx from previous_packets)
            and dimdebtor.drl       not in (select drl from previous_packets)
            --** Need to exclude based on values in F303-F310 and F323-330. Waiting on Dan and Heather
;


-- Report Type (Initial, Replacement)
-- Customer (Insuring Company) Code
-- Policy Number
-- Policy Type
-- Claim Number
-- Date of Loss
-- Location of Loss State
-- Role in the claim (for each involved party)
-- Insured First and Last Name or Business Name
-- Insured Address, City, and State
-- Claimant First and Last Name (3rd party claims only)
-- Claimant Address, City, and State
-- Coverage Type
-- Loss Type



create or replace view
    edwprodhh.pub_jchang.export_iso
as
select      debtor_idx
from        edwprodhh.pub_jchang.iso_request_log
where       upload_date = current_date()
;