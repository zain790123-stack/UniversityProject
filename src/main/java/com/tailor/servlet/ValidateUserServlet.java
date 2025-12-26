package com.tailor.servlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ValidateUserServlet")
public class ValidateUserServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private final String DB_URL = "jdbc:mysql://localhost:3306/tailor_db";
    private final String DB_USER = "root";
    private final String DB_PASSWORD = "12345";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String username = request.getParameter("username");
        username = (username == null) ? "" : username.trim();

        response.setContentType("text/plain;charset=UTF-8");

        try {
            
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                String sql = "SELECT 1 FROM signup_login WHERE username = ? LIMIT 1";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    response.getWriter().print("exists");
                } else {
                    response.getWriter().print("ok");
                }
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.getWriter().print("error");
        }
    }
}
