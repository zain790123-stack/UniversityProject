package com.tailor.servlet;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.tailor.Dao.User;
import com.tailor.Util.DBUtil;

public class UserDao{

    public static int update(User user) {
        int status = 0;

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE signup_login SET username = ?, password = ?, email = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setInt(4, user.getId());

            status = ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Error updating user in DB: " + e.getMessage());
            e.printStackTrace();
        } finally {
           
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return status;
    }
}
