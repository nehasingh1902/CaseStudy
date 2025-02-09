WITH raw_data AS (SELECT *,
SAFE_CAST(TOTAL_HANDLING_TIME_SECONDS AS INT64) AS TOTAL_HANDLING_TIME_SECONDS_MOD,
SAFE_CAST(QUEUE_WAITING_TIME_SECONDS AS INT64) AS QUEUE_WAITING_TIME_SECONDS_MOD,
FROM `sumupcasestudy.sumUp.raw_data`
WHERE CREATED_AT !='CREATED_AT'
)

SELECT
CHANNEL,
AGENT_COMPANY,
(SUM(CASE WHEN STATUS = 'Resolved' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS RESOLUTION_RATE,
ROUND(AVG(TOTAL_HANDLING_TIME_SECONDS_MOD),2) AS AHT,
ROUND(AVG(QUEUE_WAITING_TIME_SECONDS_MOD),2) AS WAITING_TIME,
ROUND(AVG(RESPONSE_TIME_SECONDS_MOD),2) AS REPONSE_TIME
FROM raw_data
GROUP BY 1 ,2
