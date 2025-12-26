<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

session.removeAttribute("managerId");
session.removeAttribute("managerName");
session.removeAttribute("managerEmail");

session.invalidate();

response.sendRedirect("unifiedLogin.jsp");
%>