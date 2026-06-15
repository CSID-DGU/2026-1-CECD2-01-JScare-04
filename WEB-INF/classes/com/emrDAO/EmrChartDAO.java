package com.emrDAO;

import java.sql.*;
import com.emrBean.EmrChartBean;

public class EmrChartDAO {
    private Connection conn;
    private PreparedStatement pstmt;

    private static EmrChartDAO instance = new EmrChartDAO();
    public static EmrChartDAO getInstance() { return instance; }

    private EmrChartDAO() {
        try {
            conn = DbConfig.getConnection();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public boolean insertChart(EmrChartBean emr) {
        String sql = "INSERT INTO emr_chart "
                   + "(patient_id, doctor_name, chief_complaint, present_illness, past_history, "
                   + "bp, hr, temp, rr, height, weight, lab_results, imaging_results, diagnosis, plan, free_text) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, emr.getPatientId());
            pstmt.setString(2, emr.getDoctorName());
            pstmt.setString(3, emr.getChiefComplaint());
            pstmt.setString(4, emr.getPresentIllness());
            pstmt.setString(5, emr.getPastHistory());
            pstmt.setString(6, emr.getBp());
            pstmt.setString(7, emr.getHr());
            pstmt.setString(8, emr.getTemp());
            pstmt.setString(9, emr.getRr());
            pstmt.setString(10, emr.getHeight());
            pstmt.setString(11, emr.getWeight());
            pstmt.setString(12, emr.getLabResults());
            pstmt.setString(13, emr.getImagingResults());
            pstmt.setString(14, emr.getDiagnosis());
            pstmt.setString(15, emr.getPlan());
            pstmt.setString(16, emr.getFreeText());
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
