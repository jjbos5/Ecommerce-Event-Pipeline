DROP TABLE IF EXISTS sessions;

-- One row per user session for analytics queries
CREATE TABLE sessions AS
SELECT
    user_id,
    session_id,
    MIN(event_time) AS session_start,
    MAX(event_time) AS session_end,
    COUNT(*) AS event_count,
    ROUND(
        EXTRACT(EPOCH FROM (MAX(event_time) - MIN(event_time))) / 60.0,
        2
    ) AS duration_minutes
FROM sessionized_events
GROUP BY user_id, session_id;

CREATE INDEX IF NOT EXISTS idx_sessions_user_start
ON sessions (user_id, session_start);

