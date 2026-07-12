<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    if(session.getAttribute("adminId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=admin");return;}
    List<Drive> drives = (List<Drive>) request.getAttribute("drives");
    if(drives==null) drives = new ArrayList<>();
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>All Drives - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Manage Drives</div><div style="font-size:12px;color:#888;"><%= drives.size() %> total drives</div></div>
      <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/admin/action/create-drive" class="btn btn-primary btn-sm">+ Create Drive</a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
      </div>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>
      <div class="card">
        <div class="card-header">
          <h3>All Placement Drives</h3>
          <input type="text" id="tableSearch" class="form-control" placeholder="🔍 Search drives..." style="width:220px;">
        </div>
        <div class="table-responsive">
          <table class="searchable-table">
            <thead>
              <tr><th>#</th><th>Title</th><th>Company</th><th>Role</th><th>Salary</th><th>Deadline</th><th>Applied</th><th>Eligible</th><th>Status</th><th>Action</th></tr>
            </thead>
            <tbody>
            <% if(drives.isEmpty()){ %>
            <tr><td colspan="10" style="text-align:center;padding:40px;color:#888;">No drives found. <a href="${pageContext.request.contextPath}/admin/action/create-drive">Create one →</a></td></tr>
            <% } %>
            <% int i=1; for(Drive d: drives){ %>
            <tr>
              <td style="color:#888;font-size:12px;"><%= i++ %></td>
              <td style="font-weight:600;max-width:200px;"><%= d.getTitle() %></td>
              <td><%= d.getCompanyName()!=null?d.getCompanyName():"University" %></td>
              <td><%= d.getRole() %></td>
              <td style="color:#2e7d32;font-weight:600;"><%= d.getSalary()!=null?d.getSalary():"-" %></td>
              <td><% if(d.getApplicationDeadline()!=null){ %><span style="font-size:13px;"><%= d.getApplicationDeadline() %></span><% }else{ %>-<% } %></td>
              <td><span class="badge badge-primary"><%= d.getApplicationCount() %></span></td>
              <td><span class="badge badge-info"><%= d.getEligibleCount() %></span></td>
              <td>
                <% String st=d.getStatus(); String bc="badge-muted";
                   if("published".equals(st)) bc="badge-success";
                   else if("pending_approval".equals(st)) bc="badge-warning";
                   else if("closed".equals(st)||"cancelled".equals(st)) bc="badge-danger";
                   else if("draft".equals(st)) bc="badge-muted"; %>
                <span class="badge <%= bc %>"><%= st.replace("_"," ") %></span>
              </td>
              <td><a href="${pageContext.request.contextPath}/admin/action/drive-detail?id=<%= d.getId() %>" class="btn btn-sm btn-primary">View</a></td>
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
