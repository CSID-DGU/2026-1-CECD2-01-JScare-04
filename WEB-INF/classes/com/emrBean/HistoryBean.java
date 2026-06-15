package com.emrBean;

import java.sql.Timestamp;

public class HistoryBean {
    private String id;
    private String employeeId;
    private String patientId;
    private String deptId;
    private String memo;
    private int bpSystolic;
    private int bpDiastolic;
    private float height;
    private float weight;
    private float temp;
    private String symptomDetail;
    private String chiefComplaint;
    private String presentIllness;
    private String pastHistory;
    private String hr;
    private String rr;
    private String spo2;
    private String labResults;
    private String imagingResults;
    private String diagnosis;
    private String plan;
    private String freeText;
    private String emrJsonPath;
    private String emrMdPath;
    private String emrTxtPath;
    private Timestamp entryDate;
    private Timestamp updatedAt;

    // Getters & Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public String getDeptId() { return deptId; }
    public void setDeptId(String deptId) { this.deptId = deptId; }

    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }

    public int getBpSystolic() { return bpSystolic; }
    public void setBpSystolic(int bpSystolic) { this.bpSystolic = bpSystolic; }

    public int getBpDiastolic() { return bpDiastolic; }
    public void setBpDiastolic(int bpDiastolic) { this.bpDiastolic = bpDiastolic; }

    public float getHeight() { return height; }
    public void setHeight(float height) { this.height = height; }

    public float getWeight() { return weight; }
    public void setWeight(float weight) { this.weight = weight; }

    public float getTemp() { return temp; }
    public void setTemp(float temp) { this.temp = temp; }

    public String getSymptomDetail() { return symptomDetail; }
    public void setSymptomDetail(String symptomDetail) { this.symptomDetail = symptomDetail; }

    public String getChiefComplaint() { return chiefComplaint; }
    public void setChiefComplaint(String chiefComplaint) { this.chiefComplaint = chiefComplaint; }

    public String getPresentIllness() { return presentIllness; }
    public void setPresentIllness(String presentIllness) { this.presentIllness = presentIllness; }

    public String getPastHistory() { return pastHistory; }
    public void setPastHistory(String pastHistory) { this.pastHistory = pastHistory; }

    public String getHr() { return hr; }
    public void setHr(String hr) { this.hr = hr; }

    public String getRr() { return rr; }
    public void setRr(String rr) { this.rr = rr; }

    public String getSpo2() { return spo2; }
    public void setSpo2(String spo2) { this.spo2 = spo2; }

    public String getLabResults() { return labResults; }
    public void setLabResults(String labResults) { this.labResults = labResults; }

    public String getImagingResults() { return imagingResults; }
    public void setImagingResults(String imagingResults) { this.imagingResults = imagingResults; }

    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

    public String getPlan() { return plan; }
    public void setPlan(String plan) { this.plan = plan; }

    public String getFreeText() { return freeText; }
    public void setFreeText(String freeText) { this.freeText = freeText; }

    public String getEmrJsonPath() { return emrJsonPath; }
    public void setEmrJsonPath(String emrJsonPath) { this.emrJsonPath = emrJsonPath; }

    public String getEmrMdPath() { return emrMdPath; }
    public void setEmrMdPath(String emrMdPath) { this.emrMdPath = emrMdPath; }

    public String getEmrTxtPath() { return emrTxtPath; }
    public void setEmrTxtPath(String emrTxtPath) { this.emrTxtPath = emrTxtPath; }

    public Timestamp getEntryDate() { return entryDate; }
    public void setEntryDate(Timestamp entryDate) { this.entryDate = entryDate; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
