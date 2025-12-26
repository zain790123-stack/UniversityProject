package com.tailor.Util;

import java.sql.*;

public class DBUtil {
private static final String URL="jdbc:mysql://localhost:3306/tailor_db";
private static final String USERNAME="root";
private static final String PASSWORD = "12345";

static {
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
	}catch(ClassNotFoundException e){
		e.printStackTrace();
	}
}
public static Connection getShopDBConnection() throws SQLException {
    return DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/tailor_shop","root","12345");
}
public static Connection getConnection() throws SQLException{
	System.out.println("Connection established");
	return DriverManager.getConnection(URL,USERNAME,PASSWORD);
}
    
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

	public static void closeStatement(PreparedStatement pstmt) {
		if (pstmt != null) {
            try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
		
	}
}
