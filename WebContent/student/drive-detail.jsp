<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    if(studentId==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=student");return;}
    Drive drive = (Drive) request.getAttribute("drive");
    Boolean applied = (Boolean) request.getAttribute("applied");
    if(drive==null){response.sendRedirect(request.getContextPath()+"/student/action/drives");return;}
    if(applied==null) applied=false;
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
    String error=(String)session.getAttribute("error"); session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%= drive.getTitle() %> - Apply</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Drive Details</div><div style="font-size:12px;color:#888;"><a href="${pageContext.request.contextPath}/student/action/drives">← Back to Drives</a></div></div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>
      <% if(error!=null){ %><div class="alert alert-danger auto-dismiss">⚠️ <%= error %></div><% } %>

      <div style="display:grid;grid-template-columns:2fr 1fr;gap:20px;">
        <!-- Drive Info -->
        <div>
          <div class="card" style="border-top:4px solid #1a237e;margin-bottom:20px;">
            <div class="card-body">
              <h2 style="font-size:22px;font-weight:800;color:#1a237e;margin-bottom:6px;"><%= drive.getTitle() %></h2>
              <div style="display:flex;flex-wrap:wrap;gap:16px;color:#555;font-size:14px;margin-bottom:16px;">
                <span>🏢 <strong><%= drive.getCompanyName()!=null?drive.getCompanyName():"University" %></strong></span>
                <span>💼 <strong><%= drive.getRole() %></strong></span>
                <% if(drive.getSalary()!=null){ %><span style="color:#2e7d32;font-weight:600;">💰 <%= drive.getSalary() %></span><% } %>
                <% if(drive.getLocation()!=null){ %><span>📍 <%= drive.getLocation() %></span><% } %>
                <span style="text-transform:capitalize;">🎫 <%= drive.getDriveType() %></span>
              </div>
              <div style="display:flex;gap:24px;margin-bottom:16px;flex-wrap:wrap;">
                <div><div style="font-size:12px;color:#888;">Application Deadline</div><div style="font-weight:700;color:#c62828;"><%= drive.getApplicationDeadline()!=null?drive.getApplicationDeadline():"N/A" %></div></div>
                <% if(drive.getDriveDate()!=null){ %>
                <div><div style="font-size:12px;color:#888;">Drive Date</div><div style="font-weight:700;"><%= drive.getDriveDate() %></div></div>
                <% } %>
                <div><div style="font-size:12px;color:#888;">Applicants</div><div style="font-weight:700;"><%= drive.getApplicationCount() %></div></div>
              </div>
              <% if(drive.getDescription()!=null && !drive.getDescription().isEmpty()){ %>
              <div style="background:#f9f9fb;border-radius:8px;padding:16px;">
                <strong style="font-size:13px;color:#666;">Job Description</strong>
                <p style="margin-top:8px;font-size:14px;line-height:1.7;color:#444;"><%= drive.getDescription().replace("\n","<br>") %></p>
              </div>
              <% } %>
            </div>
          </div>

          <!-- Eligibility -->
          <div class="card">
            <div class="card-header"><h3>Eligibility Criteria</h3></div>
            <div class="card-body">
              <div class="detail-grid">
                <div class="detail-item"><label>Minimum CGPA</label><p><%= drive.getMinCgpa() %></p></div>
                <div class="detail-item"><label>Minimum 10th %</label><p><%= drive.getMinTenth() %>%</p></div>
                <div class="detail-item"><label>Minimum 12th %</label><p><%= drive.getMinTwelfth() %>%</p></div>
                <div class="detail-item"><label>Minimum Graduation %</label><p><%= drive.getMinGrad() > 0 ? drive.getMinGrad()+"%" : "N/A" %></p></div>
                <div class="detail-item"><label>Eligible Batches</label><p><%= drive.getEligibleBatches()!=null && !drive.getEligibleBatches().isEmpty() ? drive.getEligibleBatches() : "All" %></p></div>
                <div class="detail-item"><label>Eligible Branches</label><p><%= drive.getEligibleBranches()!=null && !drive.getEligibleBranches().isEmpty() ? drive.getEligibleBranches() : "All" %></p></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Apply Card -->
        <div>
          <div class="card" style="position:sticky;top:20px;">
            <div class="card-header"><h3>Apply for this Drive</h3></div>
            <div class="card-body">
              <% if(applied){ %>
              <div class="alert alert-success">✅ You have already applied for this drive!</div>
              <a href="${pageContext.request.contextPath}/student/action/applications" class="btn btn-outline" style="width:100%;justify-content:center;">View My Applications</a>
              <% } else { %>
              <form method="post" action="${pageContext.request.contextPath}/student/action/apply">
                <input type="hidden" name="driveId" value="<%= drive.getId() %>">
                <div class="form-group">
                  <label>Cover Letter <span style="color:#888;">(optional)</span></label>
                  <textarea name="coverLetter" class="form-control" rows="6" placeholder="Tell us why you are a great fit for this role..."></textarea>
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:13px;"
                        data-confirm="Submit your application for this drive?">
                  🚀 Submit Application
                </button>
              </form>
              <p style="color:#888;font-size:12px;margin-top:12px;text-align:center;">
                Your profile details and resume will be shared with the recruiter.
              </p>
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
