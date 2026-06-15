USE bitcare;

ALTER TABLE alarm DROP FOREIGN KEY alarm_ibfk_1;
ALTER TABLE appointment DROP FOREIGN KEY appointment_ibfk_2;
ALTER TABLE history DROP FOREIGN KEY history_ibfk_1;
ALTER TABLE message DROP FOREIGN KEY message_ibfk_1;

ALTER TABLE employee MODIFY id varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL;
ALTER TABLE alarm MODIFY employee_id varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL;
ALTER TABLE appointment MODIFY employee_id varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL;
ALTER TABLE history MODIFY employee_id varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL;
ALTER TABLE message MODIFY employee_id varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL;

ALTER TABLE alarm
  ADD CONSTRAINT alarm_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee (id);
ALTER TABLE appointment
  ADD CONSTRAINT appointment_ibfk_2 FOREIGN KEY (employee_id) REFERENCES employee (id);
ALTER TABLE history
  ADD CONSTRAINT history_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee (id);
ALTER TABLE message
  ADD CONSTRAINT message_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee (id);
