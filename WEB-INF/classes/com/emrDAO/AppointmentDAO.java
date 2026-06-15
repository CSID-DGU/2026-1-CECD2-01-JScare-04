package com.emrDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.emrBean.AppointmentBean;

public class AppointmentDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 싱글톤 패턴 적용
    private static AppointmentDAO instance = new AppointmentDAO();
    public static AppointmentDAO getInstance() { return instance; }

    // 생성자: 객체 생성 시 1회 DB 연결
    private AppointmentDAO() {
        try {
            conn = DbConfig.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 특정 날짜의 예약 목록 조회
     */
    public List<AppointmentBean> getAppointmentsByDate(String date) {
        List<AppointmentBean> list = new ArrayList<>();
        
        if (date == null || date.trim().isEmpty()) {
            return list;
        }

        try {
            String sql = 
                "SELECT a.id AS appt_id, a.patient_id, p.name AS patient_name, " +
                "       DATE_FORMAT(p.birth, '%Y.%m.%d') AS birth, p.gender, " +
                "       a.appt_time, d.name AS dept_name, e.name AS doctor_name, " +
                "       a.appt_type, a.state, a.memo " +
                "FROM appointment a " +
                "JOIN patient p ON a.patient_id = p.id " +
                "LEFT JOIN employee e ON a.employee_id = e.id " +
                "LEFT JOIN dept d ON a.dept_id = d.id " +
                "WHERE a.appt_date = ? " +
                "ORDER BY a.appt_time ASC";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, date);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                AppointmentBean ab = new AppointmentBean();
                ab.setApptId(nvl(rs.getString("appt_id")));
                ab.setPatientId(nvl(rs.getString("patient_id")));
                ab.setName(nvl(rs.getString("patient_name")).replace("\"", "\\\""));
                ab.setBirth(nvl(rs.getString("birth")));
                ab.setGender(nvl(rs.getString("gender")));
                ab.setTime(nvl(rs.getString("appt_time")));
                ab.setDept(nvl(rs.getString("dept_name")).replace("\"", "\\\""));
                ab.setDoctor(nvl(rs.getString("doctor_name")).replace("\"", "\\\""));
                ab.setType(nvl(rs.getString("appt_type")));
                ab.setState(nvl(rs.getString("state")));
                ab.setMemo(nvl(rs.getString("memo")).replace("\"", "\\\""));
                
                list.add(ab);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<String> getAppointmentDates(String year, String month) {
        List<String> list = new ArrayList<>();
        
        if (year == null || month == null) {
            return list;
        }

        PreparedStatement localPstmt = null;
        ResultSet localRs = null;

        try {
            String sql = 
                "SELECT DISTINCT DATE_FORMAT(appt_date, '%Y-%m-%d') AS appt_day " +
                "FROM appointment " +
                "WHERE YEAR(appt_date) = ? AND MONTH(appt_date) = ? AND state != '취소' " +
                "ORDER BY appt_day";

            localPstmt = conn.prepareStatement(sql);
            localPstmt.setInt(1, Integer.parseInt(year));
            localPstmt.setInt(2, Integer.parseInt(month));
            localRs = localPstmt.executeQuery();

            while (localRs.next()) {
                list.add(localRs.getString("appt_day"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 다 쓴 자원은 안전하게 닫아줍니다.
            if (localRs != null) try { localRs.close(); } catch(Exception ignore){}
            if (localPstmt != null) try { localPstmt.close(); } catch(Exception ignore){}
        }
        
        return list;
    }
    /**
     * 신규 예약 등록 (Insert)
     */
    public boolean insertAppointment(String id, String patientId, String employeeId, String deptId, 
                                     String apptDate, String apptTime, String apptType, String memo) {
        boolean result = false;
        PreparedStatement localPstmt = null;
        
        try {
            // DB 테이블 구조에 맞게 INSERT 문 작성 (초기 state는 '예약'으로 고정)
            String sql = "INSERT INTO appointment (id, patient_id, employee_id, dept_id, appt_date, appt_time, appt_type, state, memo) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, '예약', ?)";
            
            localPstmt = conn.prepareStatement(sql);
            localPstmt.setString(1, id);
            localPstmt.setString(2, patientId);
            
            // 담당 의사나 진료과를 선택하지 않고 비워뒀을 경우 null 처리
            localPstmt.setString(3, (employeeId == null || employeeId.trim().isEmpty()) ? null : employeeId);
            localPstmt.setString(4, (deptId == null || deptId.trim().isEmpty()) ? null : deptId);
            
            localPstmt.setString(5, apptDate);
            localPstmt.setString(6, apptTime);
            localPstmt.setString(7, apptType);
            localPstmt.setString(8, memo);

            int count = localPstmt.executeUpdate();
            if (count > 0) {
                result = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (localPstmt != null) try { localPstmt.close(); } catch(Exception ignore){}
        }
        
        return result;
    }
    /**
     * 특정 환자의 과거 예약 기록 조회 (최신순)
     */
    public List<AppointmentBean> getAppointmentsByPatient(String patientId) {
        List<AppointmentBean> list = new ArrayList<>();
        if (patientId == null || patientId.trim().isEmpty()) return list;

        PreparedStatement localPstmt = null;
        ResultSet localRs = null;

        try {
            String sql = 
                "SELECT a.id AS appt_id, a.patient_id, " +
                "       a.appt_date, a.appt_time, d.name AS dept_name, e.name AS doctor_name, " +
                "       a.appt_type, a.state, a.memo " +
                "FROM appointment a " +
                "LEFT JOIN employee e ON a.employee_id = e.id " +
                "LEFT JOIN dept d ON a.dept_id = d.id " +
                "WHERE a.patient_id = ? " +
                "ORDER BY a.appt_date DESC, a.appt_time DESC";

            localPstmt = conn.prepareStatement(sql);
            localPstmt.setString(1, patientId);
            localRs = localPstmt.executeQuery();

            while (localRs.next()) {
                AppointmentBean ab = new AppointmentBean();
                ab.setApptId(nvl(localRs.getString("appt_id")));
                ab.setPatientId(nvl(localRs.getString("patient_id")));
                ab.setTime(nvl(localRs.getString("appt_date")) + " " + nvl(localRs.getString("appt_time"))); // 날짜+시간 합치기
                ab.setDept(nvl(localRs.getString("dept_name")));
                ab.setDoctor(nvl(localRs.getString("doctor_name")));
                ab.setType(nvl(localRs.getString("appt_type")));
                ab.setState(nvl(localRs.getString("state")));
                ab.setMemo(nvl(localRs.getString("memo")));
                list.add(ab);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (localRs != null) try { localRs.close(); } catch(Exception ignore){}
            if (localPstmt != null) try { localPstmt.close(); } catch(Exception ignore){}
        }
        return list;
    }
    // Null 방지용 유틸 메서드
    private String nvl(String s) {
        return s != null ? s : "";
    }
}
