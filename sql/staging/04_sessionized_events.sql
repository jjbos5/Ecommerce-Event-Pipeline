DROP TABLE IF EXISTS sessionized_events;

CREATE TABLE sessionized_events AS
WITH ordered_events AS (
    SELECT
        *,
        LAG(event_time) OVER (
            PARTITION BY user_id
            ORDER BY event_time
        ) AS prev_event_time
    FROM stg_events
),
session_flags AS (
    SELECT
        *,
        CASE
            WHEN prev_event_time IS NULL THEN 1
            WHEN event_time - prev_event_time > INTERVAL '30 minutes' THEN 1
            ELSE 0
        END AS is_new_session
    FROM ordered_events
)
SELECT
    *,
    SUM(is_new_session) OVER (
        PARTITION BY user_id
        ORDER BY event_time
    ) AS session_number
FROM session_flags;

CREATE INDEX IF NOT EXISTS idx_sessionized_user_session
ON sessionized_events (user_id, session_number);
