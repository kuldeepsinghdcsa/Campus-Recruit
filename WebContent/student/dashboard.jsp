<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.dao.*,com.campus.model.*,java.util.*" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    if(studentId==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=student");return;}
    Student student = (Student) session.getAttribute("studentObj");
    if(student==null) student = new StudentDAO().getById(studentId);
    if(student==null){session.invalidate();response.sendRedirect(request.getContextPath()+"/login.jsp?role=student");return;}

    DriveDAO dDao = new DriveDAO();
    ApplicationDAO aDao = new ApplicationDAO();
    NotificationDAO nDao = new NotificationDAO();

    List<Drive> drives = dDao.getEligibleForStudent(studentId);
    List<Application> myApps = aDao.getByStudent(studentId);
    int unread = nDao.getUnreadCount(studentId);

    long openDrives    = drives.stream().filter(d -> "published".equals(d.getStatus())).count();
    long eligibleCount = drives.stream().filter(Drive::isEligible).count();
    long appliedCount  = myApps.size();
    long selectedCount = myApps.stream().filter(a->"selected".equals(a.getStatus())).count();

    // Profile completion %
    int pct = 0;
    if(student.getName()!=null && !student.getName().isEmpty()) pct+=15;
    if(student.getPhone()!=null && !student.getPhone().isEmpty()) pct+=10;
    if(student.getDepartment()!=null && !student.getDepartment().isEmpty()) pct+=10;
    if(student.getRollNumber()!=null && !student.getRollNumber().isEmpty()) pct+=10;
    if(student.getCgpa()>0) pct+=15;
    if(student.getTenthPercent()>0) pct+=10;
    if(student.getTwelfthPercent()>0) pct+=10;
    if(student.getSkills()!=null && !student.getSkills().isEmpty()) pct+=10;
    if(student.getResumePath()!=null && !student.getResumePath().isEmpty()) pct+=10;

    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
    String error=(String)session.getAttribute("error"); session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Student Dashboard - Campus Recruitment</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">My Dashboard</div><div style="font-size:12px;color:#888;">Welcome back, <%= student.getName() %></div></div>
      <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/student/action/notifications" style="position:relative;padding:6px 12px;background:#f5f5f5;border-radius:6px;text-decoration:none;color:#333;">
          🔔 <% if(unread>0){ %><span style="position:absolute;top:-4px;right:-4px;background:#ff6f00;color:#fff;font-size:11px;padding:1px 5px;border-radius:8px;"><%= unread %></span><% } %>
        </a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
      </div>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>
      <% if(error!=null){ %><div class="alert alert-danger auto-dismiss">⚠️ <%= error %></div><% } %>

      <!-- Profile Completion Banner -->
      <% if(pct < 80){ %>
      <div class="card" style="border:none;background:linear-gradient(135deg,#ff6f00,#ffa000);color:#fff;margin-bottom:20px;">
        <div class="card-body">
          <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;">
            <div>
              <h3 style="margin-bottom:4px;">Complete your profile to get noticed!</h3>
              <p style="opacity:.85;font-size:14px;">A complete profile increases your chances of being eligible for more drives.</p>
              <div style="margin-top:12px;background:rgba(255,255,255,.3);border-radius:20px;height:8px;width:250px;">
                <div style="background:#fff;height:100%;border-radius:20px;width:<%= pct %>%;transition:.5s;"></div>
              </div>
              <p style="margin-top:6px;font-size:13px;opacity:.8;"><%= pct %>% complete</p>
            </div>
            <a href="${pageContext.request.contextPath}/student/action/profile" class="btn" style="background:#fff;color:#ff6f00;font-weight:700;">Complete Profile →</a>
          </div>
        </div>
      </div>
      <% } %>

      <!-- Stats -->
      <div class="stats-grid">
        <div class="stat-card blue">
          <div class="stat-icon">📢</div>
          <div><div class="stat-value" data-count="<%= openDrives %>"><%= openDrives %></div><div class="stat-label">Open Drives</div></div>
        </div>
        <div class="stat-card green">
          <div class="stat-icon">✅</div>
          <div><div class="stat-value" data-count="<%= eligibleCount %>"><%= eligibleCount %></div><div class="stat-label">Eligible For</div></div>
        </div>
        <div class="stat-card orange">
          <div class="stat-icon">📋</div>
          <div><div class="stat-value" data-count="<%= appliedCount %>"><%= appliedCount %></div><div class="stat-label">Applied</div></div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">🏆</div>
          <div><div class="stat-value" data-count="<%= selectedCount %>"><%= selectedCount %></div><div class="stat-label">Selected</div></div>
        </div>
      </div>

      <div style="display:grid;grid-template-columns:2fr 1fr;gap:20px;">
        <!-- Open Drives -->
        <div class="card">
          <div class="card-header"><h3>Open Drives</h3><a href="${pageContext.request.contextPath}/student/action/drives" class="btn btn-sm btn-outline">View All</a></div>
          <div style="padding:0;">
            <% if(drives.isEmpty()){ %>
            <div class="empty-state" style="padding:30px;"><div class="icon" style="font-size:36px;">📭</div><p>No drives available at the moment.</p></div>
            <% } %>
            <% int limit=Math.min(4,drives.size()); for(int i=0;i<limit;i++){Drive d=drives.get(i); %>
            <div style="padding:16px 18px;border-bottom:1px solid #f5f5f5;display:flex;justify-content:space-between;align-items:center;gap:10px;">
              <div style="flex:1;">
                <div style="font-weight:600;font-size:14px;"><%= d.getTitle() %></div>
                <div style="font-size:12px;color:#888;margin-top:2px;">
                  🏢 <%= d.getCompanyName()!=null?d.getCompanyName():"University" %> &nbsp;·&nbsp;
                  💼 <%= d.getRole() %>
                  <% if(d.getSalary()!=null){ %> &nbsp;·&nbsp; 💰 <%= d.getSalary() %><% } %>
                </div>
                <div style="font-size:11px;color:#c62828;margin-top:3px;">Deadline: <%= d.getApplicationDeadline()!=null?d.getApplicationDeadline():"N/A" %></div>
              </div>
              <div style="display:flex;gap:6px;align-items:center;">
                <% if(d.isEligible()){ %><span class="badge badge-success">Eligible</span><% } %>
                <% if(d.isApplied()){ %><span class="badge badge-primary">Applied</span>
                <% } else if(d.isEligible()){ %>
                <a href="${pageContext.request.contextPath}/student/action/drive-detail?id=<%= d.getId() %>" class="btn btn-sm btn-primary">Apply</a>
                <% }else{ %>
                <a href="${pageContext.request.contextPath}/student/action/drive-detail?id=<%= d.getId() %>" class="btn btn-sm btn-outline">View</a>
                <% } %>
              </div>
            </div>
            <% } %>
          </div>
        </div>

        <!-- Profile Summary -->
        <div>
          <div class="card" style="margin-bottom:16px;">
            <div class="card-header"><h3>My Profile</h3><a href="${pageContext.request.contextPath}/student/action/profile" class="btn btn-sm btn-outline">Edit</a></div>
            <div class="card-body">
              <div style="text-align:center;margin-bottom:16px;">
                <div style="width:64px;height:64px;border-radius:50%;background:#e8eaf6;display:flex;align-items:center;justify-content:center;font-size:28px;margin:0 auto 10px;">👤</div>
                <div style="font-weight:700;font-size:16px;"><%= student.getName() %></div>
                <div style="font-size:13px;color:#888;"><%= student.getEmail() %></div>
                <div style="font-size:13px;color:#888;"><%= student.getDepartment()!=null?student.getDepartment():"" %> · Batch <%= student.getBatch()!=null?student.getBatch():"" %></div>
              </div>
              <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;font-size:13px;">
                <div style="text-align:center;background:#f5f5f5;border-radius:8px;padding:10px;">
                  <div style="font-size:20px;font-weight:700;color:#1a237e;"><%= student.getCgpa() %></div>
                  <div style="color:#888;font-size:11px;">CGPA</div>
                </div>
                <div style="text-align:center;background:#f5f5f5;border-radius:8px;padding:10px;">
                  <div style="font-size:20px;font-weight:700;color:#1a237e;"><%= student.getTenthPercent() %>%</div>
                  <div style="color:#888;font-size:11px;">10th</div>
                </div>
                <div style="text-align:center;background:#f5f5f5;border-radius:8px;padding:10px;">
                  <div style="font-size:20px;font-weight:700;color:#1a237e;"><%= student.getTwelfthPercent() %>%</div>
                  <div style="color:#888;font-size:11px;">12th</div>
                </div>
                <div style="text-align:center;background:#f5f5f5;border-radius:8px;padding:10px;">
                  <div style="font-size:20px;font-weight:700;color:#1a237e;"><%= student.getGradPercent() > 0 ? student.getGradPercent()+"%" : "N/A" %></div>
                  <div style="color:#888;font-size:11px;">Grad</div>
                </div>
              </div>
              <div style="margin-top:12px;">
                <div style="font-size:12px;color:#888;margin-bottom:4px;">Profile Completion</div>
                <div class="progress-bar"><div class="progress-fill profile-progress-fill" data-pct="<%= pct %>" style="width:<%= pct %>%;"></div></div>
                <div style="font-size:12px;color:#888;margin-top:4px;"><%= pct %>%</div>
              </div>
              <% if(student.getResumePath()!=null && !student.getResumePath().isEmpty()){ %>
              <div style="margin-top:12px;"><a href="${pageContext.request.contextPath}/<%= student.getResumePath() %>" target="_blank" class="btn btn-info btn-sm">📄 View Resume</a></div>
              <% } else { %>
              <div style="margin-top:12px;"><a href="${pageContext.request.contextPath}/student/action/profile" class="btn btn-warning btn-sm">📤 Upload Resume</a></div>
              <% } %>
            </div>
          </div>

          <!-- My Applications -->
          <div class="card">
            <div class="card-header"><h3>Recent Applications</h3><a href="${pageContext.request.contextPath}/student/action/applications" class="btn btn-sm btn-outline">All</a></div>
            <div style="padding:0;">
              <% if(myApps.isEmpty()){ %>
              <div style="padding:20px;text-align:center;color:#888;font-size:13px;">No applications yet.</div>
              <% } %>
              <% int al=Math.min(3,myApps.size()); for(int i=0;i<al;i++){Application app=myApps.get(i); %>
              <div style="padding:12px 16px;border-bottom:1px solid #f5f5f5;">
                <div style="font-weight:600;font-size:13px;"><%= app.getDriveTitle() %></div>
                <div style="font-size:12px;color:#888;margin-top:2px;"><%= app.getCompanyName() %></div>
                <div style="margin-top:4px;">
                  <% String as=app.getStatus(); String abc="badge-muted";
                     if("selected".equals(as)) abc="badge-success";
                     else if("shortlisted".equals(as)) abc="badge-info";
                     else if("rejected".equals(as)) abc="badge-danger";
                     else if("applied".equals(as)) abc="badge-primary"; %>
                  <span class="badge <%= abc %>"><%= as %></span>
                </div>
              </div>
              <% } %>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
