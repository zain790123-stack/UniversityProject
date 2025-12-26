package com.tailor.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import com.tailor.Util.DBUtil;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        HttpSession session = req.getSession();

        if (email == null || password == null || 
            email.isEmpty() || password.isEmpty()) {
            session.setAttribute("error", "Email and password are required");
            res.sendRedirect("unifiedLogin.jsp");
            return;
        }

        try (Connection con = DBUtil.getConnection()) {

            String sql = "SELECT id, name, email, password FROM admin_users WHERE email = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
           
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password");
                
                if (BCrypt.checkpw(password, storedHash)) {
                    
                    session.invalidate();
                    session = req.getSession(true);
                    session.setAttribute("userType", "admin");
                    session.setAttribute("adminId", rs.getInt("id"));
                    session.setAttribute("adminName", rs.getString("name"));
                    session.setAttribute("adminEmail", rs.getString("email"));
                    
                    res.sendRedirect("adminDashboard.jsp");
                    return;
                }
            }
            
            session.setAttribute("error", "Invalid admin credentials");
            res.sendRedirect("unifiedLogin.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error occurred: " + e.getMessage());
            res.sendRedirect("unifiedLogin.jsp");
        }
    }
}