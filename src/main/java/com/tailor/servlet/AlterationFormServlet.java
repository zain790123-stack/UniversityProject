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
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AlterationFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AlterationFormServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        List<String> errors = new LinkedList<String>();
        
        try {
            
            String garment = request.getParameter("garment");
            String alterationType = request.getParameter("alttype");
            String time = request.getParameter("date");
            String customerName = request.getParameter("customer-name");
            String customerPhone = request.getParameter("customer-phone");
            String customerWhatsapp = request.getParameter("customer-whatsapp");
            String customerAddress = request.getParameter("customer-address");
            String notes = request.getParameter("notes");
            String tailorName = request.getParameter("tailor");
            
            double price = 0.0;
            String priceParam = request.getParameter("price");

            System.out.println("Received price: " + priceParam);

            if (priceParam != null && !priceParam.trim().isEmpty()) {
                try {
                    price = Double.parseDouble(priceParam.trim());
                } catch (Exception e) {
                    System.out.println("Invalid price format, defaulting to 0");
                    price = 0.0;
                }
            } else {
                price = 0.0; 
                System.out.println("Price missing, set to 0");
            }            

            String requestId = "ALT" + System.currentTimeMillis();
            

            if (garment == null || garment.trim().isEmpty()) {
                errors.add("Garment type is required");
            }
            if (alterationType == null || alterationType.trim().isEmpty()) {
                errors.add("Alteration type is required");
            }
            if (time == null || time.trim().isEmpty()) {
                errors.add("Deadline date is required");
            }
            if (customerName == null || customerName.trim().isEmpty()) {
                errors.add("Customer name is required");
            }
            if (customerPhone == null || customerPhone.trim().isEmpty()) {
                errors.add("Customer phone is required");
            }
            if (tailorName == null || tailorName.trim().isEmpty()) {

            	tailorName = request.getParameter("tailor");
                System.out.println("Tailor name from fallback: " + tailorName);
                if (tailorName == null || tailorName.trim().isEmpty()) {
                    errors.add("Tailor selection is required");
                }
            }
            

            String clothImage = null;
            Part file = request.getPart("face-picture");
            
            if (file != null && file.getSize() > 0) {
                clothImage = getFileName(file);
                System.out.println("Cloth image filename: " + clothImage);
                
                String uploadDir = getServletContext().getRealPath("/uploads/alteration");
                if (uploadDir == null) {

                	uploadDir = "C:\\Users\\Zain Ul Abidin\\eclipse-workspace\\ZTailor\\src\\main\\webapp\\uploads\\alteration";
                }
                
                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) {
                    boolean created = uploadFolder.mkdirs();
                    System.out.println("Upload folder created: " + created + " at " + uploadDir);
                }
                
                String filePath = uploadDir + File.separator + clothImage;
                System.out.println("Full upload path: " + filePath);
                
                try (FileOutputStream fos = new FileOutputStream(filePath);
                     InputStream is = file.getInputStream()) {
                    
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = is.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesRead);
                    }
                    System.out.println("Alteration cloth picture uploaded successfully to: " + filePath);
                } catch (Exception e) {
                    System.err.println("Error saving file: " + e.getMessage());
                    e.printStackTrace();
                    errors.add("Failed to upload image: " + e.getMessage());
                }
            } else {
                errors.add("Cloth picture is required");
            }
            
            if (!errors.isEmpty()) {
                request.setAttribute("errlist", errors);
                RequestDispatcher rd = request.getRequestDispatcher("alterForm.jsp");
                rd.forward(request, response);
                return;
            }
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                try (Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/tailor_db?useUnicode=true&characterEncoding=UTF-8", 
                        "root", 
                        "12345")) {
                	System.out.println("GARMENT: " + garment);
                	System.out.println("TAILOR: " + tailorName);
                	System.out.println("TYPE: " + alterationType);
                	System.out.println("PRICE FINAL: " + price);
                    String sql = "INSERT INTO alteration_requests (garment, request_id, alteration_type, deadline, customer_name, customer_phone, customer_whatsapp, customer_address, additional_notes,tailor_name, cloth_image, price, created_at) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
                    
                    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                        pstmt.setString(1, garment);
                        pstmt.setString(2, requestId);
                        pstmt.setString(3, alterationType);
                        pstmt.setString(4, time);
                        pstmt.setString(5, customerName);
                        pstmt.setString(6, customerPhone);
                        pstmt.setString(7, customerWhatsapp);
                        pstmt.setString(8, customerAddress);
                        pstmt.setString(9, notes);
                        pstmt.setString(10, tailorName);
                        pstmt.setString(11, clothImage);
                        pstmt.setDouble(12, price);
                        System.out.println("Saving price into DB: " + price);
                        
                        int rows = pstmt.executeUpdate();
                        
                        if (rows > 0) {
                            System.out.println("Alteration request submitted successfully! Request ID: " + requestId + ", Price: " + price);
                            request.getSession().setAttribute("success", "Alteration request submitted successfully! Your Request ID is: " + requestId + " | Total Price: Rs " + price);
                            response.sendRedirect("alterForm.jsp");
                            return;
                        } else {
                            errors.add("Database insertion failed");
                            request.setAttribute("errlist", errors);
                            RequestDispatcher rd = request.getRequestDispatcher("alterForm.jsp");
                            rd.forward(request, response);
                        }
                    }
                }
            } catch (ClassNotFoundException e) {
                System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
                e.printStackTrace();
                errors.add("Database driver error: " + e.getMessage());
                request.setAttribute("errlist", errors);
                RequestDispatcher rd = request.getRequestDispatcher("alterForm.jsp");
                rd.forward(request, response);
            } catch (Exception e) {
                System.err.println("Database error: " + e.getMessage());
                e.printStackTrace();
                errors.add("Database error: " + e.getMessage());
                request.setAttribute("errlist", errors);
                RequestDispatcher rd = request.getRequestDispatcher("alterForm.jsp");
                rd.forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Servlet error: " + e.getMessage());
            e.printStackTrace();
            List<String> errorList = new LinkedList<>();
            errorList.add("Server error: " + e.getMessage());
            request.setAttribute("errlist", errorList);
            RequestDispatcher rd = request.getRequestDispatcher("alterForm.jsp");
            rd.forward(request, response);
        }
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {

            	String fileName = element.substring(element.indexOf('=') + 1).trim().replace("\"", "");
                int lastBackslash = fileName.lastIndexOf("\\");
                if (lastBackslash != -1) {
                    fileName = fileName.substring(lastBackslash + 1);
                }
                int lastSlash = fileName.lastIndexOf("/");
                if (lastSlash != -1) {
                    fileName = fileName.substring(lastSlash + 1);
                }
                String nameWithoutExt = fileName;
                String extension = "";
                int dotIndex = fileName.lastIndexOf(".");
                if (dotIndex > 0) {
                    nameWithoutExt = fileName.substring(0, dotIndex);
                    extension = fileName.substring(dotIndex);
                }
                return nameWithoutExt + "_" + System.currentTimeMillis() + extension;
            }
        }
        return "file_" + System.currentTimeMillis();
    }
}