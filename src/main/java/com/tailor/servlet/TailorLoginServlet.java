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
import com.tailor.Util.PasswordUtil;

@WebServlet("/TailorLoginServlet")
public class TailorLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM tailors WHERE email=? AND password=?");
            ps.setString(1, req.getParameter("email"));
            ps.setString(2, PasswordUtil.hash(req.getParameter("password")));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HttpSession s = req.getSession();
                s.setAttribute("userType", "tailor");
                s.setAttribute("tailorId", rs.getInt("id"));  
                s.setAttribute("tailorName", rs.getString("name"));
                s.setAttribute("tailorEmail", rs.getString("email"));
                res.sendRedirect("TailorDB.jsp");
                return;
            }
        } catch (Exception e) { e.printStackTrace(); }

        req.getSession().setAttribute("error", "Invalid credentials");
        res.sendRedirect("unifiedLogin.jsp");
    }
}
