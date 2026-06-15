USE bitcare;

ALTER TABLE history
  ADD COLUMN chief_complaint longtext COLLATE utf8mb4_unicode_ci AFTER symptom_detail,
  ADD COLUMN present_illness longtext COLLATE utf8mb4_unicode_ci AFTER chief_complaint,
  ADD COLUMN past_history longtext COLLATE utf8mb4_unicode_ci AFTER present_illness,
  ADD COLUMN hr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER past_history,
  ADD COLUMN rr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER hr,
  ADD COLUMN spo2 varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER rr,
  ADD COLUMN lab_results longtext COLLATE utf8mb4_unicode_ci AFTER spo2,
  ADD COLUMN imaging_results longtext COLLATE utf8mb4_unicode_ci AFTER lab_results,
  ADD COLUMN diagnosis varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER imaging_results,
  ADD COLUMN plan longtext COLLATE utf8mb4_unicode_ci AFTER diagnosis,
  ADD COLUMN free_text longtext COLLATE utf8mb4_unicode_ci AFTER plan;

UPDATE history
SET chief_complaint = COALESCE(chief_complaint, symptom_detail),
    plan = COALESCE(plan, memo);
