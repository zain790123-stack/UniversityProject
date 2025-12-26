package com.tailor.servlet;

import com.tailor.Util.PasswordUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/TailorPasswordChange")
public class TailorPasswordChangeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();
        Integer tailorId = (Integer) session.getAttribute("tailorId");
               
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");
        
        if (newPassword == null || confirmPassword == null || 
            newPassword.isEmpty() || confirmPassword.isEmpty()) {
            session.setAttribute("errorMsg", "Password fields cannot be empty!");
            resp.sendRedirect("tailorPasswordChange.jsp");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMsg", "Passwords do not match!");
            resp.sendRedirect("tailorPasswordChange.jsp");
            return;
        }
        
        if (!isValidPassword(newPassword)) {
            session.setAttribute("errorMsg", 
                "Password must contain: 8+ characters, uppercase, lowercase, digit, and special character!");
            resp.sendRedirect("tailorPasswordChange.jsp");
            return;
        }
        
        String hashedPassword = PasswordUtil.hash(newPassword);
        
        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/tailor_db", "root", "12345")) {
            
            String sql = "UPDATE tailors SET password = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setString(1, hashedPassword);
            ps.setInt(2, tailorId);
            
            int updated = ps.executeUpdate();
            if (updated > 0) {
                session.setAttribute("successMsg", "Password changed successfully!");
            } else {
                session.setAttribute("errorMsg", "Failed to update password!");
            }
            
            resp.sendRedirect("tailorAccount.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database error occurred!");
            resp.sendRedirect("tailorPasswordChange.jsp");
        }
    }
    
    private boolean isValidPassword(String password) {
       
        if (password.length() < 8) return false;
        if (!password.matches(".*[A-Z].*")) return false;  
        if (!password.matches(".*[a-z].*")) return false;  
        if (!password.matches(".*[0-9].*")) return false;  
        if (!password.matches(".*[@$!%*?&].*")) return false;  
        return true;
    }
}