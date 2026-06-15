package com.emrDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.emrBean.*;

public class MemberDAO {

    // 기본 생성자
    public MemberDAO() {}

    // 회원가입 메서드
    public void joinMember(MemberBean bean) {
        Connection conn = null;
        PreparedStatement pstm = null;

        try {
            conn = DbConfig.getConnection();
            conn.setAutoCommit(false);

            // user_id와 진료과를 포함한 명시적 INSERT
            String query = "INSERT INTO employee (id, password, name, dept_id, role, email, phone) VALUES (?, ?, ?, ?, ?, ?, ?)";

            pstm = conn.prepareStatement(query);
            pstm.setString(1, bean.getId());
            pstm.setString(2, bean.getPw());
            pstm.setString(3, bean.getName());
            pstm.setString(4, bean.getDeptId());
            pstm.setString(5, "DOCTOR");
            pstm.setString(6, bean.getEmail());
            pstm.setString(7, bean.getPhone());

            pstm.executeUpdate();
            conn.commit();
            System.out.println("✅ 회원가입 성공");

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        } finally {
            try {
                if (pstm != null) pstm.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                throw new RuntimeException(e.getMessage());
            }
        }
    }

    public boolean isIDExists(MemberBean bean) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        boolean exists = false;
        String ID=bean.getId(); 
        String dbID;
        
        try {
            conn = DbConfig.getConnection();

            // 쿼리 - 아이디가 이미 존재하는지 확인
            String query = "select * from employee";
            stmt=conn.createStatement();
            rs=stmt.executeQuery(query);
          
            while(rs.next()) {
            	dbID=rs.getString("id");
            	if(ID.equals(dbID)) {
            		exists=true;
            		break;
            	}
            }
            
            return exists;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                throw new RuntimeException(e.getMessage());
            }
        }

        
    }
	//디비에서 특정 회원의 정보를 가져와 Bean에 저장하는 함수
    public MemberBean getMember(String strId) {
    	Connection conn = null;
        Statement stmt = null;
        PreparedStatement pstmt=null;
        ResultSet rs = null;
              
        String dbNAME, dbID, dbPW, dbEMAIL, dbPHONE;
        MemberBean memberbean=new MemberBean();
        
        try {
            conn = DbConfig.getConnection();

            // 쿼리 - 회원의 아이디와 비번이 매치하는지 확인
            
            //String query = "select * from member where id='" + strId + "'";
           // stmt=conn.createStatement();
           // rs=stmt.executeQuery(query);
           
            
            String query = "SELECT * FROM employee WHERE id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, strId); // ?에 strId 값을 바인딩
            rs = pstmt.executeQuery();
          
            while(rs.next()) {
            	dbNAME=rs.getString("name");
            	dbID=rs.getString("id");
            	dbPW=rs.getString("pw");
            	dbEMAIL=rs.getString("email");
            	dbPHONE=rs.getString("phone");
            	
            	memberbean.setName(dbNAME);
                memberbean.setId(dbID);
                memberbean.setPw(dbPW);
                memberbean.setEmail(dbEMAIL);
                memberbean.setPhone(dbPHONE);
            }
            
            
            
            return memberbean;

        } 
        catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        } 
        finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                throw new RuntimeException(e.getMessage());
            }
        }
    }
}


