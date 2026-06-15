package com.emrBean;

public class AppointmentBean {
    private String apptId;
    private String patientId;
    private String name;
    private String birth;
    private String gender;
    private String time;
    private String dept;
    private String doctor;
    private String type;
    private String state;
    private String memo;

    // Getter & Setter
    public String getApptId() { return apptId; }
    public void setApptId(String apptId) { this.apptId = apptId; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBirth() { return birth; }
    public void setBirth(String birth) { this.birth = birth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }

    public String getDept() { return dept; }
    public void setDept(String dept) { this.dept = dept; }

    public String getDoctor() { return doctor; }
    public void setDoctor(String doctor) { this.doctor = doctor; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }
}