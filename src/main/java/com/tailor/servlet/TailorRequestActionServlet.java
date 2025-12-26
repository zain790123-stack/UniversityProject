package com.tailor.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/TailorActionServlet")
public class TailorRequestActionServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/tailor_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "12345";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        String idParam = request.getParameter("id");
        String action = request.getParameter("action");
        String table = request.getParameter("table");
        
        if (idParam == null || idParam.trim().isEmpty() || 
            action == null || action.trim().isEmpty() ||
            table == null || table.trim().isEmpty()) {
            response.getWriter().write("invalid");
            return;
        }
        
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.getWriter().write("invalid");
            return;
        }
        
        if (!table.equals("suit_requests") && !table.equals("alteration_requests")) {
            response.getWriter().write("invalid_table");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
        
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            String tailorName = (String) request.getSession().getAttribute("tailorName");
            if (tailorName == null) {
                response.getWriter().write("session_expired");
                return;
            }
            
            String checkSql = "SELECT id FROM " + table + " WHERE id=? AND tailor_name=?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, id);
            pstmt.setString(2, tailorName);
            ResultSet rs = pstmt.executeQuery();
            
            if (!rs.next()) {
                response.getWriter().write("notfound");
                return;
            }
            rs.close();
            pstmt.close();
            
            String sql = "";
            switch (action) {
                case "approve":
                case "reject":
                case "hold":
                case "complete":
                    sql = "UPDATE " + table + " SET status=?, approval_date=NOW() WHERE id=?";
                    break;
                case "reset":
                    sql = "UPDATE " + table + " SET status='pending', approval_date=NULL WHERE id=?";
                    break;
                case "delete":
                    sql = "DELETE FROM " + table + " WHERE id=?";
                    break;
                default:
                    response.getWriter().write("invalid_action");
                    return;
            }
            
            pstmt = conn.prepareStatement(sql);
            
            if (action.equals("delete") || action.equals("reset")) {
                pstmt.setInt(1, id);
            } else {
                pstmt.setString(1, action);
                pstmt.setInt(2, id);
            }
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                
                String successMsg = "";
                switch (action) {
                    case "approve": successMsg = "Request approved successfully"; break;
                    case "reject": successMsg = "Request rejected successfully"; break;
                    case "hold": successMsg = "Request put on hold"; break;
                    case "complete": successMsg = "Request marked as completed"; break;
                    case "reset": successMsg = "Request status reset to pending"; break;
                    case "delete": successMsg = "Request deleted successfully"; break;
                }
                request.getSession().setAttribute("successMsg", successMsg);
                response.getWriter().write("success");
            } else {
                response.getWriter().write("failed");
            }
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().write("driver_error");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("database_error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        } finally {
           
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}