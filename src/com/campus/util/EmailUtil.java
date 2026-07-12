package com.campus.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

   
    private static final String SMTP_HOST     = "smtp.gmail.com";
    private static final int    SMTP_PORT     = 587;
    private static final String SMTP_EMAIL    = "abcd@gmail.com";   // my google account
    private static final String SMTP_PASSWORD = "your app password";      // this is my google account app password
    private static final String FROM_NAME     = "Campus Recruitment Cell";

    public static boolean sendEmail(String toEmail, String subject, String htmlBody) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_EMAIL, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_EMAIL, FROM_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.err.println("Email send failed to " + toEmail + ": " + e.getMessage());
            return false;
        }
    }

    public static String buildDriveNotificationEmail(String studentName, String driveTitle,
                                                      String companyName, String role,
                                                      String salary, String deadline, String appUrl) {
        return "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f4f6f9;padding:20px;'>"
            + "<div style='max-width:600px;margin:auto;background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 2px 10px rgba(0,0,0,0.1);'>"
            + "<div style='background:linear-gradient(135deg,#1a237e,#283593);padding:30px;text-align:center;'>"
            + "<h1 style='color:#fff;margin:0;font-size:24px;'>New Placement Drive!</h1>"
            + "<p style='color:#c5cae9;margin:5px 0 0;'>Campus Recruitment Cell</p>"
            + "</div>"
            + "<div style='padding:30px;'>"
            + "<p style='font-size:16px;'>Dear <strong>" + studentName + "</strong>,</p>"
            + "<p>Great news! A new placement drive has been posted and you are eligible to apply.</p>"
            + "<div style='background:#e8eaf6;border-left:4px solid #3949ab;border-radius:5px;padding:20px;margin:20px 0;'>"
            + "<h2 style='color:#1a237e;margin:0 0 15px;'>" + driveTitle + "</h2>"
            + "<table style='width:100%;border-collapse:collapse;'>"
            + "<tr><td style='padding:5px 0;color:#666;width:40%;'>Company:</td><td style='padding:5px 0;font-weight:bold;'>" + companyName + "</td></tr>"
            + "<tr><td style='padding:5px 0;color:#666;'>Role:</td><td style='padding:5px 0;font-weight:bold;'>" + role + "</td></tr>"
            + "<tr><td style='padding:5px 0;color:#666;'>Salary:</td><td style='padding:5px 0;font-weight:bold;color:#2e7d32;'>" + salary + "</td></tr>"
            + "<tr><td style='padding:5px 0;color:#666;'>Last Date:</td><td style='padding:5px 0;font-weight:bold;color:#c62828;'>" + deadline + "</td></tr>"
            + "</table></div>"
            + "<div style='text-align:center;margin:25px 0;'>"
            + "<a href='" + appUrl + "' style='background:linear-gradient(135deg,#1a237e,#283593);color:#fff;padding:14px 35px;border-radius:6px;text-decoration:none;font-size:16px;font-weight:bold;'>Apply Now</a>"
            + "</div>"
            + "<p style='color:#888;font-size:13px;'>Login to your student portal to apply. Don't miss this opportunity!</p>"
            + "</div>"
            + "<div style='background:#f5f5f5;padding:15px;text-align:center;color:#999;font-size:12px;'>"
            + "<p>Campus Recruitment Management System &bull; This is an automated message</p>"
            + "</div></div></body></html>";
    }
}
