package com.tailor.servlet;

import java.io.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.security.MessageDigest;
import java.sql.*;
import java.util.Base64;
import java.util.Random;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/RecoverServlet")
public class PasswordForgetLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        String dbUrl = "jdbc:mysql://localhost:3306/tailor_db";
        String dbUser = "root";
        String dbPass = "12345";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            if ("send_otp".equals(action)) {
                String email = request.getParameter("email");
                
                String userTable = findUserTable(conn, email);
                
                if (userTable == null) {
                    request.setAttribute("error", "Email not found.");
                    request.setAttribute("step", "email");
                } else {
                    String otp = generateOtp();
                    session.setAttribute("otp", otp);
                    session.setAttribute("email", email);
                    session.setAttribute("userTable", userTable);

                    System.out.println("OTP sent to " + email + ": " + otp);
                    request.setAttribute("step", "otp");
                    request.setAttribute("message", "OTP sent to your email.");
                }

            } else if ("verify_otp".equals(action)) {
                String userOtp = request.getParameter("otp");
                String sessionOtp = (String) session.getAttribute("otp");

                if (userOtp != null && userOtp.equals(sessionOtp)) {
                    request.setAttribute("step", "reset");
                    request.setAttribute("message", "OTP verified. You can now reset your password.");
                } else {
                    request.setAttribute("error", "Invalid OTP.");
                    request.setAttribute("step", "otp");
                }

            } else if ("reset_password".equals(action)) {
                String password = request.getParameter("password");
    
                String email = (String) session.getAttribute("email");
                String userTable = (String) session.getAttribute("userTable");

                if (password == null || password.trim().isEmpty()) {
                    request.setAttribute("error", "Password cannot be empty.");
                    request.setAttribute("step", "reset");
                
                } else if (email != null && userTable != null) {

                    String hashedPassword = hashPasswordBasedOnTable(password, userTable);
                    
                    PreparedStatement ps = conn.prepareStatement("UPDATE " + userTable + " SET password=? WHERE email=?");
                    ps.setString(1, hashedPassword);
                    ps.setString(2, email);
                    int rows = ps.executeUpdate();
                    ps.close();

                    if (rows > 0) {
                        session.invalidate();
                        HttpSession newSession = request.getSession(true);
                        newSession.setAttribute("successMessage", "Password reset successful! Please login with your new password.");
                        response.sendRedirect(request.getContextPath() + "/unifiedLogin.jsp?message=reset_success");
                        conn.close();
                        return;
                    } else {
                        request.setAttribute("error", "Failed to reset password.");
                        request.setAttribute("step", "reset");
                    }
                } else {
                    request.setAttribute("error", "Session expired or invalid state.");
                    request.setAttribute("step", "email");
                }
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong.");
            request.setAttribute("step", "email");
        }

        RequestDispatcher rd = request.getRequestDispatcher("ForgotUnified.jsp");
        rd.forward(request, response);
    }

    private String findUserTable(Connection conn, String email) throws SQLException {
        String[] tables = { "admin_users", "signup_login", "tailors", "managers" };
        
        for (String table : tables) {
            PreparedStatement ps = conn.prepareStatement("SELECT email FROM " + table + " WHERE email=?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                rs.close();
                ps.close();
                return table;
            }
            rs.close();
            ps.close();
        }
        return null;
    }

    private String generateOtp() {
        return String.valueOf(new Random().nextInt(900000) + 100000);
    }

    private String hashPasswordBasedOnTable(String password, String userTable) {
        switch (userTable) {
            case "admin_users":
                
                return BCrypt.hashpw(password, BCrypt.gensalt());
                
            case "tailors":
                
                return hashWithSHA256(password);
                
            case "signup_login":
            case "managers":
                
                return password;
                
            default:
                return password;
        }
    }
    
    private String hashWithSHA256(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes("UTF-8"));
            return Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}