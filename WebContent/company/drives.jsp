<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    if(session.getAttribute("companyId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=company");return;}
    List<Drive> drives = (List<Drive>) request.getAttribute("drives");
    if(drives==null) drives=new ArrayList<>();
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Drives - Company</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">My Drives</div><div style="font-size:12px;color:#888;"><%= drives.size() %> drives posted</div></div>
      <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/company/action/create-drive" class="btn btn-primary btn-sm">+ Post Drive</a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
      </div>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>
      <% if(drives.isEmpty()){ %>
      <div class="card"><div class="card-body">
        <div class="empty-state"><div class="icon">📋</div><h4>No Drives Posted Yet</h4><p>Post your first placement drive to start receiving applications.</p>
          <a href="${pageContext.request.contextPath}/company/action/create-drive" class="btn btn-primary" style="margin-top:16px;">+ Post Drive</a></div>
      </div></div>
      <% } else { %>
      <div class="drives-grid">
        <% for(Drive d: drives){ %>
        <div class="drive-card">
          <div class="drive-card-header">
            <h4><%= d.getTitle() %></h4>
            <div class="company">📅 Created <%= d.getCreatedAt()!=null?d.getCreatedAt().toString().substring(0,10):"" %></div>
          </div>
          <div class="drive-card-body">
            <div class="drive-meta">
              <span>💼 <%= d.getRole() %></span>
              <% if(d.getSalary()!=null){ %><span style="color:#2e7d32;font-weight:600;">💰 <%= d.getSalary() %></span><% } %>
              <% if(d.getLocation()!=null){ %><span>📍 <%= d.getLocation() %></span><% } %>
            </div>
            <div style="display:flex;gap:16px;margin-bottom:10px;font-size:13px;">
              <div><span style="color:#888;">Applications:</span> <strong><%= d.getApplicationCount() %></strong></div>
              <div><span style="color:#888;">Deadline:</span> <strong><%= d.getApplicationDeadline()!=null?d.getApplicationDeadline():"N/A" %></strong></div>
            </div>
            <% String st=d.getStatus(); String bc="badge-muted";
               if("published".equals(st)) bc="badge-success";
               else if("pending_approval".equals(st)) bc="badge-warning";
               else if("closed".equals(st)||"cancelled".equals(st)) bc="badge-danger"; %>
            <span class="badge <%= bc %>"><%= st.replace("_"," ").toUpperCase() %></span>
            <% if("pending_approval".equals(st)){ %>
            <p style="font-size:12px;color:#f57f17;margin-top:8px;">⏳ Waiting for admin to approve and publish this drive.</p>
            <% } %>
          </div>
          <div class="drive-card-footer">
            <% if("published".equals(st)){ %>
            <a href="${pageContext.request.contextPath}/company/action/applied-students?driveId=<%= d.getId() %>" class="btn btn-sm btn-primary">👥 View Applicants (<%= d.getApplicationCount() %>)</a>
            <% } %>
          </div>
        </div>
        <% } %>
      </div>
      <% } %>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
