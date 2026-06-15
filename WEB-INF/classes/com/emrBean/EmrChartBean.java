package com.emrBean;

public class EmrChartBean {
    private int chartId;
    private String patientId;
    private String doctorName;
    private String visitDate;
    
    private String chiefComplaint;
    private String presentIllness;
    private String pastHistory;
    
    private String bp;
    private String hr;
    private String temp;
    private String rr;
    private String spo2;
    private String height;
    private String weight;
    
    private String labResults;
    private String imagingResults;
    private String diagnosis;
    private String plan;
    private String freeText;

    // Getter & Setter 자동 생성 (Eclipse: Alt+Shift+S -> R)
    public int getChartId() { return chartId; }
    public void setChartId(int chartId) { this.chartId = chartId; }
    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }
    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
    public String getVisitDate() { return visitDate; }
    public void setVisitDate(String visitDate) { this.visitDate = visitDate; }
    public String getChiefComplaint() { return chiefComplaint; }
    public void setChiefComplaint(String chiefComplaint) { this.chiefComplaint = chiefComplaint; }
    public String getPresentIllness() { return presentIllness; }
    public void setPresentIllness(String presentIllness) { this.presentIllness = presentIllness; }
    public String getPastHistory() { return pastHistory; }
    public void setPastHistory(String pastHistory) { this.pastHistory = pastHistory; }
    public String getBp() { return bp; }
    public void setBp(String bp) { this.bp = bp; }
    public String getHr() { return hr; }
    public void setHr(String hr) { this.hr = hr; }
    public String getTemp() { return temp; }
    public void setTemp(String temp) { this.temp = temp; }
    public String getRr() { return rr; }
    public void setRr(String rr) { this.rr = rr; }
    public String getSpo2() { return spo2; }
    public void setSpo2(String spo2) { this.spo2 = spo2; }
    public String getHeight() { return height; }
    public void setHeight(String height) { this.height = height; }
    public String getWeight() { return weight; }
    public void setWeight(String weight) { this.weight = weight; }
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
}