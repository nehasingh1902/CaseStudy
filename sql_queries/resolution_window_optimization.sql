WITH raw_data AS (
SELECT *,
COALESCE(RESPONSE_TIME_SECONDS_MOD, 0) + COALESCE(TOTAL_HANDLING_TIME_SECONDS_MOD, 0) + COALESCE(QUEUE_WAITING_TIME_SECONDS_MOD, 0) AS total_resolution_seconds,
TIMESTAMP_ADD(CAST(RTRIM(CREATED_AT, ' Z') AS TIMESTAMP), INTERVAL COALESCE(RESPONSE_TIME_SECONDS_MOD, 0) + COALESCE(TOTAL_HANDLING_TIME_SECONDS_MOD, 0) + COALESCE(QUEUE_WAITING_TIME_SECONDS_MOD, 0) SECOND) AS completion_time
FROM (
SELECT *,
SAFE_CAST(RESPONSE_TIME_SECONDS AS INT64) AS RESPONSE_TIME_SECONDS_MOD,
SAFE_CAST(TOTAL_HANDLING_TIME_SECONDS AS INT64) AS TOTAL_HANDLING_TIME_SECONDS_MOD,
SAFE_CAST(QUEUE_WAITING_TIME_SECONDS AS INT64) AS QUEUE_WAITING_TIME_SECONDS_MOD
FROM `sumupcasestudy.sumUp.raw_data`
WHERE CREATED_AT != 'CREATED_AT'
)
),

-- Identify contacts with another contact within a 7-day window
contact_within_7_days AS (
SELECT
a.MERCHANT_ID,
a.REASON,
a.completion_time AS current_completion_time,
b.completion_time AS other_completion_time,
ABS(TIMESTAMP_DIFF(a.completion_time, b.completion_time, SECOND)) AS second_diff
FROM raw_data a
JOIN raw_data b
ON a.MERCHANT_ID = b.MERCHANT_ID
AND a.REASON = b.REASON
AND a.completion_time != b.completion_time
AND ABS(TIMESTAMP_DIFF(a.completion_time, b.completion_time, SECOND)) <= 604800 -- 7 days in seconds
),

-- Use first and last contacts within the identified 7-day window groups for resolution time
case_resolution_times AS (
SELECT
MERCHANT_ID,
REASON,
MIN(current_completion_time) AS first_contact_time,
MAX(other_completion_time) AS last_contact_time
FROM contact_within_7_days
GROUP BY MERCHANT_ID, REASON
),

-- Calculate the resolution time in seconds and derive the average
resolution_time_calculation AS (
SELECT
MERCHANT_ID,
REASON,
TIMESTAMP_DIFF(last_contact_time, first_contact_time, SECOND) AS resolution_time_seconds
FROM case_resolution_times
)

SELECT
AVG(resolution_time_seconds) AS average_resolution_time_seconds,
AVG(resolution_time_seconds) / 86400 AS average_resolution_time_days
FROM resolution_time_calculation;
