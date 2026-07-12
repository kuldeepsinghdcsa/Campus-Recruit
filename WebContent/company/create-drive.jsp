<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if(session.getAttribute("companyId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=company");return;}
    String error=(String)session.getAttribute("error"); session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Post Drive - Company</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Post a Placement Drive</div><div style="font-size:12px;color:#888;"><a href="${pageContext.request.contextPath}/company/action/drives">← Back to My Drives</a></div></div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <% if(error!=null){ %><div class="alert alert-danger auto-dismiss">⚠️ <%= error %></div><% } %>
      <div class="alert alert-info">ℹ️ Your drive request will be reviewed by the admin before it is published to students.</div>
      <div class="card">
        <div class="card-header"><h3>Drive Details</h3></div>
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/company/action/create-drive">
            <div class="form-section">
              <h4>Job Information</h4>
              <div class="form-group"><label>Drive Title *</label><input type="text" name="title" class="form-control" required placeholder="e.g. Software Engineer Campus Drive 2024"></div>
              <div class="form-row">
                <div class="form-group"><label>Job Role / Designation *</label><input type="text" name="role" class="form-control" required placeholder="e.g. Software Engineer, Data Analyst"></div>
                <div class="form-group"><label>Salary / Package</label><input type="text" name="salary" class="form-control" placeholder="e.g. 6-8 LPA"></div>
              </div>
              <div class="form-row">
                <div class="form-group"><label>Job Location *</label><input type="text" name="location" class="form-control" required placeholder="e.g. Bangalore, Pune"></div>
                <div class="form-group"><label>Drive Type</label>
                  <select name="driveType" class="form-control">
                    <option value="on-campus">On Campus</option>
                    <option value="off-campus">Off Campus</option>
                    <option value="virtual">Virtual</option>
                  </select>
                </div>
              </div>
              <div class="form-row">
                <div class="form-group"><label>Application Deadline *</label><input type="date" name="deadline" class="form-control" required></div>
                <div class="form-group"><label>Drive / Interview Date</label><input type="date" name="driveDate" class="form-control"></div>
              </div>
              <div class="form-group"><label>Job Description *</label><textarea name="description" class="form-control" rows="5" required placeholder="Describe the role, key responsibilities, and what you're looking for..."></textarea></div>
            </div>

            <div class="form-section">
              <h4>Eligibility Requirements</h4>
              <p style="color:#888;font-size:13px;margin-bottom:14px;">Admin will use these criteria to identify and notify eligible students.</p>
              <div class="form-row three">
                <div class="form-group"><label>Minimum CGPA</label><input type="number" name="minCgpa" step="0.01" min="0" max="10" class="form-control" value="0"></div>
                <div class="form-group"><label>Minimum 10th %</label><input type="number" name="minTenth" step="0.01" class="form-control" value="0"></div>
                <div class="form-group"><label>Minimum 12th %</label><input type="number" name="minTwelfth" step="0.01" class="form-control" value="0"></div>
              </div>
              <div class="form-group"><label>Minimum Graduation %</label><input type="number" name="minGrad" step="0.01" class="form-control" value="0" style="max-width:200px;"></div>
              <div class="form-row">
                <div class="form-group"><label>Eligible Batches (comma-separated)</label><input type="text" name="eligibleBatches" class="form-control" placeholder="e.g. 2024,2025"></div>
                <div class="form-group"><label>Eligible Branches (comma-separated)</label><input type="text" name="eligibleBranches" class="form-control" placeholder="e.g. Computer Science,Electronics"></div>
              </div>
            </div>

            <div style="display:flex;gap:12px;">
              <button type="submit" class="btn btn-primary btn-lg">📤 Send Request to Admin</button>
              <a href="${pageContext.request.contextPath}/company/action/drives" class="btn btn-outline btn-lg">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
