package com.emrDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import com.emrBean.WaitingBean;

public class WaitingDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static WaitingDAO instance = new WaitingDAO();
    public static WaitingDAO getInstance() { return instance; }

    private WaitingDAO() {
        try {
            conn = DbConfig.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 전체 대기 중인 환자 목록 조회
     */
    public List<WaitingBean> getWaitingList() {
        List<WaitingBean> list = new ArrayList<>();
        try {
            String sql = "SELECT w.id AS waiting_id, w.code, w.state, p.id AS patient_id, p.name, p.gender,p.birth, p.phone, w.entry_date " +
                         "FROM waiting w JOIN patient p ON w.patient_id = p.id " +
                         "ORDER BY w.entry_date ASC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                WaitingBean wb = new WaitingBean();
                wb.setId(rs.getString("waiting_id"));
                wb.setCode(rs.getString("code"));
                wb.setState(rs.getString("state"));
                wb.setPatientId(rs.getString("patient_id"));
                wb.setPatientName(rs.getString("name"));
                wb.setGender(rs.getString("gender"));
                wb.setBirth(rs.getString("birth"));
                wb.setPhone(rs.getString("phone"));
                wb.setEntryDate(rs.getTimestamp("entry_date"));
                list.add(wb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 대기 상태 업데이트 (예: 접수 완료 → 진료 중)
     */
    public boolean updateWaitingState(String waitingId, String newState) {
        try {
            String sql = "UPDATE waiting SET state=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newState);
            pstmt.setString(2, waitingId);
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 새 대기자 추가
     */
    public boolean addWaiting(String id, String code, String patientId) {
        try {
            String sql = "INSERT INTO waiting (id, code, state, patient_id) VALUES (?, ?, '대기중', ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, code);
            pstmt.setString(3, patientId);
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean deleteWaiting(String waitingId) {
        try {
            String sql = "DELETE FROM waiting WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, waitingId);
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

