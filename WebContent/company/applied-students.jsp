<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    if(session.getAttribute("companyId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=company");return;}
    Drive drive = (Drive) request.getAttribute("drive");
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    if(drive==null){response.sendRedirect(request.getContextPath()+"/company/action/drives");return;}
    if(applications==null) applications=new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Applicants - <%= drive.getTitle() %></title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Applied Students</div><div style="font-size:12px;color:#888;"><a href="${pageContext.request.contextPath}/company/action/drives">← Back to Drives</a></div></div>
      <div class="topbar-right">
        <button class="btn btn-success btn-sm" id="exportBtn">📥 Export to Excel</button>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
      </div>
    </div>
    <div class="page-content">
      <!-- Drive Summary -->
      <div class="card" style="border-left:4px solid #1a237e;margin-bottom:20px;">
        <div class="card-body">
          <h3 style="color:#1a237e;margin-bottom:8px;"><%= drive.getTitle() %></h3>
          <div style="display:flex;gap:20px;flex-wrap:wrap;font-size:14px;color:#666;">
            <span>💼 <%= drive.getRole() %></span>
            <% if(drive.getSalary()!=null){ %><span>💰 <%= drive.getSalary() %></span><% } %>
            <% if(drive.getLocation()!=null){ %><span>📍 <%= drive.getLocation() %></span><% } %>
            <span>📩 <strong><%= applications.size() %></strong> applicants</span>
            <% long sel = applications.stream().filter(a->"selected".equals(a.getStatus())).count(); %>
            <span style="color:#2e7d32;">✅ <strong><%= sel %></strong> selected</span>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-header">
          <h3>All Applicants (<%= applications.size() %>)</h3>
          <input type="text" id="tableSearch" class="form-control" placeholder="🔍 Search..." style="width:220px;">
        </div>
        <div class="table-responsive">
          <table class="searchable-table">
            <thead>
              <tr><th>#</th><th>Name</th><th>Email</th><th>Phone</th><th>Dept</th><th>Batch</th><th>CGPA</th><th>10th%</th><th>12th%</th><th>Status</th><th>Resume</th></tr>
            </thead>
            <tbody>
            <% if(applications.isEmpty()){ %>
            <tr><td colspan="11" style="text-align:center;padding:40px;color:#888;">No applications received yet.</td></tr>
            <% } %>
            <% int i=1; for(Application app: applications){ %>
            <tr>
              <td><%= i++ %></td>
              <td style="font-weight:600;"><%= app.getStudentName() %></td>
              <td><%= app.getStudentEmail() %></td>
              <td><%= app.getStudentPhone()!=null?app.getStudentPhone():"-" %></td>
              <td><%= app.getStudentDepartment()!=null?app.getStudentDepartment():"-" %></td>
              <td><%= app.getStudentBatch()!=null?app.getStudentBatch():"-" %></td>
              <td><strong><%= app.getStudentCgpa() %></strong></td>
              <td><%= app.getStudentTenthPercent() %>%</td>
              <td><%= app.getStudentTwelfthPercent() %>%</td>
              <td>
                <% String as=app.getStatus(); String abc="badge-muted";
                   if("selected".equals(as)) abc="badge-success";
                   else if("shortlisted".equals(as)) abc="badge-info";
                   else if("rejected".equals(as)) abc="badge-danger";
                   else if("applied".equals(as)) abc="badge-primary"; %>
                <span class="badge <%= abc %>"><%= as %></span>
              </td>
              <td>
                <% if(app.getStudentResumePath()!=null && !app.getStudentResumePath().isEmpty()){ %>
                <a href="${pageContext.request.contextPath}/<%= app.getStudentResumePath() %>" target="_blank" class="btn btn-sm btn-info">📄 View</a>
                <% }else{ %><span style="color:#ccc;font-size:12px;">None</span><% } %>
              </td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Export Modal -->
<div class="modal-overlay" id="exportModal">
  <div class="modal-box">
    <h3>📥 Export Applicant Data</h3>
    <p style="color:#888;font-size:13px;margin-bottom:16px;">Choose the fields to include in the Excel file.</p>
    <form method="get" action="${pageContext.request.contextPath}/company/export-students" target="_blank">
      <input type="hidden" name="driveId" value="<%= drive.getId() %>">
      <div style="margin-bottom:12px;"><label class="checkbox-item"><input type="checkbox" id="selectAllFields"> <strong>Select All</strong></label></div>
      <div class="checkbox-grid">
        <label class="checkbox-item"><input type="checkbox" name="fields" value="name" class="export-field" checked> Name</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="email" class="export-field" checked> Email</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="phone" class="export-field" checked> Phone</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="department" class="export-field" checked> Department</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="batch" class="export-field" checked> Batch</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="rollNumber" class="export-field"> Roll Number</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="cgpa" class="export-field" checked> CGPA</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="tenthPercent" class="export-field"> 10th %</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="twelfthPercent" class="export-field"> 12th %</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="gradPercent" class="export-field"> Grad %</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="skills" class="export-field"> Skills</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="status" class="export-field" checked> Status</label>
      </div>
      <div class="modal-footer">
        <button type="button" id="closeModal" class="btn btn-outline">Cancel</button>
        <button type="submit" class="btn btn-success">📥 Download Excel</button>
      </div>
    </form>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
