<%@ page contentType="text/html;charset=UTF-8" %>
<div class="sidebar">
  <div class="sidebar-brand">
    <h2>🏢 CampusRecruit</h2>
    <span>Company Portal</span>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section">Main</div>
    <a href="${pageContext.request.contextPath}/company/dashboard.jsp">
      <span class="icon">📊</span><span>Dashboard</span>
    </a>
    <div class="nav-section">Drives</div>
    <a href="${pageContext.request.contextPath}/company/action/create-drive">
      <span class="icon">➕</span><span>Post a Drive</span>
    </a>
    <a href="${pageContext.request.contextPath}/company/action/drives">
      <span class="icon">📋</span><span>My Drives</span>
    </a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/LogoutServlet">🚪 Logout</a>
  </div>
</div>
