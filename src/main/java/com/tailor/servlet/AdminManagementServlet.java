package com.tailor.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;
import java.io.IOException;
import java.sql.*;
import com.tailor.Util.DBUtil;

@WebServlet("/AdminManagementServlet")
public class AdminManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        
        HttpSession session = req.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");
        String adminEmail = (String) session.getAttribute("adminEmail");
        
        if (adminId == null || adminEmail == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Session expired. Please login again.");
            res.getWriter().write(error.toString());
            return;
        }
        
        String action = req.getParameter("action");
        
        if (action == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Action parameter is required");
            res.getWriter().write(error.toString());
            return;
        }
        
        JSONObject responseJson = new JSONObject();
        Connection con = null;
        
        try {
            con = DBUtil.getConnection(); 
            
            switch (action) {
                case "updateAdmin":
                    responseJson = updateAdminProfile(con, req, adminId);
                    break;
                case "updateAdminKey":
                    responseJson = updateAdminKey(con, req, adminId);
                    break;
                default:
                    responseJson.put("success", false);
                    responseJson.put("message", "Invalid action: " + action);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            responseJson.put("success", false);
            responseJson.put("message", "Database error: " + e.getMessage());
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        
        res.getWriter().write(responseJson.toString());
    }
    
    private JSONObject updateAdminProfile(Connection con, HttpServletRequest req, Integer adminId) throws SQLException {
        String id = req.getParameter("id");
        String name = req.getParameter("name");
        String adminKey = req.getParameter("adminKey");
        
        if (!id.equals(adminId.toString())) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Unauthorized: You can only update your own profile");
            return error;
        }
        
        JSONObject result = new JSONObject();
        
        boolean hasUpdates = false;
        StringBuilder sqlBuilder = new StringBuilder("UPDATE admin_users SET ");
        java.util.List<Object> params = new java.util.ArrayList<>();
        
        if (name != null && !name.trim().isEmpty()) {
            sqlBuilder.append("name = ?, ");
            params.add(name.trim());
            hasUpdates = true;
        }
         
        if (adminKey != null && !adminKey.trim().isEmpty()) {
            sqlBuilder.append("admin_key = ?, ");
            params.add(adminKey.trim());
            hasUpdates = true;
        }
        
        if (!hasUpdates) {
            result.put("success", false);
            result.put("message", "No changes provided");
            return result;
        }
        
        sqlBuilder.delete(sqlBuilder.length() - 2, sqlBuilder.length());
        sqlBuilder.append(" WHERE id = ?");
        params.add(Integer.parseInt(id));
        
        String sql = sqlBuilder.toString();
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                
                if (name != null && !name.trim().isEmpty()) {
                    HttpSession session = req.getSession();
                    session.setAttribute("adminName", name.trim());
                }
                
                result.put("success", true);
                result.put("message", "Profile updated successfully");
            } else {
                result.put("success", false);
                result.put("message", "Admin not found or no changes made");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Database error: " + e.getMessage());
        }
        
        return result;
    }
    
    private JSONObject updateAdminKey(Connection con, HttpServletRequest req, Integer adminId) throws SQLException {
        String id = req.getParameter("id");
        String adminKey = req.getParameter("adminKey");
        
        if (!id.equals(adminId.toString())) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Unauthorized: You can only update your own profile");
            return error;
        }
        
        if (adminKey == null || adminKey.trim().isEmpty()) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Admin key is required");
            return error;
        }
        
        JSONObject result = new JSONObject();
        
            String updateSql = "UPDATE admin_users SET admin_key = ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setString(1, adminKey.trim());
                ps.setInt(2, Integer.parseInt(id));
                
                int rows = ps.executeUpdate();
                
                if (rows > 0) {
                    result.put("success", true);
                    result.put("message", "Admin key updated successfully");
                } else {
                    result.put("success", false);
                    result.put("message", "Failed to update admin key");
                }
            }
        
        return result;
    }
    
}