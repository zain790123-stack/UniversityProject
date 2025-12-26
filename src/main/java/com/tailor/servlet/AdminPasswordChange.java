package com.tailor.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/AdminPasswordChangeServlet")
public class AdminPasswordChange extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        HttpSession session = req.getSession();
        Integer adminId = (Integer) session.getAttribute("adminId");

        String newPass = req.getParameter("newPassword");
        String confirmPass = req.getParameter("confirmPassword");

        if (adminId == null) {
            session.setAttribute("errorMsg", "Session expired! Please login again.");
            resp.sendRedirect("unifiedLogin.jsp");
            return;
        }

        if (newPass == null || newPass.trim().isEmpty() ||
            confirmPass == null || confirmPass.trim().isEmpty()) {
            session.setAttribute("errorMsg", "All fields are required!");
            resp.sendRedirect("adminPasswordChange.jsp");
            return;
        }

        if (!newPass.equals(confirmPass)) {
            session.setAttribute("errorMsg", "New passwords do not match!");
            resp.sendRedirect("adminPasswordChange.jsp");
            return;
        }

        if (newPass.length() < 6) {
            session.setAttribute("errorMsg", "Password must be at least 6 characters!");
            resp.sendRedirect("adminPasswordChange.jsp");
            return;
        }

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/tailor_db", "root", "12345")) {

            String hashedNew = BCrypt.hashpw(newPass, BCrypt.gensalt(12));
            
            String updateSql = "UPDATE admin_users SET password=? WHERE id=?";
            PreparedStatement updatePs = con.prepareStatement(updateSql);
            updatePs.setString(1, hashedNew);
            updatePs.setInt(2, adminId);

            int updated = updatePs.executeUpdate();
            if (updated > 0) {
                session.setAttribute("successMsg", "Password changed successfully!");
            } else {
                session.setAttribute("errorMsg", "Admin account not found!");
            }

            resp.sendRedirect("adminPasswordChange.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database error: " + e.getMessage());
            resp.sendRedirect("adminPasswordChange.jsp");
        }
    }
}