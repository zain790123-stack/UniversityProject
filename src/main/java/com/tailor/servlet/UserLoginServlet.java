package com.tailor.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.tailor.Util.DBUtil;

@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM signup_login WHERE email=? AND password=?");
            ps.setString(1, req.getParameter("email"));
            ps.setString(2, req.getParameter("password"));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HttpSession s = req.getSession();
                s.setAttribute("userType", "user");
                s.setAttribute("username", rs.getString("username"));
                res.sendRedirect("loginIndex.jsp");
                return;
            }
        } catch (Exception e) { e.printStackTrace(); }

        req.getSession().setAttribute("error", "Invalid credentials");
        res.sendRedirect("unifiedLogin.jsp");
    }
}
