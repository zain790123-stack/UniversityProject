package com.tailor.servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.LinkedList;
import java.util.List;

@WebServlet("/AlterServlet")
@MultipartConfig
public class AlterationFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AlterationFormServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String garment = request.getParameter("garment");
        String alterationType = request.getParameter("alteration-type");
        String time = request.getParameter("date");
        String customerName = request.getParameter("customer-name");
        String customerPhone = request.getParameter("customer-phone");
        String customerWhatsapp = request.getParameter("customer-whatsapp");
        String customerAddress = request.getParameter("customer-address");
        String requestId = "Alt" + System.currentTimeMillis(); 

        String notes = request.getParameter("notes");
        String tailor = request.getParameter("tailor");
        List<String> l=new LinkedList<String>();

       
        String uploadDir = "C:\\Users\\Zain Ul Abidin\\git\\repository\\ZTailor\\src\\main\\webapp\\uploads\\alteration"; 
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

     
        Part file = request.getPart("face-picture");
        String clothImage = file.getSubmittedFileName();
        System.out.println("Face image: " + clothImage);

        String filePath = uploadDir + File.separator + clothImage; 
        System.out.println("Upload path: " + filePath);

        try (FileOutputStream fos = new FileOutputStream(filePath);
             InputStream is = file.getInputStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = is.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead); 
            }
            System.out.println("AlterCloth Picture uploaded successfully to: " + filePath);
        } catch (Exception e) {
            e.printStackTrace();
        }
        

        try {
        	    try {
        	        Class.forName("com.mysql.cj.jdbc.Driver");
        	    } catch (ClassNotFoundException e) {
        	        throw new RuntimeException("MySQL JDBC Driver missing", e);
        	    }
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tailor_db", "root", "12345");

            String sql = "INSERT INTO alteration_requests (garment,request_id, alteration_type, deadline, customer_name, customer_phone, customer_whatsapp, customer_address, additional_notes,tailor_name, cloth_image) VALUES (?,?, ?, ?, ?, ?, ?, ?, ?, ?,?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, garment);
            pstmt.setString(2,requestId );
            pstmt.setString(3, alterationType);
            pstmt.setString(4, time);
            pstmt.setString(5, customerName);
            pstmt.setString(6, customerPhone);
            pstmt.setString(7, customerWhatsapp);
            pstmt.setString(8, customerAddress);
            pstmt.setString(9, notes);
            pstmt.setString(10, tailor);
            pstmt.setString(11, clothImage);  
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("Alteration request submitted successfully!");
                request.getSession().setAttribute("success", "Form submitted successfully. Your Request ID is: " + requestId);
                response.sendRedirect("alterForm.jsp");
                return;
                
            } else {
                l.add("error:Form not submitted");
                request.setAttribute("errlist", l);
                RequestDispatcher rd = request.getRequestDispatcher("alterForm.jsp");
                rd.forward(request, response); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
