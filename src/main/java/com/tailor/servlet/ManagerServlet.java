package com.tailor.servlet;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.mindrot.jbcrypt.BCrypt;
import org.json.JSONObject;
import java.util.Random;

@WebServlet("/ManagerServlet")
@MultipartConfig
public class ManagerServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/tailor_db",
                "root",
                "12345"
            );
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL driver not found", e);
        }
    }
    
    private String generateAdminKey() {
        Random random = new Random();
        int key = 10000 + random.nextInt(90000); 
        return String.valueOf(key);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        String action = request.getParameter("action");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            
            if ("addAdmin".equals(action)) {
     
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String adminKey = request.getParameter("admin_key");
                
                if (adminKey == null || adminKey.trim().isEmpty()) {
                    adminKey = generateAdminKey();
                }
                
                String checkSql = "SELECT id FROM admin_users WHERE email = ?";
                pstmt = conn.prepareStatement(checkSql);
                pstmt.setString(1, email);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Email already exists");
                    rs.close();
                    pstmt.close();
                    out.print(jsonResponse.toString());
                    return;
                }
                rs.close();
                pstmt.close();
                
                String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));
                
                String sql = "INSERT INTO admin_users (name, email, password, admin_key, created_at) VALUES (?, ?, ?, ?, NOW())";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setString(2, email);
                pstmt.setString(3, hashedPassword);
                pstmt.setString(4, adminKey);
                
                int rowsAffected = pstmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Admin created successfully");
                    jsonResponse.put("admin_key", adminKey);
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Failed to create admin");
                }
                
            } else if ("deleteAdmin".equals(action)) {
               
                int adminId = Integer.parseInt(request.getParameter("admin_id"));
                
                String sql = "DELETE FROM admin_users WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, adminId);
                
                int rowsAffected = pstmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Admin deleted successfully");
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Admin not found");
                }
                
            } else if ("truncateAdmins".equals(action)) {
           
                String sql = "TRUNCATE TABLE admin_users";
                pstmt = conn.prepareStatement(sql);
                pstmt.executeUpdate();
                
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Admin table truncated successfully");
                
            } else if ("updateManager".equals(action)) {
                
                int managerId = Integer.parseInt(request.getParameter("manager_id"));
                String name = request.getParameter("name");
                String password = request.getParameter("password");
                
                if (password != null && !password.trim().isEmpty()) {
                    
                    String sql = "UPDATE managers SET name = ?, password = ? WHERE id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, name);
                    pstmt.setString(2, password);
                    pstmt.setInt(3, managerId);
                } else {
                    
                    String sql = "UPDATE managers SET name = ? WHERE id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, name);
                    pstmt.setInt(2, managerId);
                }
                
                int rowsAffected = pstmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Manager details updated successfully");
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Failed to update manager details");
                }
                
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Invalid action");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Server error: " + e.getMessage());
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }
}