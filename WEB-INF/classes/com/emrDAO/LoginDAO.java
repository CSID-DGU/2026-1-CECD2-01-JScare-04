package com.emrDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.emrBean.*;


public class LoginDAO {
	private static LoginDAO instance;
	private LoginDAO(){}
	//싱글톤 패턴
	public static LoginDAO getInstance(){
	if(instance == null ) instance = new LoginDAO();
	return instance;
	}
	
	
	
	public String isMember(LoginBean bean) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        String isMemberFlag = "null";  //문자열 null
        String ID=bean.getId(); 
        String PW=bean.getPw();
        String dbID, dbPW;
        
        try {
            conn = DbConfig.getConnection();

            // 쿼리 - 회원의 아이디와 비번이 매치하는지 확인
            String query = "select * from employee";
            stmt=conn.createStatement();
            rs=stmt.executeQuery(query);
          
            while(rs.next()) {
            	dbID=rs.getString("id");
            	dbPW=rs.getString("password");
            	
            	if(ID.equals(dbID) && PW.equals(dbPW)) {
            		isMemberFlag=rs.getString("name");  //이름 저장
            		break;
            	}
            	
            	/*
            	if(ID.equals(dbID)) { //일단 회원이 맞는지 확인 (아이디가 존재하는지)
            		if(PW.equals(dbPW)) {  //비밀번호까지 일치하면
            			isMemberFlag=rs.getString("name");  //이름 저장
                		break;
            		}
            		else {  //비번이 틀리면 비밀번호가 틀리다고
            			isMemberFlag="pwError";
            			break;
            		}
            	}
            	*/
            }
            
            return isMemberFlag;

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
    } //isMember 메소드 종료
	
	
	
}

