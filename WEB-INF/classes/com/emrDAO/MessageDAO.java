package com.emrDAO;

import java.sql.*;
import java.util.*;
import com.emrBean.MessageBean;

public class MessageDAO {
    private Connection conn;
    private PreparedStatement pstmt;

    private static MessageDAO instance = new MessageDAO();
    public static MessageDAO getInstance() { return instance; }

    private MessageDAO() {
        try {
            conn = DbConfig.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // [메시지 저장 메서드]
    // who: "USER"이면 사용자가 보낸 것, "BOT"이면 AI가 보낸 것
    public void insertChatLog(String userId, String text, String who) {
        // id는 varchar(10)이므로 UUID 8자리 사용
        String newId = UUID.randomUUID().toString().substring(0, 8);
        
        String sql = "INSERT INTO message (id, sender, receiver, content, state, employee_id, entry_date) VALUES (?, ?, ?, ?, '1', ?, NOW())";
        
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newId);

            if ("USER".equals(who)) {
                // 사용자가 말함 -> 보낸이: 나, 받는이: AI
                pstmt.setString(2, userId); 
                pstmt.setString(3, "AI_BOT"); 
            } else {
                // 봇이 말함 -> 보낸이: AI, 받는이: 나
                pstmt.setString(2, "AI_BOT"); 
                pstmt.setString(3, userId); 
            }

            pstmt.setString(4, text);       // 내용
            pstmt.setString(5, userId);     // employee_id (누구의 채팅방인지 식별용)
            
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
