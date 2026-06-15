package com.emrDAO;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import com.emrBean.ReceiptBean;

public class ReceiptDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static ReceiptDAO instance = new ReceiptDAO();
    public static ReceiptDAO getInstance() { return instance; }

    private ReceiptDAO() {
        try {
            conn = DbConfig.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** 미처리 수납 목록 조회 */
    public List<ReceiptBean> getUnprocessedReceipts() {
        List<ReceiptBean> list = new ArrayList<>();
        try {
            String sql = "SELECT r.id AS receipt_id, p.name AS patient_name, r.apply_num, r.card_number " +
                         "FROM receipt r JOIN patient p ON r.patient_id = p.id " +
                         "WHERE r.apply_num IS NULL OR r.apply_num = '' " +
                         "ORDER BY r.id DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ReceiptBean rb = new ReceiptBean();
                rb.setId(rs.getString("receipt_id"));
                rb.setPatientName(rs.getString("patient_name"));
                rb.setApplyNum(rs.getString("apply_num"));
                rb.setCardNumber(rs.getString("card_number"));
                list.add(rb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

