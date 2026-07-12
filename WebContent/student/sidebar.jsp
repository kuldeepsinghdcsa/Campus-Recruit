<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.dao.NotificationDAO" %>
<%
    Integer sid = (Integer) session.getAttribute("studentId");
    int _sbUnread = 0;
    if(sid != null) _sbUnread = new NotificationDAO().getUnreadCount(sid);
%>
<div class="sidebar">
  <div class="sidebar-brand">
    <h2>🎓 CampusRecruit</h2>
    <span>Student Portal</span>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section">Main</div>
    <a href="${pageContext.request.contextPath}/student/dashboard.jsp">
      <span class="icon">📊</span><span>Dashboard</span>
    </a>
    <div class="nav-section">Placement</div>
    <a href="${pageContext.request.contextPath}/student/action/drives">
      <span class="icon">📢</span><span>Open Drives</span>
    </a>
    <a href="${pageContext.request.contextPath}/student/action/applications">
      <span class="icon">📋</span><span>My Applications</span>
    </a>
    <div class="nav-section">Account</div>
    <a href="${pageContext.request.contextPath}/student/action/profile">
      <span class="icon">👤</span><span>My Profile</span>
    </a>
    <a href="${pageContext.request.contextPath}/student/action/notifications">
      <span class="icon">🔔</span><span>Notifications <% if(_sbUnread>0){ %><span style="background:#ff6f00;color:#fff;font-size:11px;padding:2px 6px;border-radius:10px;margin-left:4px;"><%= _sbUnread %></span><% } %></span>
    </a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/LogoutServlet">🚪 Logout</a>
  </div>
</div>
