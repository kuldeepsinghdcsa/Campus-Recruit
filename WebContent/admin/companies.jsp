<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    if(session.getAttribute("adminId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=admin");return;}
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    List<Company> pendingCo = (List<Company>) request.getAttribute("pendingCompanies");
    if(companies==null) companies=new ArrayList<>();
    if(pendingCo==null) pendingCo=new ArrayList<>();
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Companies - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Manage Companies</div><div style="font-size:12px;color:#888;"><%= companies.size() %> companies registered</div></div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>

      <% if(!pendingCo.isEmpty()){ %>
      <div class="card" style="border-left:4px solid #f57f17;margin-bottom:20px;">
        <div class="card-header"><h3>⏳ Pending Approvals (<%= pendingCo.size() %>)</h3></div>
        <div class="table-responsive">
          <table>
            <thead><tr><th>Company</th><th>Industry</th><th>Email</th><th>Contact Person</th><th>Registered</th><th>Action</th></tr></thead>
            <tbody>
            <% for(Company co: pendingCo){ %>
            <tr>
              <td style="font-weight:600;"><%= co.getName() %></td>
              <td><%= co.getIndustry() %></td>
              <td><%= co.getEmail() %></td>
              <td><%= co.getContactPerson()!=null?co.getContactPerson():"-" %></td>
              <td style="font-size:12px;color:#888;"><%= co.getCreatedAt()!=null?co.getCreatedAt().toString().substring(0,10):"" %></td>
              <td>
                <form method="post" action="${pageContext.request.contextPath}/admin/action/approve-company" style="display:flex;gap:6px;">
                  <input type="hidden" name="companyId" value="<%= co.getId() %>">
                  <button name="status" value="approved" class="btn btn-success btn-sm">✅ Approve</button>
                  <button name="status" value="rejected" class="btn btn-danger btn-sm" data-confirm="Reject this company?">❌ Reject</button>
                </form>
              </td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>
      <% } %>

      <div class="card">
        <div class="card-header">
          <h3>All Registered Companies</h3>
          <input type="text" id="tableSearch" class="form-control" placeholder="🔍 Search..." style="width:220px;">
        </div>
        <div class="table-responsive">
          <table class="searchable-table">
            <thead><tr><th>#</th><th>Company</th><th>Industry</th><th>Website</th><th>Contact</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% int i=1; for(Company co: companies){ %>
            <tr>
              <td><%= i++ %></td>
              <td style="font-weight:600;"><%= co.getName() %></td>
              <td><%= co.getIndustry() %></td>
              <td><% if(co.getWebsite()!=null && !co.getWebsite().isEmpty()){ %><a href="<%= co.getWebsite() %>" target="_blank" style="font-size:12px;">🌐 Visit</a><% }else{ %>-<% } %></td>
              <td style="font-size:13px;"><%= co.getContactPerson()!=null?co.getContactPerson():"-" %><% if(co.getContactPhone()!=null){ %><br><span style="color:#888;font-size:12px;"><%= co.getContactPhone() %></span><% } %></td>
              <td>
                <% String cs=co.getStatus(); String bc="badge-muted";
                   if("approved".equals(cs)) bc="badge-success";
                   else if("pending".equals(cs)) bc="badge-warning";
                   else if("rejected".equals(cs)) bc="badge-danger"; %>
                <span class="badge <%= bc %>"><%= cs %></span>
              </td>
              <td>
                <% if(!"approved".equals(co.getStatus())){ %>
                <form method="post" action="${pageContext.request.contextPath}/admin/action/approve-company" style="display:inline;">
                  <input type="hidden" name="companyId" value="<%= co.getId() %>">
                  <button name="status" value="approved" class="btn btn-success btn-sm">Approve</button>
                </form>
                <% } else { %>
                <form method="post" action="${pageContext.request.contextPath}/admin/action/approve-company" style="display:inline;">
                  <input type="hidden" name="companyId" value="<%= co.getId() %>">
                  <button name="status" value="rejected" class="btn btn-danger btn-sm" data-confirm="Suspend this company?">Suspend</button>
                </form>
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
