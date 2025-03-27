

SELECT
    CUSTOMER_ID,
    NAME,
    EMAIL,
    SIGNUP_DATE,
    COUNTRY
FROM {{ ref('customers') }}
