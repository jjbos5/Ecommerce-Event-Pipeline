DROP TABLE IF EXISTS stg_events;

CREATE TABLE stg_events AS
SELECT
    event_id,
    event_type,
    event_timestamp AS event_time,
    user_id,
    session_id,
    page_url,
    product_id,
    category,
    price,
    quantity,
    device_type,
    traffic_source
FROM raw.events
WHERE event_id IS NOT NULL
  AND user_id IS NOT NULL
  AND event_timestamp IS NOT NULL
  AND event_type IS NOT NULL;

-- Helpful indexes (speed up window functions later)
CREATE INDEX IF NOT EXISTS idx_stg_events_user_time
ON stg_events (user_id, event_time);
