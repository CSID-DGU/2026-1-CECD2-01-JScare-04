CREATE DATABASE IF NOT EXISTS bitcare
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

use bitcare;

-- bitcare.address definition

CREATE TABLE address (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,zip_code varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,road_address varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,street_address varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,extra_address varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,patient_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,PRIMARY KEY (id),KEY patient_id (patient_id),CONSTRAINT address_ibfk_1 FOREIGN KEY (patient_id) REFERENCES patient (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.alarm definition

CREATE TABLE alarm (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,sender varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,receiver varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,content varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,type varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,state varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,entry_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,employee_id varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,PRIMARY KEY (id),KEY employee_id (employee_id),CONSTRAINT alarm_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.appointment definition

CREATE TABLE appointment (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '예약 고유 ID (예: AP001)',patient_id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '환자 ID → patient(id)',employee_id varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '담당 의사 ID → employee(id)',dept_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '진료과 ID → dept(id)',appt_date date NOT NULL COMMENT '예약 날짜',appt_time varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '예약 시간 HH (예: 09:30)',appt_type varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '초진' COMMENT '초진 / 재진',state varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '예약' COMMENT '예약 / 대기 / 진료중 / 완료 / 취소',memo varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '예약 메모',entry_date timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',PRIMARY KEY (id),KEY employee_id (employee_id),KEY dept_id (dept_id),KEY idx_appt_date (appt_date),KEY idx_appt_patient (patient_id),CONSTRAINT appointment_ibfk_1 FOREIGN KEY (patient_id) REFERENCES patient (id),CONSTRAINT appointment_ibfk_2 FOREIGN KEY (employee_id) REFERENCES employee (id),CONSTRAINT appointment_ibfk_3 FOREIGN KEY (dept_id) REFERENCES dept (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='환자 예약 테이블';

-- bitcare.body_category definition

CREATE TABLE body_category (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,category_name varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,image_path varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.dept definition

CREATE TABLE dept (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,code varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,name varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,PRIMARY KEY (id),UNIQUE KEY code (code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.diagnose definition

CREATE TABLE diagnose (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,code varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,name varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,dose int DEFAULT NULL,days int DEFAULT NULL,patient_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,PRIMARY KEY (id),KEY patient_id (patient_id),CONSTRAINT diagnose_ibfk_1 FOREIGN KEY (patient_id) REFERENCES patient (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.disease definition

CREATE TABLE disease (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,code varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,name varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,PRIMARY KEY (id),UNIQUE KEY code (code)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.employee definition

CREATE TABLE employee (id varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,password varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,name varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,dept_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,role varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,email varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,phone varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,hire_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (id),KEY dept_id (dept_id),CONSTRAINT employee_ibfk_1 FOREIGN KEY (dept_id) REFERENCES dept (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.emr_chart definition

CREATE TABLE emr_chart (chart_id int NOT NULL AUTO_INCREMENT,patient_id varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,doctor_name varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,visit_date datetime DEFAULT CURRENT_TIMESTAMP,chief_complaint text COLLATE utf8mb4_unicode_ci,present_illness text COLLATE utf8mb4_unicode_ci,past_history text COLLATE utf8mb4_unicode_ci,bp varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,hr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,temp varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,rr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,spo2 varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,height varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,weight varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,lab_results text COLLATE utf8mb4_unicode_ci,imaging_results text COLLATE utf8mb4_unicode_ci,diagnosis varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,plan text COLLATE utf8mb4_unicode_ci,free_text text COLLATE utf8mb4_unicode_ci,PRIMARY KEY (chart_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.history definition

CREATE TABLE history (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,employee_id varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,patient_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,dept_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,memo varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,bp_systolic int DEFAULT NULL,bp_diastolic int DEFAULT NULL,height float DEFAULT NULL,weight float DEFAULT NULL,temp float DEFAULT NULL,symptom_detail longtext COLLATE utf8mb4_unicode_ci,chief_complaint longtext COLLATE utf8mb4_unicode_ci,present_illness longtext COLLATE utf8mb4_unicode_ci,past_history longtext COLLATE utf8mb4_unicode_ci,hr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,rr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,spo2 varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,lab_results longtext COLLATE utf8mb4_unicode_ci,imaging_results longtext COLLATE utf8mb4_unicode_ci,diagnosis varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,plan longtext COLLATE utf8mb4_unicode_ci,free_text longtext COLLATE utf8mb4_unicode_ci,emr_json_path varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,emr_md_path varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,emr_txt_path varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,entry_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,updated_at timestamp NULL DEFAULT NULL,visit varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,body_category_id int DEFAULT NULL,PRIMARY KEY (id),KEY employee_id (employee_id),KEY patient_id (patient_id),KEY dept_id (dept_id),CONSTRAINT history_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee (id),CONSTRAINT history_ibfk_2 FOREIGN KEY (patient_id) REFERENCES patient (id),CONSTRAINT history_ibfk_3 FOREIGN KEY (dept_id) REFERENCES dept (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.history_diagnose definition

CREATE TABLE history_diagnose (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,history_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,diagnose_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,PRIMARY KEY (id),KEY history_id (history_id),KEY diagnose_id (diagnose_id),CONSTRAINT history_diagnose_ibfk_1 FOREIGN KEY (history_id) REFERENCES history (id),CONSTRAINT history_diagnose_ibfk_2 FOREIGN KEY (diagnose_id) REFERENCES diagnose (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.history_disease definition

CREATE TABLE history_disease (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,history_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,disease_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,PRIMARY KEY (id),KEY history_id (history_id),KEY disease_id (disease_id),CONSTRAINT history_disease_ibfk_1 FOREIGN KEY (history_id) REFERENCES history (id),CONSTRAINT history_disease_ibfk_2 FOREIGN KEY (disease_id) REFERENCES disease (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.history_image definition

CREATE TABLE history_image (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,history_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,image_path varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,image_key varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,category_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,edited float DEFAULT NULL,entry_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (id),KEY history_id (history_id),KEY category_id (category_id),CONSTRAINT history_image_ibfk_1 FOREIGN KEY (history_id) REFERENCES history (id),CONSTRAINT history_image_ibfk_2 FOREIGN KEY (category_id) REFERENCES body_category (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.message definition

CREATE TABLE message (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,sender varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,receiver varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,content longtext COLLATE utf8mb4_unicode_ci,message_file varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,state varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,entry_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,employee_id varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,PRIMARY KEY (id),KEY employee_id (employee_id),CONSTRAINT message_ibfk_1 FOREIGN KEY (employee_id) REFERENCES employee (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.patient definition

CREATE TABLE patient (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,name varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,gender varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,birth date DEFAULT NULL,phone varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,reg_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,height float DEFAULT NULL,weight float DEFAULT NULL,bp_systolic int DEFAULT NULL,bp_diastolic int DEFAULT NULL,temp float DEFAULT NULL,hr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,rr varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,spo2 varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,vitals_updated_at timestamp NULL DEFAULT NULL,PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.receipt definition

CREATE TABLE receipt (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,history_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,patient_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,imp_uid varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,card_number varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,apply_num varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,PRIMARY KEY (id),KEY history_id (history_id),KEY patient_id (patient_id),CONSTRAINT receipt_ibfk_1 FOREIGN KEY (history_id) REFERENCES history (id),CONSTRAINT receipt_ibfk_2 FOREIGN KEY (patient_id) REFERENCES patient (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.visit definition

CREATE TABLE visit (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,code varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,content varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,entry_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,patient_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,PRIMARY KEY (id),KEY patient_id (patient_id),CONSTRAINT visit_ibfk_1 FOREIGN KEY (patient_id) REFERENCES patient (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitcare.waiting definition

CREATE TABLE waiting (id varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,code varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,state varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,patient_id varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,entry_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (id),KEY patient_id (patient_id),CONSTRAINT waiting_ibfk_1 FOREIGN KEY (patient_id) REFERENCES patient (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO dept (id, code, name) VALUES
  ('01', 'INT', CONVERT(0xEB82B4EAB3BC USING utf8mb4)),
  ('02', 'SUR', CONVERT(0xEC99B8EAB3BC USING utf8mb4)),
  ('03', 'PED', CONVERT(0xEC868CEC9584ECB2ADEC868CEB8584EAB3BC USING utf8mb4)),
  ('04', 'OBG', CONVERT(0xEC82B0EBB680EC9DB8EAB3BC USING utf8mb4)),
  ('05', 'ORT', CONVERT(0xECA095ED9895EC99B8EAB3BC USING utf8mb4)),
  ('06', 'DER', CONVERT(0xED94BCEBB680EAB3BC USING utf8mb4)),
  ('07', 'ENT', CONVERT(0xEC9DB4EBB984EC9DB8ED9B84EAB3BC USING utf8mb4)),
  ('08', 'OPH', CONVERT(0xEC9588EAB3BC USING utf8mb4)),
  ('09', 'NEU', CONVERT(0xEC8BA0EAB2BDEAB3BC USING utf8mb4)),
  ('10', 'PSY', CONVERT(0xECA095EC8BA0EAB1B4EAB095EC9D98ED9599EAB3BC USING utf8mb4))
ON DUPLICATE KEY UPDATE
  code = VALUES(code),
  name = VALUES(name);
