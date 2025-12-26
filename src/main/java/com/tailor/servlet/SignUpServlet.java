package com.tailor.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import java.sql.*;

@WebServlet("/SignUpServlet")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String DB_URL = "jdbc:mysql://localhost:3306/tailor_db";
    private final String DB_USER = "root";
    private final String DB_PASSWORD = "12345";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String email = request.getParameter("email").trim();

        String validationError = validateInputs(username, email, password);
        if (validationError != null) {
            request.setAttribute("message", validationError);
            request.setAttribute("messageType", "error");
            RequestDispatcher dispatcher = request.getRequestDispatcher("signup.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                if (isEmailExists(conn, email)) {
                    request.setAttribute("message", "Email already exists!");
                    request.setAttribute("messageType", "error");
                }
               
                else if (isUsernameExists(conn, username)) {
                    request.setAttribute("message", "Username is already taken!");
                    request.setAttribute("messageType", "error");
                }
                else {
                    
                    String insertQuery = "INSERT INTO signup_login (username, email, password) VALUES (?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setString(1, username);
                    insertStmt.setString(2, email);
                    insertStmt.setString(3, password);

                    int rows = insertStmt.executeUpdate();

                    if (rows > 0) {
                        request.setAttribute("message", "Registration successful! Please log in.");
                        request.setAttribute("messageType", "success");
                    } else {
                        request.setAttribute("message", "Registration failed. Try again.");
                        request.setAttribute("messageType", "error");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Internal server error: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("signup.jsp");
        dispatcher.forward(request, response);
    }

    private String validateInputs(String username, String email, String password) {

        String usernameRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z0-9]{4,12}$";
        if (!username.matches(usernameRegex)) {
            return "Username must be 4–12 chars, alphanumeric, and contain both letters & numbers.";
        }

        String emailRegex =
                "^(?=[A-Za-z0-9]*[A-Za-z])(?=[A-Za-z0-9]*\\d)[A-Za-z0-9]+@[A-Za-z]+\\.[A-Za-z]{2,}$";

        if (!email.matches(emailRegex)) {
            return "Email must contain letters & numbers, no special characters allowed.";
        }

        String passwordRegex =
                "^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[@#$%^&+=!]).{8,}$";

        if (!password.matches(passwordRegex)) {
            return "Password must be 8+ chars & include uppercase, lowercase, number, and special character.";
        }

        return null;
    }

    private boolean isEmailExists(Connection conn, String email) throws SQLException {
        String[] tables = {"signup_login", "admin_users", "tailors"};

        for (String table : tables) {
            String query = "SELECT email FROM " + table + " WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return true;
        }
        return false;
    }

    private boolean isUsernameExists(Connection conn, String username) throws SQLException {
        String query = "SELECT id FROM signup_login WHERE username = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        return rs.next();
    }
}
