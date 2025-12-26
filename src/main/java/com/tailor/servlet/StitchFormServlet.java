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

@WebServlet("/suitServlet")
@MultipartConfig
public class StitchFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public StitchFormServlet() {
        super();
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String garment = request.getParameter("garment");
        String alterationType = request.getParameter("slai");
        String time = request.getParameter("date");
        String customerName = request.getParameter("customer-name");
        String customerPhone = request.getParameter("customer-phone");
        String customerWhatsapp = request.getParameter("customer-whatsapp");
        String customerAddress = request.getParameter("customer-address");
        String hasMeasurements = request.getParameter("hasMeasurements");
        StringBuilder measurements = new StringBuilder();

        if ("yes".equals(hasMeasurements)) {

            addMeasure(measurements, "Teera", request.getParameter("teera"));
            addMeasure(measurements, "Ghera", request.getParameter("ghera"));
            addMeasure(measurements, "Hip", request.getParameter("hip"));
            addMeasure(measurements, "Chest", request.getParameter("chest"));
            addMeasure(measurements, "Belly", request.getParameter("belly"));
            addMeasure(measurements, "Shalwar Length", request.getParameter("shalwar"));
            addMeasure(measurements, "Kameez Length", request.getParameter("kameez"));
            addMeasure(measurements, "Shoulder", request.getParameter("shoulder"));
            addMeasure(measurements, "Sleeve", request.getParameter("sleeve"));
            addMeasure(measurements, "Cuff", request.getParameter("cuff"));
            addMeasure(measurements, "Neck", request.getParameter("neck"));
            addMeasure(measurements, "Pancha", request.getParameter("pancha"));

            if (measurements.length() == 0) {
                measurements.append("Measurements not provided");
            }

        } else {
            measurements.append("No measurements available");
        }

        String measurementsText = measurements.toString();

        String requestId = "Sqt" + System.currentTimeMillis(); 

        String notes = request.getParameter("notes");
        String tailor = request.getParameter("tailor");
        List<String> l=new LinkedList<String>();

       
        String uploadDir = "C:\\Users\\Zain Ul Abidin\\git\\repository\\ZTailor\\src\\main\\webapp\\uploads\\custom_tailor\\clothPicture"; 
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }
  
        Part file = request.getPart("face-picture");
        String clothImage = file.getSubmittedFileName();
        System.out.println("cloth image: " + clothImage);

        String filePath = uploadDir + File.separator + clothImage; 
        System.out.println("Upload path: " + filePath);

        try (FileOutputStream fos = new FileOutputStream(filePath);
             InputStream is = file.getInputStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = is.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead); 
            }
            System.out.println("Cloth Picture uploaded successfully to: " + filePath);
        } catch (Exception e) {
            e.printStackTrace();
        }
        String uploadDir2 = "C:\\Users\\Zain Ul Abidin\\git\\repository\\ZTailor\\src\\main\\webapp\\uploads\\custom_tailor\\CustomerPctures"; 
        File uploadFolder2 = new File(uploadDir2);
        if (!uploadFolder2.exists()) {
            uploadFolder2.mkdirs();
        }

        Part file2 = request.getPart("client-picture");
        String FaceImage = file2.getSubmittedFileName();
        System.out.println("Face image: " + FaceImage);

        String filePath2 = uploadDir2 + File.separator + FaceImage; 
        System.out.println("Upload path: " + filePath2);

        try (FileOutputStream fos = new FileOutputStream(filePath2);
             InputStream is = file2.getInputStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = is.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead); 
            }
            System.out.println("Face Picture uploaded successfully to: " + filePath2);
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

            String sql = "INSERT INTO suit_requests (garment,request_id, slai, deadline, customer_name, customer_phone, customer_whatsapp, customer_address, additional_notes,tailor_name, cloth_image,client_image, measurements) VALUES (?,?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)";
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
            pstmt.setString(12, FaceImage); 
            pstmt.setString(13, measurementsText); 
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("Suit Stitching request submitted successfully!");
                request.getSession().setAttribute("success", "Form submitted successfully. Your Request ID is: " + requestId);
                response.sendRedirect("StitchForm.jsp");
                return;
                
            } else {
                l.add("error:Form not submitted");
                request.setAttribute("errlist", l);
                RequestDispatcher rd = request.getRequestDispatcher("StitchForm.jsp");
                rd.forward(request, response); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void addMeasure(StringBuilder sb, String label, String value) {
        if (value != null && !value.trim().isEmpty()) {
            sb.append(label).append(": ").append(value).append(", ");
        }
    }

}

