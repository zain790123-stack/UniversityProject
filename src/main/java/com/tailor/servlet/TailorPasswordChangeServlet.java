package com.tailor.servlet;

import com.tailor.Util.PasswordUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/TailorPasswordChange")
public class TailorPasswordChangeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        HttpSession session = req.getSession();
        Integer tailorId = (Integer) session.getAttribute("tailorId");

        if (tailorId == null) {
            session.setAttribute("errorMsg", "Session expired. Please login again.");
            resp.sendRedirect("unifiedLogin.jsp");
            return;
        }

        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Old password is required!");
            resp.sendRedirect("changeTailorPassword.jsp");
            return;
        }

        if (newPassword == null || confirmPassword == null ||
            newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Password fields cannot be empty!");
            resp.sendRedirect("changeTailorPassword.jsp");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMsg", "Passwords do not match!");
            resp.sendRedirect("changeTailorPassword.jsp");
            return;
        }

        if (!isValidPassword(newPassword)) {
            session.setAttribute("errorMsg",
                "Password must contain 8+ chars, uppercase, lowercase, digit, special char!");
            resp.sendRedirect("changeTailorPassword.jsp");
            return;
        }

        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/tailor_db", "root", "12345")) {

            String storedPassword = null;

            PreparedStatement ps = con.prepareStatement(
                "SELECT password FROM tailors WHERE id=?"
            );
            ps.setInt(1, tailorId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                storedPassword = rs.getString("password");
            } else {
                session.setAttribute("errorMsg", "User not found!");
                resp.sendRedirect("changeTailorPassword.jsp");
                return;
            }

            String oldHashed = PasswordUtil.hash(oldPassword);

            if (!oldHashed.equals(storedPassword)) {
                session.setAttribute("errorMsg", "Old password is incorrect!");
                resp.sendRedirect("changeTailorPassword.jsp");
                return;
            }

            String newHashed = PasswordUtil.hash(newPassword);

            if (newHashed.equals(storedPassword)) {
                session.setAttribute("errorMsg", "New password cannot be same as old password!");
                resp.sendRedirect("changeTailorPassword.jsp");
                return;
            }

            PreparedStatement update = con.prepareStatement(
                "UPDATE tailors SET password=? WHERE id=?"
            );
            update.setString(1, newHashed);
            update.setInt(2, tailorId);

            int x = update.executeUpdate();

            if (x > 0) {
                session.setAttribute("tailorSuccessMsg",
                        "Password changed successfully! Please login again.");
                resp.sendRedirect("unifiedLogin.jsp");
            } else {
                session.setAttribute("errorMsg", "Update failed!");
                resp.sendRedirect("changeTailorPassword.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database error occurred!");
            resp.sendRedirect("changeTailorPassword.jsp");
        }
    }

    private boolean isValidPassword(String password) {
        if (password == null) return false;
        if (password.length() < 8) return false;
        if (!password.matches(".*[A-Z].*")) return false;
        if (!password.matches(".*[a-z].*")) return false;
        if (!password.matches(".*[0-9].*")) return false;
        if (!password.matches(".*[@$!%*?&].*")) return false;
        return true;
    }
}