<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.dao.*,com.campus.model.*,java.util.*" %>
<%
    Integer companyId = (Integer) session.getAttribute("companyId");
    if(companyId==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=company");return;}
    Company co = (Company) session.getAttribute("companyObj");
    if(co==null) co = new CompanyDAO().getById(companyId);
    if(co==null){session.invalidate();response.sendRedirect(request.getContextPath()+"/login.jsp?role=company");return;}

    DriveDAO dDao = new DriveDAO();
    ApplicationDAO aDao = new ApplicationDAO();
    List<Drive> myDrives = dDao.getByCompany(companyId);
    int totalDrives   = myDrives.size();
    int published     = (int) myDrives.stream().filter(d->"published".equals(d.getStatus())).count();
    int pending       = (int) myDrives.stream().filter(d->"pending_approval".equals(d.getStatus())).count();
    int totalApps     = myDrives.stream().mapToInt(Drive::getApplicationCount).sum();

    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
    String error=(String)session.getAttribute("error"); session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Company Dashboard</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Company Dashboard</div><div style="font-size:12px;color:#888;">Welcome, <%= co.getName() %></div></div>
      <div class="topbar-right">
        <span class="badge badge-success"><%= co.getStatus() %></span>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
      </div>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>
      <% if(error!=null){ %><div class="alert alert-danger auto-dismiss">⚠️ <%= error %></div><% } %>

      <!-- Stats -->
      <div class="stats-grid">
        <div class="stat-card"><div class="stat-icon">📋</div>
          <div><div class="stat-value" data-count="<%= totalDrives %>"><%= totalDrives %></div><div class="stat-label">Total Drives</div></div></div>
        <div class="stat-card green"><div class="stat-icon">✅</div>
          <div><div class="stat-value" data-count="<%= published %>"><%= published %></div><div class="stat-label">Published</div></div></div>
        <div class="stat-card orange"><div class="stat-icon">🕐</div>
          <div><div class="stat-value" data-count="<%= pending %>"><%= pending %></div><div class="stat-label">Pending Approval</div></div></div>
        <div class="stat-card blue"><div class="stat-icon">📩</div>
          <div><div class="stat-value" data-count="<%= totalApps %>"><%= totalApps %></div><div class="stat-label">Total Applications</div></div></div>
      </div>

      <!-- Company Info -->
      <div class="card" style="margin-bottom:20px;">
        <div class="card-header"><h3>Company Profile</h3></div>
        <div class="card-body">
          <div class="detail-grid">
            <div class="detail-item"><label>Company Name</label><p><%= co.getName() %></p></div>
            <div class="detail-item"><label>Industry</label><p><%= co.getIndustry() %></p></div>
            <div class="detail-item"><label>Email</label><p><%= co.getEmail() %></p></div>
            <div class="detail-item"><label>Contact Person</label><p><%= co.getContactPerson()!=null?co.getContactPerson():"-" %></p></div>
            <div class="detail-item"><label>Phone</label><p><%= co.getContactPhone()!=null?co.getContactPhone():"-" %></p></div>
            <div class="detail-item"><label>Website</label><p><% if(co.getWebsite()!=null){ %><a href="<%= co.getWebsite() %>" target="_blank"><%= co.getWebsite() %></a><% }else{ %>-<% } %></p></div>
          </div>
          <% if(co.getDescription()!=null){ %><p style="margin-top:14px;color:#555;"><%= co.getDescription() %></p><% } %>
        </div>
      </div>

      <!-- Recent Drives -->
      <div class="card">
        <div class="card-header"><h3>My Drives</h3><a href="${pageContext.request.contextPath}/company/action/create-drive" class="btn btn-primary btn-sm">+ Post New Drive</a></div>
        <div class="table-responsive">
          <table>
            <thead><tr><th>Title</th><th>Role</th><th>Applications</th><th>Status</th><th>Deadline</th><th>Action</th></tr></thead>
            <tbody>
            <% if(myDrives.isEmpty()){ %>
            <tr><td colspan="6" style="text-align:center;padding:40px;color:#888;">No drives posted yet. <a href="${pageContext.request.contextPath}/company/action/create-drive">Post your first drive →</a></td></tr>
            <% } %>
            <% for(Drive d: myDrives){ %>
            <tr>
              <td style="font-weight:600;"><%= d.getTitle() %></td>
              <td><%= d.getRole() %></td>
              <td><span class="badge badge-primary"><%= d.getApplicationCount() %></span></td>
              <td>
                <% String st=d.getStatus(); String bc="badge-muted";
                   if("published".equals(st)) bc="badge-success";
                   else if("pending_approval".equals(st)) bc="badge-warning";
                   else if("closed".equals(st)||"cancelled".equals(st)) bc="badge-danger"; %>
                <span class="badge <%= bc %>"><%= st.replace("_"," ") %></span>
              </td>
              <td style="font-size:13px;"><%= d.getApplicationDeadline()!=null?d.getApplicationDeadline():"-" %></td>
              <td>
                <% if("published".equals(d.getStatus())){ %>
                <a href="${pageContext.request.contextPath}/company/action/applied-students?driveId=<%= d.getId() %>" class="btn btn-sm btn-primary">View Applicants</a>
                <% } else { %>
                <span class="badge badge-muted">Awaiting Approval</span>
                <% } %>
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
