package com.tailor.servlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ValidateEmailServlet")
public class ValidateEmailServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	private final String DB_URL = "jdbc:mysql://localhost:3306/tailor_db";
    private final String DB_USER = "root";
    private final String DB_PASSWORD = "12345";

    private final String[] TABLES = {"signup_login", "tailors", "admin_users"};

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        email = (email == null) ? "" : email.trim();

        response.setContentType("text/plain;charset=UTF-8");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                for (String table : TABLES) {
                    String sql = "SELECT 1 FROM " + table + " WHERE email = ? LIMIT 1";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, email);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        response.getWriter().print("exists");
                        return;
                    }
                }

                response.getWriter().print("ok");
            }
        } catch (Exception e) {
            response.getWriter().print("error");
        }
    }
}
