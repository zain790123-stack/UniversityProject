package com.tailor.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdatePriceServlet")
public class UpdatePriceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tailorName = request.getParameter("tailorName");

        try {
            // Safe parsing (prevents crash if empty or invalid)
            double single = parseDouble(request.getParameter("suit_single_price"));
            double dbl = parseDouble(request.getParameter("suit_double_price"));
            double urgent = parseDouble(request.getParameter("suit_urgent_price"));
            double altBasic = parseDouble(request.getParameter("alteration_basic_price"));
            double altUrgent = parseDouble(request.getParameter("alteration_urgent_price"));

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/tailor_db",
                    "root",
                    "12345"
            );

            String sql = "UPDATE tailors SET "
                    + "suit_single_price=?, "
                    + "suit_double_price=?, "
                    + "suit_urgent_price=?, "
                    + "alteration_basic_price=?, "
                    + "alteration_urgent_price=? "
                    + "WHERE name=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setDouble(1, single);
            ps.setDouble(2, dbl);
            ps.setDouble(3, urgent);
            ps.setDouble(4, altBasic);
            ps.setDouble(5, altUrgent);
            ps.setString(6, tailorName);

            int rows = ps.executeUpdate();

            ps.close();
            con.close();

            if (rows > 0) {
                response.sendRedirect("TailorDB.jsp?msg=prices_updated");
            } else {
                response.sendRedirect("TailorDB.jsp?msg=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("TailorDB.jsp?msg=error");
        }
    }

    // Safe converter to avoid NUMBER FORMAT crashes
    private double parseDouble(String val) {
        try {
            if (val == null || val.trim().isEmpty()) return 0.0;
            return Double.parseDouble(val);
        } catch (Exception e) {
            return 0.0;
        }
    }
}