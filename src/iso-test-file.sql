select      debtor.debtor_idx,
            debtor.pl_group,

            'H39500001' as office_code,
            case    when    debtor.pl_group = 'U OF MISSISSIPPI MEDICAL CENTER - TPL'
                    then    'UMMC' || dimdebtor.drl
                    when    debtor.pl_group = 'IU HEALTH - TPL'
                    then    'IU' || dimdebtor.drl
                    when    debtor.pl_group = 'ADVOCATE HC - TPL'
                    then    'ADV' || trim(ltrim(dimdebtor.drl, '0'))
                    else    NULL
                    end      as claim_number,
            to_varchar(debtor.lst_chg_dt, 'mmddyyyy') as date_of_loss,
            claim_number as policy_number,

            'Personal Automobile' as policy_type,
            debtor.state as loss_state, --need heather to confirm where i can find accident state
            'AUTO ACCIDENT' as loss_description, --need heather to confirm how to select vs workers comp

            TRUE as insured_has_a_claim,
            debtor.lastname as last_name,
            debtor.firstname as first_name,
            debtor.address_1, --need heather to confirm this containing address_2 is ok
            trim(regexp_substr(debtor.city, '^[^\\,]*')) as city,
            debtor.state,
            debtor.zip_code,
            to_varchar(dimdebtor.dob, 'mmddyyyy') as dob,
            dimdebtor.ssn, --need jeff to unmask
            edwprodhh.pub_jchang.contact_address_format_phone(dimdebtor.phone) as home_phone,

            TRUE    as collision,
            TRUE    as comprehensive,
            FALSE   as glass,
            TRUE    as medical_payments,
            TRUE    as pip,
            FALSE   as rental_reimbursement,
            FALSE   as towing_labor,
            TRUE    as underinsured_motorist,
            TRUE    as uninsured_motorist,
            TRUE    as other_auto,
            TRUE    as general_property,
            FALSE   as other_auto,
            FALSE   as no_coverage_casualty,
            FALSE   as no_coverage_property,
            FALSE   as no_coverage_automobile,
            'N/A'   as alleged_injuries_property_damage,

            -- case    when    coverage_type = 'Medical Payments'
            --         then    'Medical Payments'
            --         when    coverage_type = 'Pip'
            --         then    'Pip'
            --         when    coverage_type in ('Underinsured', 'Uninsured')
            --         then    'Bodily Injury'
            --         when    coverage_type = 'Other'
            --         then    'Other Auto (Non-Vehicle Injury or Damage)'
            --         end     as loss_type, --need heather to confirm coverage_type value
            'Open'  as claim_status

            -- trim(dimfiscal_hh_a.ins_policy) as policy_number

            
from        edwprodhh.pub_jchang.master_debtor as debtor
            inner join
                edwprodhh.dw.dimdebtor as dimdebtor
                on debtor.debtor_idx = dimdebtor.debtor_idx
            inner join
                edwprodhh.dw.dimfiscal_hh_a as dimfiscal_hh_a
                on debtor.debtor_idx = dimfiscal_hh_a.debtor_idx
where       
            and debtor.pl_group = 'U OF MISSISSIPPI MEDICAL CENTER - TPL'
;