package com.tailor.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/GetAlterationPriceServlet")
public class GetAlterationPriceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/tailor_db?useUnicode=true&characterEncoding=UTF-8",
                "root",
                "12345"
            );

            String tailorName = request.getParameter("tailor");

            ps = con.prepareStatement(
                "SELECT alteration_basic_price, alteration_urgent_price FROM tailors WHERE name=?"
            );

            ps.setString(1, tailorName);

            rs = ps.executeQuery();

            if (rs.next()) {
                double normal = rs.getDouble("alteration_basic_price");
                double urgent = rs.getDouble("alteration_urgent_price");

                out.print("{");
                out.print("\"normalPrice\":" + normal + ",");
                out.print("\"urgentPrice\":" + urgent);
                out.print("}");
            } else {
                out.print("{\"error\":\"tailor not found\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"server error\"}");
        } finally {
            try { if (rs != null) rs.close(); } catch(Exception e){}
            try { if (ps != null) ps.close(); } catch(Exception e){}
            try { if (con != null) con.close(); } catch(Exception e){}
        }
    }
}