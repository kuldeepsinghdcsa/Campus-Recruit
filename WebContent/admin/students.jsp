<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    if(session.getAttribute("adminId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=admin");return;}
    List<Student> students = (List<Student>) request.getAttribute("students");
    if(students==null) students = new ArrayList<>();
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Students - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Manage Students</div><div style="font-size:12px;color:#888;"><%= students.size() %> total students</div></div>
      <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
      </div>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>
      <div class="card">
        <div class="card-header">
          <h3>All Students</h3>
          <div class="search-bar" style="margin:0;">
            <input type="text" id="tableSearch" class="form-control" placeholder="🔍 Search students..." style="width:220px;">
          </div>
        </div>
        <div class="table-responsive">
          <table class="searchable-table">
            <thead>
              <tr>
                <th>#</th><th>Name</th><th>Email</th><th>Dept</th><th>Batch</th>
                <th>CGPA</th><th>10th%</th><th>12th%</th><th>Status</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
            <% if(students.isEmpty()){ %>
            <tr><td colspan="10" style="text-align:center;padding:40px;color:#888;">No students found.</td></tr>
            <% } %>
            <% int idx=1; for(Student s: students){ %>
            <tr>
              <td style="color:#888;font-size:12px;"><%= idx++ %></td>
              <td style="font-weight:600;"><%= s.getName() %></td>
              <td style="font-size:13px;"><%= s.getEmail() %></td>
              <td><%= s.getDepartment()!=null?s.getDepartment():"-" %></td>
              <td><%= s.getBatch()!=null?s.getBatch():"-" %></td>
              <td><strong><%= s.getCgpa() %></strong></td>
              <td><%= s.getTenthPercent() %>%</td>
              <td><%= s.getTwelfthPercent() %>%</td>
              <td>
                <% if(s.isActive()){ %><span class="badge badge-success">Active</span>
                <% }else{ %><span class="badge badge-danger">Inactive</span><% } %>
              </td>
              <td>
                <a href="${pageContext.request.contextPath}/admin/action/student-detail?id=<%= s.getId() %>" class="btn btn-sm btn-primary">View / Edit</a>
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
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
