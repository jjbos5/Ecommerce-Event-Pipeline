CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.raw_events;

CREATE TABLE raw.raw_events (
  event_id        UUID,
  event_type      TEXT,
  event_timestamp TIMESTAMP,
  user_id         INT,
  session_id      UUID,
  page_url        TEXT,
  product_id      INT,
  category        TEXT,
  price           NUMERIC(10,2),
  quantity        INT,
  device_type     TEXT,
  traffic_source  TEXT
);