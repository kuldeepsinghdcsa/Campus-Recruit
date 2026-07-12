<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    if(session.getAttribute("studentId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=student");return;}
    List<Map<String,Object>> notifications = (List<Map<String,Object>>) request.getAttribute("notifications");
    if(notifications==null) notifications=new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Notifications - Student</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Notifications</div><div style="font-size:12px;color:#888;"><%= notifications.size() %> notifications</div></div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <div class="card">
        <div class="card-header"><h3>🔔 All Notifications</h3></div>
        <div style="padding:0;">
          <% if(notifications.isEmpty()){ %>
          <div class="empty-state" style="padding:60px 20px;">
            <div class="icon">🔔</div><h4>No Notifications</h4>
            <p>You're all caught up! Notifications will appear here when new drives are published for you.</p>
          </div>
          <% } %>
          <% for(Map<String,Object> n: notifications){ %>
          <div class="notif-item <%= Boolean.FALSE.equals(n.get("isRead"))?"unread":"read" %>">
            <div class="notif-dot"></div>
            <div class="notif-content" style="flex:1;">
              <h5><%= n.get("title")!=null?n.get("title"):"Notification" %></h5>
              <p><%= n.get("message") %></p>
              <div class="notif-time"><%= n.get("createdAt")!=null?n.get("createdAt").toString().substring(0,16):"" %></div>
              <% if(n.get("driveId")!=null && (int)n.get("driveId")>0){ %>
              <a href="${pageContext.request.contextPath}/student/action/drive-detail?id=<%= n.get("driveId") %>" class="btn btn-sm btn-primary" style="margin-top:8px;">View Drive →</a>
              <% } %>
            </div>
            <div>
              <span class="badge badge-<%= "drive".equals(n.get("type"))?"info":"muted" %>"><%= n.get("type") %></span>
            </div>
          </div>
          <% } %>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
