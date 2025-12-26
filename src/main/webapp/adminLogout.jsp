<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

session.removeAttribute("adminId");
session.removeAttribute("adminName");
session.removeAttribute("adminEmail");
session.removeAttribute("adminLoggedIn");
session.removeAttribute("adminRole");
session.removeAttribute("error");  

session.invalidate();

Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        
        if (cookie.getName().startsWith("admin") || 
            cookie.getName().equals("JSESSIONID") ||
            cookie.getName().equals("rememberEmail") ||
            cookie.getName().equals("rememberMe")) {
            
            cookie.setValue(null);
            cookie.setMaxAge(0);
            cookie.setPath("/");
            response.addCookie(cookie);
        }
    }
}

response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache"); 
response.setHeader("Expires", "0"); 
response.sendRedirect("unifiedLogin.jsp");
%>