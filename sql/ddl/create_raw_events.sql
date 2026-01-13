CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.events;

CREATE TABLE raw.events (
  event_id UUID NOT NULL,
  event_type TEXT NOT NULL,
  event_timestamp TIMESTAMP NOT NULL,
  user_id INT NOT NULL,
  session_id UUID NOT NULL,
  page_url TEXT,
  product_id INT,
  category TEXT,
  price NUMERIC(10,2),
  quantity INT,
  device_type TEXT NOT NULL,
  traffic_source TEXT NOT NULL
);