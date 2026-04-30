package com.tailor.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/GetTailorPriceServlet")
public class GetTailorPriceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/tailor_db?useUnicode=true&characterEncoding=UTF-8", 
                "root", 
                "12345");

            String tailorName = request.getParameter("tailor"); 

            PreparedStatement ps = con.prepareStatement(
                "SELECT suit_single_price, suit_double_price, suit_urgent_price FROM tailors WHERE name=?");

            ps.setString(1, tailorName); 
            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                out.print("{");
                out.print("\"singlePrice\":" + rs.getDouble("suit_single_price") + ",");
                out.print("\"doublePrice\":" + rs.getDouble("suit_double_price") + ",");
                out.print("\"urgentPrice\":" + rs.getDouble("suit_urgent_price"));
                out.print("}");
            } else {
                out.print("{\"error\":\"tailor not found\"}");
            }

            rs.close();
            ps.close();
            con.close();

        } catch(Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"server error: " + e.getMessage() + "\"}");
        }
    }
}