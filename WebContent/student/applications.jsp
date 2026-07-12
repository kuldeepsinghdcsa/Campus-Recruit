<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    if(session.getAttribute("studentId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=student");return;}
    List<Application> applications = (List<Application>) request.getAttribute("applications");
    if(applications==null) applications=new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Applications - Student</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">My Applications</div><div style="font-size:12px;color:#888;"><%= applications.size() %> total applications</div></div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <% if(applications.isEmpty()){ %>
      <div class="card"><div class="card-body">
        <div class="empty-state"><div class="icon">📋</div><h4>No Applications Yet</h4>
          <p>You haven't applied for any drives. Check open drives to get started!</p>
          <a href="${pageContext.request.contextPath}/student/action/drives" class="btn btn-primary" style="margin-top:16px;">View Open Drives</a>
        </div>
      </div></div>
      <% } else { %>
      <div style="display:flex;flex-direction:column;gap:14px;">
        <% for(Application app: applications){ %>
        <div class="card" style="margin-bottom:0;border-left:4px solid
          <% if("selected".equals(app.getStatus())){ %>var(--success)
          <% }else if("shortlisted".equals(app.getStatus())){ %>var(--info)
          <% }else if("rejected".equals(app.getStatus())){ %>var(--danger)
          <% }else{ %>var(--primary)<% } %>;">
          <div class="card-body" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;">
            <div>
              <h4 style="font-size:16px;font-weight:700;color:#1a237e;margin-bottom:4px;"><%= app.getDriveTitle() %></h4>
              <div style="display:flex;gap:12px;flex-wrap:wrap;font-size:13px;color:#666;">
                <span>🏢 <%= app.getCompanyName() %></span>
                <span>💼 <%= app.getDriveRole() %></span>
                <span>📅 Applied: <%= app.getAppliedAt()!=null?app.getAppliedAt().toString().substring(0,10):"" %></span>
              </div>
            </div>
            <div>
              <% String as=app.getStatus(); String abc="badge-muted"; String icon="📋";
                 if("selected".equals(as)){ abc="badge-success"; icon="🏆"; }
                 else if("shortlisted".equals(as)){ abc="badge-info"; icon="⭐"; }
                 else if("rejected".equals(as)){ abc="badge-danger"; icon="❌"; }
                 else if("applied".equals(as)){ abc="badge-primary"; icon="📤"; } %>
              <span class="badge <%= abc %>" style="font-size:13px;padding:8px 14px;"><%= icon %> <%= as.toUpperCase() %></span>
            </div>
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
