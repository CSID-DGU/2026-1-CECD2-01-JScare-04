USE bitcare;

ALTER TABLE history
  ADD COLUMN emr_json_path varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER free_text,
  ADD COLUMN emr_md_path varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER emr_json_path,
  ADD COLUMN emr_txt_path varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER emr_md_path;

ALTER TABLE patient
  ADD COLUMN height float DEFAULT NULL AFTER reg_date,
  ADD COLUMN weight float DEFAULT NULL AFTER height,
  ADD COLUMN bp_systolic int DEFAULT NULL AFTER weight,
  ADD COLUMN bp_diastolic int DEFAULT NULL AFTER bp_systolic,
  ADD COLUMN temp float DEFAULT NULL AFTER bp_diastolic,
  ADD COLUMN hr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER temp,
  ADD COLUMN rr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER hr,
  ADD COLUMN spo2 varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER rr,
  ADD COLUMN vitals_updated_at timestamp NULL DEFAULT NULL AFTER spo2;
