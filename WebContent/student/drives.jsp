<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    if(studentId==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=student");return;}
    List<Drive> drives = (List<Drive>) request.getAttribute("drives");
    if(drives==null) drives=new ArrayList<>();
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
    String error=(String)session.getAttribute("error"); session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Open Drives - Student</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Open Drives</div><div style="font-size:12px;color:#888;"><%= drives.size() %> drives available</div></div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>
      <% if(error!=null){ %><div class="alert alert-danger auto-dismiss">⚠️ <%= error %></div><% } %>

      <% if(drives.isEmpty()){ %>
      <div class="card"><div class="card-body">
        <div class="empty-state"><div class="icon">📭</div><h4>No Drives Available</h4><p>There are no open placement drives at the moment. Check back soon!</p></div>
      </div></div>
      <% } else { %>
      <div class="drives-grid">
        <% for(Drive d: drives){ %>
        <div class="drive-card">
          <div class="drive-card-header">
            <h4><%= d.getTitle() %></h4>
            <div class="company">🏢 <%= d.getCompanyName()!=null?d.getCompanyName():"University" %></div>
          </div>
          <div class="drive-card-body">
            <div class="drive-meta">
              <span>💼 <%= d.getRole() %></span>
              <% if(d.getSalary()!=null){ %><span style="color:#2e7d32;font-weight:600;">💰 <%= d.getSalary() %></span><% } %>
              <% if(d.getLocation()!=null){ %><span>📍 <%= d.getLocation() %></span><% } %>
              <span style="text-transform:capitalize;">🎫 <%= d.getDriveType()!=null?d.getDriveType():"" %></span>
            </div>

            <div style="margin-bottom:10px;padding:10px;background:#f9f9fb;border-radius:6px;font-size:12px;">
              <div style="color:#888;margin-bottom:4px;font-weight:600;">Eligibility</div>
              CGPA ≥ <strong><%= d.getMinCgpa() %></strong> &nbsp;|&nbsp;
              10th ≥ <strong><%= d.getMinTenth() %>%</strong> &nbsp;|&nbsp;
              12th ≥ <strong><%= d.getMinTwelfth() %>%</strong>
              <% if(d.getEligibleBranches()!=null && !d.getEligibleBranches().isEmpty()){ %>
              <div style="margin-top:4px;">Branches: <strong><%= d.getEligibleBranches() %></strong></div>
              <% } %>
            </div>

            <div style="display:flex;justify-content:space-between;font-size:12px;color:#888;">
              <span>📩 <%= d.getApplicationCount() %> applied</span>
              <span style="color:#c62828;">⏰ Deadline: <%= d.getApplicationDeadline()!=null?d.getApplicationDeadline():"N/A" %></span>
            </div>

            <div style="margin-top:8px;display:flex;gap:8px;flex-wrap:wrap;">
              <% if(d.isEligible()){ %><span class="badge badge-success">✅ You're Eligible</span><% } else { %><span class="badge badge-muted">Not Eligible</span><% } %>
              <% if(d.isApplied()){ %><span class="badge badge-primary">✔ Applied</span><% } %>
            </div>
          </div>
          <div class="drive-card-footer">
            <a href="${pageContext.request.contextPath}/student/action/drive-detail?id=<%= d.getId() %>" class="btn btn-sm btn-outline">Details</a>
            <% if(d.isApplied()){ %>
            <button class="btn btn-sm btn-success" disabled>✔ Applied</button>
            <% } else if(d.isEligible()){ %>
            <a href="${pageContext.request.contextPath}/student/action/drive-detail?id=<%= d.getId() %>" class="btn btn-sm btn-primary">Apply Now →</a>
            <% } else { %>
            <button class="btn btn-sm" style="background:#eee;color:#999;cursor:not-allowed;" disabled>Not Eligible</button>
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
