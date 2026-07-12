<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*" %>
<%
    if(session.getAttribute("adminId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=admin");return;}
    Student s = (Student) request.getAttribute("student");
    if(s==null){response.sendRedirect(request.getContextPath()+"/admin/action/students");return;}
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Student Detail - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div>
        <div class="topbar-title">Student Details</div>
        <div style="font-size:12px;color:#888;"><a href="${pageContext.request.contextPath}/admin/action/students">← Back to Students</a></div>
      </div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>

      <!-- Profile Header -->
      <div class="profile-header" style="margin-bottom:24px;">
        <div class="profile-avatar">👤</div>
        <div class="profile-info">
          <h2><%= s.getName() %></h2>
          <p><%= s.getEmail() %> · <%= s.getPhone()!=null?s.getPhone():"" %></p>
          <p><%= s.getDepartment()!=null?s.getDepartment():"" %> · Batch <%= s.getBatch()!=null?s.getBatch():"" %></p>
          <p style="margin-top:8px;">
            <% if(s.isActive()){ %><span class="badge badge-success">Active</span><% }else{ %><span class="badge badge-danger">Inactive</span><% } %>
            <% if(s.isProfileComplete()){ %><span class="badge badge-info" style="margin-left:6px;">Profile Complete</span><% } %>
            <% if(s.getResumePath()!=null && !s.getResumePath().isEmpty()){ %><span class="badge badge-success" style="margin-left:6px;">Resume Uploaded</span><% } %>
          </p>
        </div>
      </div>

      <!-- Academic Info -->
      <div class="card" style="margin-bottom:20px;">
        <div class="card-header"><h3>Academic Information</h3></div>
        <div class="card-body">
          <div class="detail-grid">
            <div class="detail-item"><label>Roll Number</label><p><%= s.getRollNumber()!=null?s.getRollNumber():"-" %></p></div>
            <div class="detail-item"><label>CGPA</label><p style="font-size:22px;font-weight:700;color:#1a237e;"><%= s.getCgpa() %></p></div>
            <div class="detail-item"><label>10th Percentage</label><p><%= s.getTenthPercent() %>%</p></div>
            <div class="detail-item"><label>12th Percentage</label><p><%= s.getTwelfthPercent() %>%</p></div>
            <div class="detail-item"><label>Graduation %</label><p><%= s.getGradPercent() > 0 ? s.getGradPercent()+"%" : "N/A" %></p></div>
            <div class="detail-item"><label>Masters %</label><p><%= s.getMastersPercent() > 0 ? s.getMastersPercent()+"%" : "N/A" %></p></div>
            <div class="detail-item"><label>Skills</label><p><%= s.getSkills()!=null?s.getSkills():"-" %></p></div>
            <div class="detail-item"><label>Date of Birth</label><p><%= s.getDob()!=null?s.getDob():"-" %></p></div>
          </div>
          <% if(s.getResumePath()!=null && !s.getResumePath().isEmpty()){ %>
          <div style="margin-top:16px;">
            <a href="${pageContext.request.contextPath}/<%= s.getResumePath() %>" target="_blank" class="btn btn-info btn-sm">📄 View Resume</a>
          </div>
          <% } %>
        </div>
      </div>

      <!-- Edit Form -->
      <div class="card">
        <div class="card-header"><h3>Edit Student Details</h3></div>
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/admin/action/update-student">
            <input type="hidden" name="studentId" value="<%= s.getId() %>">
            <div class="form-row">
              <div class="form-group"><label>Name</label><input type="text" name="name" class="form-control" value="<%= s.getName() %>" required></div>
              <div class="form-group"><label>Phone</label><input type="text" name="phone" class="form-control" value="<%= s.getPhone()!=null?s.getPhone():"" %>"></div>
            </div>
            <div class="form-row">
              <div class="form-group"><label>Department</label>
                <select name="department" class="form-control">
                  <% String[] depts={"Computer Science","Electronics","Mechanical","Civil","Electrical","Information Technology","Chemical","Biotechnology"};
                     for(String d: depts){ %>
                  <option value="<%= d %>" <%= d.equals(s.getDepartment())?"selected":"" %>><%= d %></option>
                  <% } %>
                </select>
              </div>
              <div class="form-group"><label>Batch</label><input type="text" name="batch" class="form-control" value="<%= s.getBatch()!=null?s.getBatch():"" %>"></div>
            </div>
            <div class="form-row">
              <div class="form-group"><label>Roll Number</label><input type="text" name="rollNumber" class="form-control" value="<%= s.getRollNumber()!=null?s.getRollNumber():"" %>"></div>
              <div class="form-group"><label>CGPA</label><input type="number" name="cgpa" step="0.01" min="0" max="10" class="form-control" value="<%= s.getCgpa() %>"></div>
            </div>
            <div class="form-row three">
              <div class="form-group"><label>10th %</label><input type="number" name="tenthPercent" step="0.01" class="form-control" value="<%= s.getTenthPercent() %>"></div>
              <div class="form-group"><label>12th %</label><input type="number" name="twelfthPercent" step="0.01" class="form-control" value="<%= s.getTwelfthPercent() %>"></div>
              <div class="form-group"><label>Graduation %</label><input type="number" name="gradPercent" step="0.01" class="form-control" value="<%= s.getGradPercent() %>"></div>
            </div>
            <div class="form-group">
              <label>Masters %</label><input type="number" name="mastersPercent" step="0.01" class="form-control" value="<%= s.getMastersPercent() %>" style="max-width:200px;">
            </div>
            <div class="form-check" style="margin-bottom:18px;">
              <input type="checkbox" name="isActive" id="isActive" <%= s.isActive()?"checked":"" %>>
              <label for="isActive" style="font-size:14px;font-weight:500;">Account Active</label>
            </div>
            <div style="display:flex;gap:10px;">
              <button type="submit" class="btn btn-primary">💾 Save Changes</button>
              <a href="${pageContext.request.contextPath}/admin/action/students" class="btn btn-outline">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
