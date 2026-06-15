package com.emrDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import com.emrBean.HistoryBean;

public class HistoryDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static HistoryDAO instance = new HistoryDAO();
    public static HistoryDAO getInstance() { return instance; }

    private HistoryDAO() {
        try {
            conn = DbConfig.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** 특정 환자의 과거 진료 기록 조회 */
    public List<HistoryBean> getHistoryByPatient(String patientId) {
        List<HistoryBean> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM history WHERE patient_id = ? ORDER BY entry_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, patientId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                HistoryBean h = new HistoryBean();
                h.setId(rs.getString("id"));
                h.setEmployeeId(rs.getString("employee_id"));
                h.setPatientId(rs.getString("patient_id"));
                h.setDeptId(rs.getString("dept_id"));
                h.setMemo(rs.getString("memo"));
                h.setBpSystolic(rs.getInt("bp_systolic"));
                h.setBpDiastolic(rs.getInt("bp_diastolic"));
                h.setHeight(rs.getFloat("height"));
                h.setWeight(rs.getFloat("weight"));
                h.setTemp(rs.getFloat("temp"));
                h.setSymptomDetail(rs.getString("symptom_detail"));
                h.setChiefComplaint(rs.getString("chief_complaint"));
                h.setPresentIllness(rs.getString("present_illness"));
                h.setPastHistory(rs.getString("past_history"));
                h.setHr(rs.getString("hr"));
                h.setRr(rs.getString("rr"));
                h.setSpo2(rs.getString("spo2"));
                h.setLabResults(rs.getString("lab_results"));
                h.setImagingResults(rs.getString("imaging_results"));
                h.setDiagnosis(rs.getString("diagnosis"));
                h.setPlan(rs.getString("plan"));
                h.setFreeText(rs.getString("free_text"));
                h.setEmrJsonPath(rs.getString("emr_json_path"));
                h.setEmrMdPath(rs.getString("emr_md_path"));
                h.setEmrTxtPath(rs.getString("emr_txt_path"));
                h.setEntryDate(rs.getTimestamp("entry_date"));
                h.setUpdatedAt(rs.getTimestamp("updated_at"));
                EmrRecordStorage.loadInto(h);
                list.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 새 진료 기록 저장 */
    public boolean insertHistory(HistoryBean h) {
        try {
            EmrRecordStorage.save(h);
            String sql = "INSERT INTO history "
                       + "(id, employee_id, patient_id, dept_id, memo, bp_systolic, bp_diastolic, height, weight, temp, "
                       + "symptom_detail, chief_complaint, present_illness, past_history, hr, rr, spo2, lab_results, "
                       + "imaging_results, diagnosis, plan, free_text, emr_json_path, emr_md_path, emr_txt_path, entry_date) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, h.getId());
            pstmt.setString(2, h.getEmployeeId());
            pstmt.setString(3, h.getPatientId());
            pstmt.setString(4, h.getDeptId());
            pstmt.setString(5, null);
            pstmt.setInt(6, h.getBpSystolic());
            pstmt.setInt(7, h.getBpDiastolic());
            pstmt.setFloat(8, h.getHeight());
            pstmt.setFloat(9, h.getWeight());
            pstmt.setFloat(10, h.getTemp());
            pstmt.setString(11, null);
            pstmt.setString(12, null);
            pstmt.setString(13, null);
            pstmt.setString(14, null);
            pstmt.setString(15, h.getHr());
            pstmt.setString(16, h.getRr());
            pstmt.setString(17, h.getSpo2());
            pstmt.setString(18, null);
            pstmt.setString(19, null);
            pstmt.setString(20, null);
            pstmt.setString(21, null);
            pstmt.setString(22, null);
            pstmt.setString(23, h.getEmrJsonPath());
            pstmt.setString(24, h.getEmrMdPath());
            pstmt.setString(25, h.getEmrTxtPath());
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateHistory(HistoryBean h) {
        try {
            EmrRecordStorage.save(h);
            String sql = "UPDATE history SET memo=?, symptom_detail=?, bp_systolic=?, bp_diastolic=?, height=?, weight=?, temp=?, "
                       + "chief_complaint=?, present_illness=?, past_history=?, hr=?, rr=?, spo2=?, lab_results=?, "
                       + "imaging_results=?, diagnosis=?, plan=?, free_text=?, emr_json_path=?, emr_md_path=?, emr_txt_path=?, updated_at=NOW() WHERE id=?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, null);
            pstmt.setString(2, null);
            pstmt.setInt(3, h.getBpSystolic());
            pstmt.setInt(4, h.getBpDiastolic());
            pstmt.setFloat(5, h.getHeight());
            pstmt.setFloat(6, h.getWeight());
            pstmt.setFloat(7, h.getTemp());
            pstmt.setString(8, null);
            pstmt.setString(9, null);
            pstmt.setString(10, null);
            pstmt.setString(11, h.getHr());
            pstmt.setString(12, h.getRr());
            pstmt.setString(13, h.getSpo2());
            pstmt.setString(14, null);
            pstmt.setString(15, null);
            pstmt.setString(16, null);
            pstmt.setString(17, null);
            pstmt.setString(18, null);
            pstmt.setString(19, h.getEmrJsonPath());
            pstmt.setString(20, h.getEmrMdPath());
            pstmt.setString(21, h.getEmrTxtPath());
            pstmt.setString(22, h.getId()); // 수정할 기록의 ID (WHERE 조건)
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
 // [추가] ID로 특정 진료 기록 1건 조회
    public HistoryBean getHistoryById(String id) {
        HistoryBean h = null;
        try {
            String sql = "SELECT * FROM history WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                h = new HistoryBean();
                h.setId(rs.getString("id"));
                h.setEmployeeId(rs.getString("employee_id"));
                h.setPatientId(rs.getString("patient_id"));
                h.setDeptId(rs.getString("dept_id"));
                h.setMemo(rs.getString("memo"));
                h.setSymptomDetail(rs.getString("symptom_detail"));
                h.setBpSystolic(rs.getInt("bp_systolic"));
                h.setBpDiastolic(rs.getInt("bp_diastolic"));
                h.setTemp(rs.getFloat("temp"));
                h.setWeight(rs.getFloat("weight"));
                h.setHeight(rs.getFloat("height"));
                h.setChiefComplaint(rs.getString("chief_complaint"));
                h.setPresentIllness(rs.getString("present_illness"));
                h.setPastHistory(rs.getString("past_history"));
                h.setHr(rs.getString("hr"));
                h.setRr(rs.getString("rr"));
                h.setSpo2(rs.getString("spo2"));
                h.setLabResults(rs.getString("lab_results"));
                h.setImagingResults(rs.getString("imaging_results"));
                h.setDiagnosis(rs.getString("diagnosis"));
                h.setPlan(rs.getString("plan"));
                h.setFreeText(rs.getString("free_text"));
                h.setEmrJsonPath(rs.getString("emr_json_path"));
                h.setEmrMdPath(rs.getString("emr_md_path"));
                h.setEmrTxtPath(rs.getString("emr_txt_path"));
                h.setEntryDate(rs.getTimestamp("entry_date"));
                h.setUpdatedAt(rs.getTimestamp("updated_at"));
                EmrRecordStorage.loadInto(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return h;
    }
}

