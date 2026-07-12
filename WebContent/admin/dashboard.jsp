<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.dao.*,com.campus.model.*,java.util.*" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if(adminId == null){ response.sendRedirect(request.getContextPath()+"/login.jsp?role=admin"); return; }
    Admin admin = (Admin) session.getAttribute("adminObj");
    if(admin == null) admin = new AdminDAO().getById(adminId);
    if(admin==null){session.invalidate();response.sendRedirect(request.getContextPath()+"/login.jsp?role=admin");return;}

    StudentDAO sDao = new StudentDAO();
    DriveDAO dDao = new DriveDAO();
    CompanyDAO cDao = new CompanyDAO();
    ApplicationDAO aDao = new ApplicationDAO();

    int totalStudents  = sDao.getTotalCount();
    int placedStudents = sDao.getPlacedCount();
    int totalDrives    = dDao.getTotalCount();
    int activeDrives   = dDao.getActiveCount();
    int totalCompanies = cDao.getTotalCount();
    int totalApps      = aDao.getTotalApplications();

    List<Object[]> byCompany = aDao.getPlacementByCompany();
    List<Object[]> byDept    = aDao.getPlacementByDepartment();

    StringBuilder compLabels = new StringBuilder("[");
    StringBuilder compSel    = new StringBuilder("[");
    StringBuilder compTotal  = new StringBuilder("[");
    for(int i=0;i<byCompany.size();i++){
        Object[] r=byCompany.get(i);
        compLabels.append("\"").append(r[0]).append("\"");
        compTotal.append(r[1]);
        compSel.append(r[2]);
        if(i<byCompany.size()-1){compLabels.append(",");compTotal.append(",");compSel.append(",");}
    }
    compLabels.append("]"); compSel.append("]"); compTotal.append("]");

    StringBuilder deptLabels = new StringBuilder("[");
    StringBuilder deptVals   = new StringBuilder("[");
    for(int i=0;i<byDept.size();i++){
        Object[] r=byDept.get(i);
        deptLabels.append("\"").append(r[0]).append("\"");
        deptVals.append(r[2]);
        if(i<byDept.size()-1){deptLabels.append(",");deptVals.append(",");}
    }
    deptLabels.append("]"); deptVals.append("]");

    List<Drive> pendingDrives = dDao.getPendingApproval();
    List<Company> pendingCo   = cDao.getPending();

    String success = (String) session.getAttribute("success");
    session.removeAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Dashboard - Campus Recruitment</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <!-- Topbar -->
    <div class="topbar">
      <div><div class="topbar-title">Dashboard</div><div style="font-size:12px;color:#888;">Welcome back, <%= admin.getName() %></div></div>
      <div class="topbar-right">
        <span class="topbar-user"><strong><%= admin.getDepartment() %></strong> · <%= admin.getUniversity() %></span>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
      </div>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>

      <!-- Stats -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon">🎓</div>
          <div><div class="stat-value" data-count="<%= totalStudents %>"><%= totalStudents %></div><div class="stat-label">Total Students</div></div>
        </div>
        <div class="stat-card green">
          <div class="stat-icon">✅</div>
          <div><div class="stat-value" data-count="<%= placedStudents %>"><%= placedStudents %></div><div class="stat-label">Placed Students</div></div>
        </div>
        <div class="stat-card orange">
          <div class="stat-icon">📋</div>
          <div><div class="stat-value" data-count="<%= totalDrives %>"><%= totalDrives %></div><div class="stat-label">Total Drives</div></div>
        </div>
        <div class="stat-card blue">
          <div class="stat-icon">📢</div>
          <div><div class="stat-value" data-count="<%= activeDrives %>"><%= activeDrives %></div><div class="stat-label">Active Drives</div></div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">🏢</div>
          <div><div class="stat-value" data-count="<%= totalCompanies %>"><%= totalCompanies %></div><div class="stat-label">Partner Companies</div></div>
        </div>
        <div class="stat-card red">
          <div class="stat-icon">📩</div>
          <div><div class="stat-value" data-count="<%= totalApps %>"><%= totalApps %></div><div class="stat-label">Total Applications</div></div>
        </div>
      </div>

      <!-- Placement % Banner -->
      <div class="card" style="border:none;background:linear-gradient(135deg,#1a237e,#283593);color:#fff;margin-bottom:24px;">
        <div class="card-body" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:16px;">
          <div>
            <div style="font-size:14px;opacity:.8;">Overall Placement Rate</div>
            <div style="font-size:42px;font-weight:800;"><%= totalStudents>0? String.format("%.1f",((double)placedStudents/totalStudents)*100):"0" %>%</div>
            <div style="font-size:13px;opacity:.7;"><%= placedStudents %> of <%= totalStudents %> students placed</div>
          </div>
          <div style="display:flex;gap:12px;flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/admin/action/create-drive" class="btn btn-accent">+ Create Drive</a>
            <a href="${pageContext.request.contextPath}/admin/action/pending-drives" class="btn" style="background:rgba(255,255,255,.2);color:#fff;border:1px solid rgba(255,255,255,.3);">
              Pending (<%= pendingDrives.size() %>)
            </a>
          </div>
        </div>
      </div>

      <!-- Charts -->
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px;">
        <div class="card">
          <div class="card-header"><h3>Placement by Company</h3></div>
          <div class="card-body"><div class="chart-container">
            <canvas id="companyChart"
              data-labels='<%= compLabels %>'
              data-selected='<%= compSel %>'
              data-total='<%= compTotal %>'></canvas>
          </div></div>
        </div>
        <div class="card">
          <div class="card-header"><h3>Placement by Department</h3></div>
          <div class="card-body"><div class="chart-container">
            <canvas id="deptChart"
              data-labels='<%= deptLabels %>'
              data-values='<%= deptVals %>'></canvas>
          </div></div>
        </div>
      </div>

      <!-- Pending Approvals -->
      <% if(!pendingDrives.isEmpty() || !pendingCo.isEmpty()){ %>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px;">
        <% if(!pendingDrives.isEmpty()){ %>
        <div class="card">
          <div class="card-header"><h3>🕐 Pending Drive Approvals</h3><a href="${pageContext.request.contextPath}/admin/action/pending-drives" class="btn btn-sm btn-outline">View All</a></div>
          <div class="card-body" style="padding:0;">
            <% for(Drive drv: pendingDrives){ %>
            <div style="padding:14px 18px;border-bottom:1px solid #f5f5f5;display:flex;justify-content:space-between;align-items:center;">
              <div>
                <div style="font-weight:600;font-size:14px;"><%= drv.getTitle() %></div>
                <div style="font-size:12px;color:#888;"><%= drv.getCompanyName()!=null?drv.getCompanyName():"N/A" %> · <%= drv.getRole() %></div>
              </div>
              <a href="${pageContext.request.contextPath}/admin/action/drive-detail?id=<%= drv.getId() %>" class="btn btn-sm btn-primary">Review</a>
            </div>
            <% } %>
          </div>
        </div>
        <% } %>
        <% if(!pendingCo.isEmpty()){ %>
        <div class="card">
          <div class="card-header"><h3>🏢 Pending Company Registrations</h3><a href="${pageContext.request.contextPath}/admin/action/companies" class="btn btn-sm btn-outline">View All</a></div>
          <div class="card-body" style="padding:0;">
            <% for(Company co: pendingCo){ %>
            <div style="padding:14px 18px;border-bottom:1px solid #f5f5f5;display:flex;justify-content:space-between;align-items:center;">
              <div>
                <div style="font-weight:600;font-size:14px;"><%= co.getName() %></div>
                <div style="font-size:12px;color:#888;"><%= co.getIndustry() %> · <%= co.getEmail() %></div>
              </div>
              <form method="post" action="${pageContext.request.contextPath}/admin/action/approve-company" style="display:flex;gap:6px;">
                <input type="hidden" name="companyId" value="<%= co.getId() %>">
                <button name="status" value="approved" class="btn btn-success btn-sm">Approve</button>
                <button name="status" value="rejected" class="btn btn-danger btn-sm">Reject</button>
              </form>
            </div>
            <% } %>
          </div>
        </div>
        <% } %>
      </div>
      <% } %>

      <!-- Recent Drives -->
      <div class="card">
        <div class="card-header"><h3>Recent Drives</h3><a href="${pageContext.request.contextPath}/admin/action/drives" class="btn btn-sm btn-outline">View All</a></div>
        <div class="card-body" style="padding:0;">
          <div class="table-responsive">
            <table>
              <thead><tr><th>Drive Title</th><th>Company</th><th>Role</th><th>Applications</th><th>Status</th><th>Action</th></tr></thead>
              <tbody>
              <% List<Drive> allDrives = dDao.getAll();
                 int limit = Math.min(5, allDrives.size());
                 for(int i=0;i<limit;i++){
                   Drive d = allDrives.get(i); %>
              <tr>
                <td style="font-weight:600;"><%= d.getTitle() %></td>
                <td><%= d.getCompanyName()!=null?d.getCompanyName():"University" %></td>
                <td><%= d.getRole() %></td>
                <td><span class="badge badge-primary"><%= d.getApplicationCount() %></span></td>
                <td>
                  <% String st=d.getStatus();
                     String bc="badge-muted";
                     if("published".equals(st)) bc="badge-success";
                     else if("pending_approval".equals(st)) bc="badge-warning";
                     else if("closed".equals(st)) bc="badge-danger"; %>
                  <span class="badge <%= bc %>"><%= st %></span>
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
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
