SELECT 
    ID.IDENTIFIER AS PATIENT_ID,
    ID2.IDENTIFIER AS Hepamud_ID,
    UPPER(CONCAT(NM.GIVEN_NAME, ' ', NM.FAMILY_NAME)) AS PATIENT_NAME,
    PR.GENDER,
    YEAR(PR.date_created) - YEAR(PR.BIRTHDATE) AS AGE,
    reg.area_of_origin as 'Area of Origin',
    reg.origin_details as 'Origin Details',
    PA2.value AS Phone_Number,
    pa.date_created AS Appointment_Date,
    Status
FROM
    karachi_prod.patient_appointment pa
        INNER JOIN
    `karachi_prod`.`person` AS PR ON PR.PERSON_ID = pa.PATIENT_ID
        AND PR.voided = 0
        INNER JOIN
    `karachi_prod`.`person_name` AS NM ON NM.PERSON_ID = pa.PATIENT_ID
        AND NM.voided = 0
        AND preferred = 1
        INNER JOIN
    `karachi_prod`.`patient_identifier` AS ID ON ID.PATIENT_ID = pa.PATIENT_ID
        AND ID.IDENTIFIER_TYPE = 3
        AND ID.voided = 0
        AND ID.preferred = 1
        LEFT JOIN
    `karachi_prod`.`patient_identifier` AS ID2 ON ID2.PATIENT_ID = pa.PATIENT_ID
        AND ID2.IDENTIFIER_TYPE = 4
        AND ID2.voided = 0
        LEFT JOIN
    karachi_prod.person_attribute PA2 ON PA2.PERSON_ID = pa.PATIENT_ID
        AND PA2.person_attribute_type_id = 16
        LEFT join 
        registration as reg on reg.PATIENT_ID = ID.IDENTIFIER
WHERE
    pa.date_created = (SELECT 
            MAX(date_created)
        FROM
            karachi_prod.patient_appointment
        WHERE
            patient_id = pa.patient_id)
        AND status = 'Missed';
