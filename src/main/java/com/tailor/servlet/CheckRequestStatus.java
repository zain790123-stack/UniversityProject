package com.tailor.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/checkUnifiedStatus")
public class CheckRequestStatus extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String[][] DB_QUERY_MAP = {
        {"tailor_shop", "SELECT status FROM orders WHERE order_id = ?"},
        {"tailor_db", "SELECT status FROM suit_requests WHERE request_id = ?"},
        {"tailor_db", "SELECT status FROM alteration_requests WHERE request_id = ?"}
    };

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestId = request.getParameter("requestId");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (requestId == null || requestId.trim().isEmpty()) {
            out.print("{\"error\": \"Request ID is required.\"}");
            return;
        }

        try {
           
            Class.forName("com.mysql.cj.jdbc.Driver");

            String status = fetchStatus(requestId);
            if (status != null) {
                out.print("{\"status\": \"" + status + "\"}");
            } else {
                out.print("{\"error\": \"No request found with the provided ID.\"}");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.print("{\"error\": \"MySQL JDBC Driver not found.\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("{\"error\": \"Database error occurred: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"Unexpected error: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    private String fetchStatus(String requestId) throws SQLException {
        for (String[] entry : DB_QUERY_MAP) {
            String db = entry[0];
            String query = entry[1];

            String url = "jdbc:mysql://localhost:3306/" + db + "?useSSL=false&allowPublicKeyRetrieval=true";
            try (Connection conn = DriverManager.getConnection(url, "root", "12345");
                 PreparedStatement stmt = conn.prepareStatement(query)) {

                stmt.setString(1, requestId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getString("status");
                    }
                }
            }
        }
        return null;
    }
}
