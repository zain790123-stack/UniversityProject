<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%

session.removeAttribute("tailorName");
session.removeAttribute("tailorEmail");
session.removeAttribute("tailorId");
session.removeAttribute("tailorLoggedIn");

session.invalidate();

Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}

response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");

response.sendRedirect("unifiedLogin.jsp");
%>