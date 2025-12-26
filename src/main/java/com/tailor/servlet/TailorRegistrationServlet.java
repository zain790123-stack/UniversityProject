package com.tailor.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.security.*;
import java.sql.Timestamp;

import java.sql.*;
import java.time.Instant;
import java.util.Base64;
import java.util.Random;

@WebServlet("/TailorHandler")
@MultipartConfig
public class TailorRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/tailor_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "12345";

    private static final int OTP_LENGTH = 6;
    private static final long OTP_VALIDITY_DURATION = 5 * 60 * 1000;

    @Override
    public void init() throws ServletException {
        try {
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
        } catch (SQLException e) {
            throw new ServletException("Failed to register MySQL driver", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch(action) {
            case "sendOTP":
                handleOtpRequest(request, response);
                break;
            case "TailorRegistrationServlet":
                handleRegistration(request, response);
                break;
        }
    }

    private void handleOtpRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        if(email == null || !email.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")){
            response.getWriter().write("Invalid email");
            return;
        }

        String otp = generateOtp();
        session.setAttribute("otp", otp);
        session.setAttribute("otpCreationTime", Instant.now().toEpochMilli());

        System.out.println("Generated OTP for " + email + ": " + otp);

        response.getWriter().write("OTP generated! Check server console.");
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        String otpStored = (String) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otpCreationTime");

        String otpInput = request.getParameter("otp");
        if(otpStored == null || otpTime == null || !otpStored.equals(otpInput)
            || Instant.now().toEpochMilli() - otpTime > OTP_VALIDITY_DURATION){
            session.setAttribute("errorMessage","Invalid or expired OTP");
            response.sendRedirect("affilate tailors.jsp");
            return;
        }

        session.removeAttribute("otp");
        session.removeAttribute("otpCreationTime");

        String name = request.getParameter("tailorName");
        String phone = request.getParameter("tailorPhone");
        String address = request.getParameter("tailorAddress");
        String specialty = request.getParameter("specialty");
        int experience = Integer.parseInt(request.getParameter("experience"));
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String uploadDir = "C:\\Users\\Zain Ul Abidin\\eclipse-workspace\\ZTailor\\src\\main\\webapp\\uploads\\TailorPictures"; 
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }
  
        Part file = request.getPart("tailorPicture");
        String clothImage = file.getSubmittedFileName();
        System.out.println("Tailor image: " + clothImage);

        String filePath = uploadDir + File.separator + clothImage; 
        System.out.println("Upload path: " + filePath);

        try (FileOutputStream fos = new FileOutputStream(filePath);
             InputStream is = file.getInputStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = is.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead); 
            }
            System.out.println("Tailor Picture uploaded successfully to: " + filePath);
        } catch (Exception e) {
            e.printStackTrace();
        }
        String hashedPassword = hashPassword(password);

        try(Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            if(isEmailExists(conn,email) || isDuplicate(conn,"username",username) || isDuplicate(conn,"phone",phone)){
                session.setAttribute("errorMessage","Email/Username/Phone already exists");
                response.sendRedirect("affilate tailors.jsp");
                return;
            }

            String sql = "INSERT INTO Tailors (name,phone,address,picture_path,specialty,experience,username,email,password,verified,created_at) VALUES (?,?,?,?,?,?,?,?,?,?,?)";

            try(PreparedStatement ps = conn.prepareStatement(sql)){
                ps.setString(1, name);
                ps.setString(2, phone);
                ps.setString(3, address);
                ps.setString(4, clothImage); 
                ps.setString(5, specialty);
                ps.setInt(6, experience);
                ps.setString(7, username);
                ps.setString(8, email);
                ps.setString(9, hashedPassword);
                ps.setBoolean(10, true);
                ps.setTimestamp(11, new Timestamp(System.currentTimeMillis())); // For example, created_at
                ps.executeUpdate();
            }

            session.setAttribute("successMessage","Registration successful!");
            response.sendRedirect("affilate tailors.jsp");

        } catch(SQLException e){
            e.printStackTrace();
            session.setAttribute("errorMessage","DB Error: "+e.getMessage());
            response.sendRedirect("affilate tailors.jsp");
        }
    }

    private String generateOtp(){
        Random r = new Random();
        StringBuilder otp = new StringBuilder();
        for(int i=0; i<OTP_LENGTH; i++) otp.append(r.nextInt(10));
        return otp.toString();
    }

    private String hashPassword(String password){
        try{
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hash);
        }catch(Exception e){return null;}
    }

    private boolean isDuplicate(Connection conn,String field,String value) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Tailors WHERE "+field+"=?";
        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1,value);
            try(ResultSet rs = ps.executeQuery()){
                return rs.next() && rs.getInt(1)>0;
            }
        }
    }

    private boolean isEmailExists(Connection conn,String email) throws SQLException{
        String sql = "SELECT COUNT(*) FROM Tailors WHERE email=?";
        try(PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1,email);
            try(ResultSet rs = ps.executeQuery()){
                return rs.next() && rs.getInt(1)>0;
            }
        }
    }
}
