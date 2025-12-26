package com.tailor.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;

@WebServlet("/AdminDashboardServlet")
public class AdminActionServlet extends HttpServlet { 
	 private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        
        HttpSession session = req.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");
        
        if (adminId == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Session expired. Please login again.");
            res.getWriter().write(error.toString());
            return;
        }
        
        String action = req.getParameter("action");
        
        System.out.println("DEBUG: Action parameter received: " + action);
        
        if (action == null || action.trim().isEmpty()) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Action parameter is required and cannot be empty");
            res.getWriter().write(error.toString());
            return;
        }
        
        JSONObject responseJson = new JSONObject();
        
        String database = req.getParameter("database");
        if (database == null) database = "tailor_db";
        
        Connection con = null;
        try {
            con = getConnection(database);
            
            switch (action) {
                case "updateStatus":
                    responseJson = updateRecordStatus(con, req);
                    break;
                case "delete":
                    responseJson = deleteRecord(con, req);
                    break;
                case "deleteAll":
                    responseJson = deleteAllRecords(con, req);
                    break;
                case "resetStatus":
                    responseJson = resetStatus(con, req);
                    break;
                case "updateTailor":
                    responseJson = updateTailor(con, req);
                    break;
                case "updateUser":
                    responseJson = updateUser(con, req);
                    break;
                case "viewDetails":
                    responseJson = viewDetails(con, req);
                    break;
                case "testAction":
                    responseJson = testAction(req);
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
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
       
        JSONObject error = new JSONObject();
        error.put("success", false);
        error.put("message", "Use POST method for this endpoint");
        res.setContentType("application/json");
        res.getWriter().write(error.toString());
    }
    
    private Connection getConnection(String database) throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/" + database;
        return DriverManager.getConnection(url, "root", "12345");
    }
    
    private JSONObject updateRecordStatus(Connection con, HttpServletRequest req) throws SQLException {
        String table = req.getParameter("table");
        String id = req.getParameter("id");
        String status = req.getParameter("status");
        
        System.out.println("DEBUG: updateRecordStatus - table: " + table + ", id: " + id + ", status: " + status);
        
        if (table == null || id == null || status == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Missing parameters: table, id, and status are required");
            return error;
        }
        
        if (!isValidTable(table)) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Invalid table name: " + table);
            return error;
        }
        
        String sql = "";
        Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        
        if (table.equals("tailors")) {
            sql = "UPDATE tailors SET status = ?, approval_time = ? WHERE id = ?";
        } else if (table.equals("orders") || table.equals("suit_requests") || table.equals("alteration_requests")) {
            sql = "UPDATE " + table + " SET status = ?, approval_date = ? WHERE id = ?";
        } else {
            sql = "UPDATE " + table + " SET status = ? WHERE id = ?";
        }
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            if (table.equals("tailors")) {
                ps.setString(1, status);
                ps.setTimestamp(2, currentTime);
                ps.setInt(3, Integer.parseInt(id));
            } else if (table.equals("orders") || table.equals("suit_requests") || table.equals("alteration_requests")) {
                ps.setString(1, status);
                ps.setTimestamp(2, currentTime);
                ps.setInt(3, Integer.parseInt(id));
            } else {
                ps.setString(1, status);
                ps.setInt(2, Integer.parseInt(id));
            }
            
            int rows = ps.executeUpdate();
            
            JSONObject result = new JSONObject();
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "Status updated to " + status + " successfully");
            } else {
                result.put("success", false);
                result.put("message", "Record not found or no changes made");
            }
            return result;
        }
    }
    
    private JSONObject deleteRecord(Connection con, HttpServletRequest req) throws SQLException {
        String table = req.getParameter("table");
        String id = req.getParameter("id");
        
        if (table == null || id == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Missing parameters: table and id are required");
            return error;
        }
        
        if (!isValidTable(table)) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Invalid table name: " + table);
            return error;
        }
        
        String sql = "DELETE FROM " + table + " WHERE id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            
            int rows = ps.executeUpdate();
            
            JSONObject result = new JSONObject();
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "Record deleted successfully");
            } else {
                result.put("success", false);
                result.put("message", "Record not found");
            }
            return result;
        }
    }
    
    @SuppressWarnings("unused")
	private JSONObject deleteAllRecords(Connection con, HttpServletRequest req) throws SQLException {
        String table = req.getParameter("table");
        
        if (table == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Missing parameter: table is required");
            return error;
        }
        
        if (!isValidTable(table)) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Invalid table name: " + table);
            return error;
        }
        
        JSONObject result = new JSONObject();
        
        try {
           
            String countSql = "SELECT COUNT(*) as count FROM " + table;
            int recordCount = 0;
            
            try (PreparedStatement countPs = con.prepareStatement(countSql);
                 ResultSet rs = countPs.executeQuery()) {
                if (rs.next()) {
                    recordCount = rs.getInt("count");
                }
            }
            
            String truncateSql = "TRUNCATE TABLE " + table;
            
            try (PreparedStatement ps = con.prepareStatement(truncateSql)) {
                int rows = ps.executeUpdate();
                
                result.put("success", true);
                result.put("message", rows + " records deleted  from " + table);
                result.put("deletedCount", rows);
                result.put("table", table);
                
                System.out.println("DEBUG: Deleted " + rows + " records from " + table);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "SQL Error: " + e.getMessage());
        }
        
        return result;
    }
    
    private JSONObject resetStatus(Connection con, HttpServletRequest req) throws SQLException {
        String table = req.getParameter("table");
        String id = req.getParameter("id");
        
        if (table == null || id == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Missing parameters: table and id are required");
            return error;
        }
        
        if (!isValidTable(table)) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Invalid table name: " + table);
            return error;
        }
        
        String sql = "";
        
        if (table.equals("tailors")) {
            sql = "UPDATE tailors SET status = 'processing', approval_time = NULL WHERE id = ?";
            
        } else if (table.equals("orders")) {
                sql = "UPDATE orders SET status = 'pending', approval_date = NULL WHERE id = ?";
                
        } else if ( table.equals("suit_requests") || table.equals("alteration_requests")) {
            sql = "UPDATE " + table + " SET status = 'processing', approval_date = NOW() WHERE id = ?";
            
        } else {
            sql = "UPDATE " + table + " SET status = 'pending' WHERE id = ?";
        }
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            
            int rows = ps.executeUpdate();
            
            JSONObject result = new JSONObject();
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "Status reset to pending");
            } else {
                result.put("success", false);
                result.put("message", "Record not found");
            }
            return result;
        }
    }
    
    private JSONObject updateTailor(Connection con, HttpServletRequest req) throws SQLException {
        String id = req.getParameter("id");
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String specialty = req.getParameter("specialty");
        String experience = req.getParameter("experience");
        String status = req.getParameter("status");
        String address = req.getParameter("address");
        
        if (id == null || name == null || phone == null || email == null || 
            specialty == null || experience == null || status == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Missing required parameters for tailor update");
            return error;
        }
        
        JSONObject result = new JSONObject();
        
        String currentStatus = "";
        String checkSql = "SELECT status FROM tailors WHERE id = ?";
        try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
            checkPs.setInt(1, Integer.parseInt(id));
            ResultSet rs = checkPs.executeQuery();
            if (rs.next()) {
                currentStatus = rs.getString("status");
            }
        }
        
        String sql = "UPDATE tailors SET name = ?, phone = ?, email = ?, specialty = ?, " +
                    "experience = ?, status = ?, address = ?";
        
        if (!currentStatus.equals("approved") && status.equals("approved")) {
            sql += ", approval_time = NOW()";
        }
        
        sql += " WHERE id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, specialty);
            ps.setInt(5, Integer.parseInt(experience));
            ps.setString(6, status);
            ps.setString(7, address != null ? address : "");
            ps.setInt(8, Integer.parseInt(id));
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "Tailor details updated successfully");
            } else {
                result.put("success", false);
                result.put("message", "Tailor not found");
            }
        }
        
        return result;
    }
    
    private JSONObject updateUser(Connection con, HttpServletRequest req) throws SQLException {
        String id = req.getParameter("id");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        if (id == null || username == null || email == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Missing required parameters for user update");
            return error;
        }
        
        JSONObject result = new JSONObject();
        
        String sql;
        PreparedStatement ps;
        
        if (password != null && !password.isEmpty()) {
            sql = "UPDATE signup_login SET username = ?, email = ?, password = ? WHERE id = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setInt(4, Integer.parseInt(id));
        } else {
            sql = "UPDATE signup_login SET username = ?, email = ? WHERE id = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setInt(3, Integer.parseInt(id));
        }
        
        int rows = ps.executeUpdate();
        ps.close();
        
        if (rows > 0) {
            result.put("success", true);
            result.put("message", "User details updated successfully");
        } else {
            result.put("success", false);
            result.put("message", "User not found");
        }
        
        return result;
    }
    
    private JSONObject viewDetails(Connection con, HttpServletRequest req) throws SQLException {
        String table = req.getParameter("table");
        String id = req.getParameter("id");
        String database = req.getParameter("database");
        
        if (table == null || id == null) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("message", "Missing parameters: table and id are required");
            return error;
        }
        
        JSONObject result = new JSONObject();
        
        if (database != null && !database.equals("tailor_db")) {
            try {
                con.close();
                con = getConnection(database);
            } catch (Exception e) {
                result.put("success", false);
                result.put("message", "Database connection error: " + e.getMessage());
                return result;
            }
        }
        
        if (!isValidTable(table)) {
            result.put("success", false);
            result.put("message", "Invalid table name: " + table);
            return result;
        }
        
        String sql = "SELECT * FROM " + table + " WHERE id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                
                JSONObject data = new JSONObject();
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnName(i);
                    Object value = rs.getObject(i);
                    
                    if (value instanceof Timestamp) {
                        value = dateFormat.format((Timestamp) value);
                    } else if (value instanceof java.sql.Date) {
                        value = dateFormat.format(new java.util.Date(((java.sql.Date) value).getTime()));
                    } else if (value == null) {
                        value = "";
                    }
                    
                    data.put(columnName, value.toString());
                }
                
                result.put("success", true);
                result.put("data", data);
                result.put("table", table);
            } else {
                result.put("success", false);
                result.put("message", "Record not found");
            }
        }
        
        return result;
    }
    
    private JSONObject testAction(HttpServletRequest req) {
        JSONObject result = new JSONObject();
        result.put("success", true);
        result.put("message", "Test action successful! Parameters received.");
        result.put("action", req.getParameter("action"));
        result.put("table", req.getParameter("table"));
        result.put("id", req.getParameter("id"));
        result.put("status", req.getParameter("status"));
        result.put("database", req.getParameter("database"));
        return result;
    }
    
    private boolean isValidTable(String table) {
        String[] validTables = {
            "suit_requests", "alteration_requests", "tailors", 
            "orders", "signup_login", "reviews"
        };
        
        for (String valid : validTables) {
            if (valid.equals(table)) {
                return true;
            }
        }
        return false;
    }
}