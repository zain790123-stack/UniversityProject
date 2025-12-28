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

        boolean validUser = false;
        String username = null;

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT username FROM signup_login WHERE email=? AND password=?")) {

            ps.setString(1, req.getParameter("email"));
            ps.setString(2, req.getParameter("password"));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    validUser = true;
                    username = rs.getString("username");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (validUser) {
            HttpSession session = req.getSession(true);
            session.setAttribute("userType", "user");
            session.setAttribute("username", username);

            //  SAFE redirect
            res.sendRedirect(req.getContextPath() + "/loginIndex.jsp");
        } else {
            req.getSession().setAttribute("error", "Invalid credentials");
            res.sendRedirect(req.getContextPath() + "/unifiedLogin.jsp");
        }
    }
}
