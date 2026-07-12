package com.campus.util;

import com.campus.model.Application;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.ByteArrayOutputStream;
import java.util.List;

public class ExcelExportUtil {

    public static byte[] exportApplications(List<Application> apps, String[] fields, String driveTitle) throws Exception {
        try (Workbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Applicants");

            // Header style
            CellStyle headerStyle = wb.createCellStyle();
            Font headerFont = wb.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setBorderBottom(BorderStyle.THIN);

            // Title row
            Row titleRow = sheet.createRow(0);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("Applicants for: " + driveTitle);
            CellStyle titleStyle = wb.createCellStyle();
            Font titleFont = wb.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);
            titleCell.setCellStyle(titleStyle);

            // Header row
            Row header = sheet.createRow(1);
            String[] labels = getLabels(fields);
            for (int i = 0; i < labels.length; i++) {
                Cell c = header.createCell(i);
                c.setCellValue(labels[i]);
                c.setCellStyle(headerStyle);
                sheet.setColumnWidth(i, 5000);
            }

            // Data rows
            CellStyle altStyle = wb.createCellStyle();
            altStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
            altStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            for (int r = 0; r < apps.size(); r++) {
                Row row = sheet.createRow(r + 2);
                Application app = apps.get(r);
                for (int i = 0; i < fields.length; i++) {
                    Cell cell = row.createCell(i);
                    cell.setCellValue(getValue(app, fields[i]));
                    if (r % 2 == 1) cell.setCellStyle(altStyle);
                }
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            wb.write(out);
            return out.toByteArray();
        }
    }

    private static String[] getLabels(String[] fields) {
        String[] labels = new String[fields.length];
        for (int i = 0; i < fields.length; i++) {
            switch (fields[i]) {
                case "name": labels[i] = "Student Name"; break;
                case "email": labels[i] = "Email"; break;
                case "phone": labels[i] = "Phone"; break;
                case "department": labels[i] = "Department"; break;
                case "batch": labels[i] = "Batch"; break;
                case "rollNumber": labels[i] = "Roll Number"; break;
                case "cgpa": labels[i] = "CGPA"; break;
                case "tenthPercent": labels[i] = "10th %"; break;
                case "twelfthPercent": labels[i] = "12th %"; break;
                case "gradPercent": labels[i] = "Graduation %"; break;
                case "mastersPercent": labels[i] = "Masters %"; break;
                case "skills": labels[i] = "Skills"; break;
                case "status": labels[i] = "Application Status"; break;
                default: labels[i] = fields[i];
            }
        }
        return labels;
    }

    private static String getValue(Application app, String field) {
        switch (field) {
            case "name": return app.getStudentName() != null ? app.getStudentName() : "";
            case "email": return app.getStudentEmail() != null ? app.getStudentEmail() : "";
            case "phone": return app.getStudentPhone() != null ? app.getStudentPhone() : "";
            case "department": return app.getStudentDepartment() != null ? app.getStudentDepartment() : "";
            case "batch": return app.getStudentBatch() != null ? app.getStudentBatch() : "";
            case "rollNumber": return app.getStudentRollNumber() != null ? app.getStudentRollNumber() : "";
            case "cgpa": return String.valueOf(app.getStudentCgpa());
            case "tenthPercent": return String.valueOf(app.getStudentTenthPercent());
            case "twelfthPercent": return String.valueOf(app.getStudentTwelfthPercent());
            case "gradPercent": return String.valueOf(app.getStudentGradPercent());
            case "mastersPercent": return String.valueOf(app.getStudentMastersPercent());
            case "skills": return app.getStudentSkills() != null ? app.getStudentSkills() : "";
            case "status": return app.getStatus() != null ? app.getStatus() : "";
            default: return "";
        }
    }
}
