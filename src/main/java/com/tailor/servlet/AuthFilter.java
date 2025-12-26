package com.tailor.servlet;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter({"/adminDashboard.jsp","/TailorDB.jsp","/loginIndex.jsp"})
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest r = (HttpServletRequest) req;
        HttpSession session = r.getSession(false);

        if (session == null || session.getAttribute("userType") == null) {
            ((HttpServletResponse) res).sendRedirect("unifiedLogin.jsp");
            return;
        }
        chain.doFilter(req, res);
    }
}
