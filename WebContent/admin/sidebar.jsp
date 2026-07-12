<%@ page contentType="text/html;charset=UTF-8" %>
<div class="sidebar">
  <div class="sidebar-brand">
    <h2>🎓 CampusRecruit</h2>
    <span>Admin Portal</span>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section">Main</div>
    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
      <span class="icon">📊</span><span>Dashboard</span>
    </a>
    <div class="nav-section">Drives</div>
    <a href="${pageContext.request.contextPath}/admin/action/create-drive">
      <span class="icon">➕</span><span>Create Drive</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/action/drives">
      <span class="icon">📋</span><span>All Drives</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/action/pending-drives">
      <span class="icon">🕐</span><span>Pending Approvals</span>
    </a>
    <div class="nav-section">People</div>
    <a href="${pageContext.request.contextPath}/admin/action/students">
      <span class="icon">🎓</span><span>Students</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/action/companies">
      <span class="icon">🏢</span><span>Companies</span>
    </a>
  </nav>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/LogoutServlet">🚪 Logout</a>
  </div>
</div>
