<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    if(session.getAttribute("adminId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=admin");return;}
    List<Drive> pendingDrives = (List<Drive>) request.getAttribute("pendingDrives");
    if(pendingDrives==null) pendingDrives=new ArrayList<>();
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Pending Drive Approvals - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Pending Drive Approvals</div>
        <div style="font-size:12px;color:#888;"><%= pendingDrives.size() %> drives awaiting approval</div></div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>
      <% if(pendingDrives.isEmpty()){ %>
      <div class="card"><div class="card-body">
        <div class="empty-state"><div class="icon">✅</div><h4>No Pending Approvals</h4><p>All company drive requests have been reviewed.</p></div>
      </div></div>
      <% } else { %>
      <div class="drives-grid">
        <% for(Drive d: pendingDrives){ %>
        <div class="drive-card">
          <div class="drive-card-header">
            <h4><%= d.getTitle() %></h4>
            <div class="company">🏢 <%= d.getCompanyName()!=null?d.getCompanyName():"Company" %></div>
          </div>
          <div class="drive-card-body">
            <div class="drive-meta">
              <span>💼 <%= d.getRole() %></span>
              <% if(d.getSalary()!=null){ %><span style="color:#2e7d32;font-weight:600;">💰 <%= d.getSalary() %></span><% } %>
              <% if(d.getLocation()!=null){ %><span>📍 <%= d.getLocation() %></span><% } %>
            </div>
            <div style="margin-bottom:10px;">
              <div style="font-size:12px;color:#888;margin-bottom:4px;">Eligibility Criteria</div>
              <div style="font-size:13px;">
                CGPA ≥ <strong><%= d.getMinCgpa() %></strong> &nbsp;|&nbsp;
                10th ≥ <strong><%= d.getMinTenth() %>%</strong> &nbsp;|&nbsp;
                12th ≥ <strong><%= d.getMinTwelfth() %>%</strong>
              </div>
            </div>
            <div style="font-size:12px;color:#888;">
              Deadline: <strong><%= d.getApplicationDeadline()!=null?d.getApplicationDeadline():"N/A" %></strong>
            </div>
            <% if(d.getDescription()!=null){ %>
            <p style="font-size:13px;color:#666;margin-top:10px;line-height:1.5;"><%= d.getDescription().length()>120?d.getDescription().substring(0,120)+"...":d.getDescription() %></p>
            <% } %>
          </div>
          <div class="drive-card-footer">
            <a href="${pageContext.request.contextPath}/admin/action/drive-detail?id=<%= d.getId() %>" class="btn btn-sm btn-outline">View Details</a>
            <form method="post" action="${pageContext.request.contextPath}/admin/action/approve-drive" style="display:flex;gap:6px;">
              <input type="hidden" name="driveId" value="<%= d.getId() %>">
              <button name="status" value="published" class="btn btn-sm btn-success"
                      data-confirm="Approve and publish this drive? Eligible students will be notified.">✅ Approve &amp; Publish</button>
              <button name="status" value="cancelled" class="btn btn-sm btn-danger"
                      data-confirm="Reject this drive request?">❌ Reject</button>
            </form>
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
