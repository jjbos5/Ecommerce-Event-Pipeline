DROP VIEW IF EXISTS stg_events;

CREATE VIEW stg_events AS
SELECT
  event_id,
  user_id,
  event_timestamp AS event_time,
  LOWER(TRIM(event_type)) AS event_type,
  page_url,
  product_id,
  category,
  price,
  quantity,
  device_type,
  traffic_source
FROM raw.raw_events
WHERE user_id IS NOT NULL
  AND event_timestamp IS NOT NULL
  AND event_type IS NOT NULL;
