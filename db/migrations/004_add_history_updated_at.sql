USE bitcare;

ALTER TABLE history
  ADD COLUMN updated_at timestamp NULL DEFAULT NULL AFTER entry_date;
