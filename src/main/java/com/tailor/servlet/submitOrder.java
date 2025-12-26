package com.tailor.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/submitOrder")
public class submitOrder extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String JDBC_URL = "jdbc:mysql://localhost:3306/tailor_shop";
    private final String JDBC_USER = "root";
    private final String JDBC_PASS = "12345";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String payment = request.getParameter("payment");
        String productName = request.getParameter("product");
        String priceStr = request.getParameter("price");
        double price = Double.parseDouble(priceStr);
        String orderId = "ORI" + System.currentTimeMillis();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

            String sql = "INSERT INTO orders (name, phone, address, payment_method, order_id, product_name, price) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, phone);
            stmt.setString(3, address);
            stmt.setString(4, payment);
            stmt.setString(5, orderId);
            stmt.setString(6, productName);
            stmt.setDouble(7, price);

            stmt.executeUpdate();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        String jazzcashAccount = "0314-9234937";
        String bankAccount = "PK12ABCD0001234567890001";

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang='en'><head><meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Order Confirmation</title>");
        out.println("<link href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css' rel='stylesheet'>");
        out.println("<style>");
        out.println("*{margin:0; padding:0; box-sizing:border-box; font-family:'Poppins', sans-serif;}");
        out.println("body{background:radial-gradient(circle at top,#1e1e2e,#000); color:white; min-height:100vh; display:flex; justify-content:center; align-items:flex-start; padding:50px 0;}");
        out.println(".container{background:rgba(255,255,255,0.07); border-radius:20px; border:1px solid rgba(255,255,255,0.18); backdrop-filter:blur(15px); box-shadow:0 8px 25px rgba(0,0,0,0.4); padding:35px; max-width:500px; text-align:center;}");
        out.println("h1{color:#00eaff; font-size:28px; margin-bottom:15px;}");
        out.println("p{margin:10px 0; font-size:16px;}");
        out.println(".payment-info{background:rgba(0,255,255,0.05); border:1px solid #00eaff; padding:15px; border-radius:10px; margin-top:20px; color:#00ff9d; font-weight:600;}");
        out.println(".btn-home{margin-top:25px; padding:12px 25px; background:linear-gradient(135deg,#00eaff,#00ff8c); color:black; border:none; border-radius:12px; font-weight:bold; text-decoration:none; display:inline-block; cursor:pointer; transition:0.3s;}");
        out.println(".btn-home:hover{transform:scale(1.05); box-shadow:0 0 15px #00eaff,0 0 25px #00ff9d;}");
        out.println("</style></head><body>");
        
        out.println("<div class='container'>");
        out.println("<h1>Thank You, " + name + "!</h1>");
        out.println("<p>Your order has been saved in our system.</p>");
        out.println("<p><strong>Order ID:</strong> " + orderId + "</p>");
        out.println("<p><strong>Product:</strong> " + productName + "</p>");
        out.println("<p><strong>Price:</strong> Rs " + price + "</p>");
        out.println("<p>We will contact you at <strong>" + phone + "</strong>.</p>");

        if ("JazzCash".equals(payment)) {
            out.println("<div class='payment-info'>Please send payment to our JazzCash account:<br><strong>" + jazzcashAccount + "</strong></div>");
        } else if ("Bank Transfer".equals(payment)) {
            out.println("<div class='payment-info'>Please transfer payment to our bank account:<br><strong>" + bankAccount + "</strong></div>");
        } else if ("Credit Card".equals(payment)) {
            out.println("<div class='payment-info'>We will send you a credit card payment link shortly.</div>");
        } else {
            out.println("<div class='payment-info'>Please prepare cash. Our courier will collect it upon delivery (COD).</div>");
        }

        out.println("<a href='Buy_product.jsp' class='btn-home'>Back to Home</a>");
        out.println("</div></body></html>");
    }
}
