package com.tailor.servlet;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UnifiedLoginServlet")
public class UnifiedLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        String role = req.getParameter("role");
        String email = req.getParameter("email");
        String rememberMe = req.getParameter("rememberMe"); 

        if (role == null || role.isEmpty()) {
            req.getSession().setAttribute("error", "Please select a role");
            res.sendRedirect("unifiedLogin.jsp");
            return;
        }

        if (rememberMe != null) {
        
            Cookie c = new Cookie("rememberEmail", email);
            c.setMaxAge(7 * 24 * 60 * 60); 
            c.setPath(req.getContextPath());
            res.addCookie(c);
        } else {
            
            Cookie c = new Cookie("rememberEmail", "");
            c.setMaxAge(0);
            c.setPath(req.getContextPath());
            res.addCookie(c);
        }

        String targetServlet;

        switch (role) {
            case "admin":
                targetServlet = "/AdminLoginServlet";
                break;
            case "tailor":
                targetServlet = "/TailorLoginServlet";
                break;
            case "manager":
                targetServlet = "/ManagerLoginServlet";
                break;
            case "user":
                targetServlet = "/UserLoginServlet";
                break;
            default:
                req.getSession().setAttribute("error", "Invalid role");
                res.sendRedirect("unifiedLogin.jsp");
                return;
        }

        RequestDispatcher rd = req.getRequestDispatcher(targetServlet);
        rd.forward(req, res);
    }
}
