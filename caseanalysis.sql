WITH raw_data AS (
SELECT *,
CAST(RTRIM(CREATED_AT, ' Z') AS TIMESTAMP) AS CREATED_AT_MOD
FROM `sumupcasestudy.sumUp.raw_data`
WHERE CREATED_AT != 'CREATED_AT'
),
sorted_data AS (
SELECT
MERCHANT_ID,
REASON,
CHANNEL,
STATUS,
CREATED_AT_MOD,
LAG(CREATED_AT_MOD) OVER (PARTITION BY MERCHANT_ID, REASON ORDER BY CREATED_AT_MOD) AS PREV_CONTACT_DATE,
LEAD(CREATED_AT_MOD) OVER (PARTITION BY MERCHANT_ID, REASON ORDER BY CREATED_AT_MOD) AS NEXT_CONTACT_DATE
FROM raw_data
),
contact_intervals AS (
SELECT
MERCHANT_ID,
REASON,
CREATED_AT_MOD AS CONTACT_DATE,
DATE_DIFF(CREATED_AT_MOD, PREV_CONTACT_DATE, DAY) AS DAYS_SINCE_LAST_CONTACT,
DATE_DIFF(NEXT_CONTACT_DATE, CREATED_AT_MOD, DAY) AS DAYS_TO_NEXT_CONTACT
FROM sorted_data
),
first_and_non_first_contact_resolutions AS (
SELECT
MERCHANT_ID,
REASON,
CONTACT_DATE,
CASE
WHEN (DAYS_SINCE_LAST_CONTACT > 7 OR DAYS_SINCE_LAST_CONTACT IS NULL)
AND (DAYS_TO_NEXT_CONTACT > 7 OR DAYS_TO_NEXT_CONTACT IS NULL)
THEN 'First Contact Resolution (7 Days)'
WHEN (DAYS_SINCE_LAST_CONTACT > 5 OR DAYS_SINCE_LAST_CONTACT IS NULL)
AND (DAYS_TO_NEXT_CONTACT > 5 OR DAYS_TO_NEXT_CONTACT IS NULL)
THEN 'First Contact Resolution (5 Days)'
ELSE 'Not First Contact Resolution'
END AS Contact_Type,
DAYS_SINCE_LAST_CONTACT,
CASE
WHEN (DAYS_SINCE_LAST_CONTACT <= 7 AND DAYS_SINCE_LAST_CONTACT IS NOT NULL)
OR (DAYS_TO_NEXT_CONTACT <= 7 AND DAYS_TO_NEXT_CONTACT IS NOT NULL)
THEN 1 ELSE 0
END AS within_7_days,
CASE
WHEN (DAYS_SINCE_LAST_CONTACT <= 5 AND DAYS_SINCE_LAST_CONTACT IS NOT NULL)
OR (DAYS_TO_NEXT_CONTACT <= 5 AND DAYS_TO_NEXT_CONTACT IS NOT NULL)
THEN 1 ELSE 0
END AS within_5_days,
CASE
WHEN (DAYS_SINCE_LAST_CONTACT > 7 OR DAYS_SINCE_LAST_CONTACT IS NULL)
AND (DAYS_TO_NEXT_CONTACT > 7 OR DAYS_TO_NEXT_CONTACT IS NULL)
THEN 1 ELSE 0
END AS first_contact_resolution_7_days,
CASE
WHEN (DAYS_SINCE_LAST_CONTACT > 5 OR DAYS_SINCE_LAST_CONTACT IS NULL)
AND (DAYS_TO_NEXT_CONTACT > 5 OR DAYS_TO_NEXT_CONTACT IS NULL)
THEN 1 ELSE 0
END AS first_contact_resolution_5_days
FROM contact_intervals
)
SELECT
COUNT(*) AS total_contacts,
AVG(DAYS_SINCE_LAST_CONTACT) AS avg_days_between_contacts,
APPROX_QUANTILES(DAYS_SINCE_LAST_CONTACT, 100)[OFFSET(50)] AS median_days_between_contacts,
APPROX_QUANTILES(DAYS_SINCE_LAST_CONTACT, 100)[OFFSET(75)] AS p80_days_between_contacts,


-- Counts and Percentages for Non-First Contact Resolutions within 5 and 7 Days
COUNTIF(within_7_days = 1) AS count_within_7_days,
COUNTIF(within_7_days = 1) * 100.0 / COUNT(*) AS percent_within_7_days,
COUNTIF(within_5_days = 1) AS count_within_5_days,
COUNTIF(within_5_days = 1) * 100.0 / COUNT(*) AS percent_within_5_days,

-- Counts and Percentages for First Contact Resolutions within 5 and 7 Days
COUNTIF(first_contact_resolution_7_days = 1) AS first_contact_resolution_7_days,
COUNTIF(first_contact_resolution_7_days = 1) * 100.0 / COUNT(*) AS percent_first_contact_resolution_7_days,
COUNTIF(first_contact_resolution_5_days = 1) AS first_contact_resolution_5_days,
COUNTIF(first_contact_resolution_5_days = 1) * 100.0 / COUNT(*) AS percent_first_contact_resolution_5_days

FROM first_and_non_first_contact_resolutions
WHERE Contact_Type IN ('Not First Contact Resolution', 'First Contact Resolution (7 Days)', 'First Contact Resolution (5 Days)')
AND DAYS_SINCE_LAST_CONTACT IS NOT NULL;




