package com.emrDAO;

import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import com.emrBean.WaitingBean; // WaitingBean 재사용 가능하면 사용하거나 별도 Bean 생성
import com.emrBean.PatientBean;
public class PatientDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static PatientDAO instance = new PatientDAO();
    public static PatientDAO getInstance() { return instance; }

    private PatientDAO() {
        try {
            conn = DbConfig.getConnection();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public String generatePatientId() {
        String prefix = "P" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMM"));
        String sql = "SELECT MAX(id) FROM patient WHERE id LIKE ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, prefix + "%");
            rs = pstmt.executeQuery();

            int nextSeq = 1;
            if (rs.next()) {
                String lastId = rs.getString(1);
                if (lastId != null && lastId.length() == 10) {
                    nextSeq = Integer.parseInt(lastId.substring(7)) + 1;
                }
            }

            if (nextSeq > 999) {
                throw new IllegalStateException("이번 달 환자 ID 생성 한도를 초과했습니다.");
            }

            return prefix + String.format("%03d", nextSeq);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }

    // 환자 등록 메서드
    public boolean insertPatient(String id, String name, String gender, String birth, String phone) {
        String sql = "INSERT INTO patient (id, name, gender, birth, phone, reg_date) VALUES (?, ?, ?, ?, ?, NOW())";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, name);
            pstmt.setString(3, gender);
            pstmt.setString(4, birth);
            pstmt.setString(5, phone);
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 이미 존재하는 환자인지 확인 (간단하게 이름과 전화번호로 체크하거나 주민번호 로직 추가 가능)
    // 여기서는 생략하고 무조건 신규 등록으로 가정합니다.
  //기존 PatientDAO 클래스 안에 아래 메서드를 추가하세요.
    public List<PatientBean> searchPatients(String keyword) {
     List<PatientBean> list = new ArrayList<>();
     // 검색어가 없으면 빈 리스트 반환
     if(keyword == null || keyword.trim().isEmpty()) return list;

     try {
         // 이름 또는 ID에 검색어가 포함된 환자 검색 (최대 10명만)
         String sql = "SELECT * FROM patient WHERE name LIKE ? OR id LIKE ? LIMIT 10";
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, "%" + keyword + "%");
         pstmt.setString(2, "%" + keyword + "%");
         rs = pstmt.executeQuery();

         while (rs.next()) {
             PatientBean p = new PatientBean();
             p.setId(rs.getString("id"));
             p.setName(rs.getString("name"));
             p.setBirth(rs.getString("birth"));
             p.setGender(rs.getString("gender"));
             list.add(p);
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return list;
    }
    public PatientBean getPatientById(String id) {
        PatientBean p = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT * FROM patient WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                p = new PatientBean();
                p.setId(rs.getString("id"));
                p.setName(rs.getString("name"));
                p.setGender(rs.getString("gender"));
                p.setBirth(rs.getString("birth"));
                p.setPhone(rs.getString("phone"));
                // 필요한 경우 reg_date 등 추가
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // rs, pstmt close는 생략함 (실제론 finally에서 닫아주세요)
        return p;
    }
    public boolean updatePatient(String id, String name, String phone) {
        try {
            String sql = "UPDATE patient SET name = ?, phone = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, phone);
            pstmt.setString(3, id);
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateVitals(String id, float height, float weight, int bpSystolic, int bpDiastolic,
                                float temp, String hr, String rr, String spo2) {
        try {
            String sql = "UPDATE patient SET height=?, weight=?, bp_systolic=?, bp_diastolic=?, temp=?, hr=?, rr=?, spo2=?, vitals_updated_at=NOW() WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setFloat(1, height);
            pstmt.setFloat(2, weight);
            pstmt.setInt(3, bpSystolic);
            pstmt.setInt(4, bpDiastolic);
            pstmt.setFloat(5, temp);
            pstmt.setString(6, hr);
            pstmt.setString(7, rr);
            pstmt.setString(8, spo2);
            pstmt.setString(9, id);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
