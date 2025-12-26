package com.tailor.servlet;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/ManagerLoginServlet")
public class ManagerLoginServlet extends HttpServlet {
    
	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
       
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/tailor_db","root","12345"
            );
            
            String sql = "SELECT * FROM managers WHERE email = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password); 
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {

                HttpSession session = request.getSession();
                session.setAttribute("managerId", rs.getInt("id"));
                session.setAttribute("managerName", rs.getString("name"));
                session.setAttribute("managerEmail", rs.getString("email"));
                
                response.sendRedirect("managerDashboard.jsp");
                
            } else {

                request.getSession().setAttribute("error", "Invalid email or password");
                response.sendRedirect("unifiedLogin.jsp");
            }
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database driver not found");
            response.sendRedirect("unifiedLogin.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect("unifiedLogin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Server error: " + e.getMessage());
            response.sendRedirect("unifiedLogin.jsp");
        } finally {
           
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
}