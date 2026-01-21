DROP TABLE IF EXISTS sessionized_events;

CREATE TABLE sessionized_events AS

-- Step 1: Order events per user and calculate time since previous event
WITH ordered_events AS (
    SELECT
        *,
        LAG(event_time) OVER (
            PARTITION BY user_id
            ORDER BY event_time
        ) AS prev_event_time
    FROM stg_events
),

-- Step 2: Flag the start of a new session using a 30-minute inactivity rule
session_flags AS (
    SELECT
        *,
        CASE
            WHEN prev_event_time IS NULL THEN 1
            WHEN event_time - prev_event_time >= INTERVAL '30 minutes' THEN 1
            ELSE 0
        END AS is_new_session
    FROM ordered_events
),

-- Step 3: Assign a session number per user using cumulative sum
numbered_sessions AS (
    SELECT
        *,
        SUM(is_new_session) OVER (
            PARTITION BY user_id
            ORDER BY event_time
        ) AS session_number
    FROM session_flags
)

-- Step 4: Add a business-facing session_id
SELECT
    *,
    user_id || '-' || session_number AS session_id
FROM numbered_sessions;

CREATE INDEX IF NOT EXISTS idx_sessionized_user_session
ON sessionized_events (user_id, session_number);
