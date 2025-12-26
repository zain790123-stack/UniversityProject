package com.tailor.Util;

import java.security.MessageDigest;
import java.util.Base64;

public class PasswordUtil {
    public static String hash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return Base64.getEncoder().encodeToString(md.digest(password.getBytes()));
        } catch (Exception e) {
            return null;
        }
    }
}
