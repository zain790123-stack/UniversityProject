package com.tailor.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/TailorProfileUpdate")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, 
    maxFileSize = 1024 * 1024 * 5,   
    maxRequestSize = 1024 * 1024 * 10 
)
public class TailorProfileUpdate extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession();
        Integer id = (Integer) s.getAttribute("tailorId");
        if (id == null) {
            resp.sendRedirect("unifiedLogin.jsp");
            return;
        }

        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String specialty = req.getParameter("specialty");
        int exp = Integer.parseInt(req.getParameter("experience"));

        try {
            Part pic = req.getPart("picture");
            String fileName = (pic != null && pic.getSize() > 0) ? pic.getSubmittedFileName() : null;

            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/tailor_db", "root", "12345")) {

                if (fileName != null && !fileName.isEmpty()) {
                    String uploadPath = "C:\\Users\\Zain Ul Abidin\\eclipse-workspace\\ZTailor\\src\\main\\webapp\\uploads\\TailorPictures" + fileName;
                    pic.write(uploadPath);

                    String sql = "UPDATE tailors SET phone=?, address=?, specialty=?, experience=?, picture_path=? WHERE id=?";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, phone);
                        ps.setString(2, address);
                        ps.setString(3, specialty);
                        ps.setInt(4, exp);
                        ps.setString(5, fileName);
                        ps.setInt(6, id);
                        ps.executeUpdate();
                    }
                } else {
                    String sql = "UPDATE tailors SET phone=?, address=?, specialty=?, experience=? WHERE id=?";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, phone);
                        ps.setString(2, address);
                        ps.setString(3, specialty);
                        ps.setInt(4, exp);
                        ps.setInt(5, id);
                        ps.executeUpdate();
                    }
                }
            }

            HttpSession session = req.getSession();
            session.setAttribute("successMsg", "Profile updated successfully!");
            resp.sendRedirect("TailorDB.jsp?success=1");

        } catch (SQLException | ServletException e) {
            e.printStackTrace();
            resp.sendRedirect("tailorAccount.jsp?error=1");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            resp.sendRedirect("tailorAccount.jsp?error=driver");
        }
    }
}
