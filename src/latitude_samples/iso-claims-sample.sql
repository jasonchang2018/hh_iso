with claims as
(
    select      echo.response_id as file_id,
                files.file_name,
                echo.index_ma01,
                match.index_ma03,
                
                echo.iso_file_number,
                echo.return_reason_code,
                echo.customer_code,
                regexp_replace(echo.policy_number, '^(ADV|UMMC|IU)', '') as mrn,
                echo.iso_received_date,
                
                match.iso_file_number as iso_file_number_returned,
                match.insuring_company_name,
                match.insuring_company_address,
                match.insuring_company_address_2,
                match.insuring_company_city,
                match.insuring_company_state_province,
                match.insuring_company_postal_code,
                match.insuring_company_phone,
                match.policy_number,
                match.policy_type,
                match.claim_number,
                match.date_of_loss,
                match.cat_number,
                match.loss_description,
                match.loss_location_address_line_1,
                match.loss_location_address_line_2,
                match.loss_location_city,
                match.loss_location_state,
                match.loss_location_country,
                match.loss_location_postal_code
                
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
from        claims
;