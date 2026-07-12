<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    if(session.getAttribute("adminId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=admin");return;}
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    if(companies==null) companies = new ArrayList<>();
    String error=(String)session.getAttribute("error"); session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Create Drive - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Create Placement Drive</div><div style="font-size:12px;color:#888;"><a href="${pageContext.request.contextPath}/admin/action/drives">← Back to Drives</a></div></div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <% if(error!=null){ %><div class="alert alert-danger auto-dismiss">⚠️ <%= error %></div><% } %>
      <div class="card">
        <div class="card-header"><h3>New Drive Details</h3></div>
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/admin/action/create-drive">
            <!-- Basic Info -->
            <div class="form-section">
              <h4>Drive Information</h4>
              <div class="form-group"><label>Drive Title *</label><input type="text" name="title" class="form-control" required placeholder="e.g. TechCorp Campus Placement 2024"></div>
              <div class="form-row">
                <div class="form-group">
                  <label>Company (optional — leave blank for university-hosted drive)</label>
                  <select name="companyId" class="form-control">
                    <option value="">-- University / Department Drive --</option>
                    <% for(Company co: companies){ %>
                    <option value="<%= co.getId() %>"><%= co.getName() %> (<%= co.getIndustry() %>)</option>
                    <% } %>
                  </select>
                </div>
                <div class="form-group"><label>Job Role / Designation *</label><input type="text" name="role" class="form-control" required placeholder="e.g. Software Engineer"></div>
              </div>
              <div class="form-row">
                <div class="form-group"><label>Salary / Package</label><input type="text" name="salary" class="form-control" placeholder="e.g. 6-8 LPA"></div>
                <div class="form-group"><label>Job Location</label><input type="text" name="location" class="form-control" placeholder="e.g. Bangalore"></div>
              </div>
              <div class="form-row">
                <div class="form-group"><label>Drive Type</label>
                  <select name="driveType" class="form-control">
                    <option value="on-campus">On Campus</option>
                    <option value="off-campus">Off Campus</option>
                    <option value="virtual">Virtual</option>
                  </select>
                </div>
                <div class="form-group"><label>Application Deadline *</label><input type="date" name="deadline" class="form-control" required></div>
              </div>
              <div class="form-group"><label>Drive / Interview Date</label><input type="date" name="driveDate" class="form-control"></div>
              <div class="form-group"><label>Job Description</label><textarea name="description" class="form-control" rows="4" placeholder="Describe the role, responsibilities, and benefits..."></textarea></div>
            </div>

            <!-- Eligibility Criteria -->
            <div class="form-section">
              <h4>Eligibility Criteria</h4>
              <p style="color:#888;font-size:13px;margin-bottom:14px;">Set 0 to skip a criterion. Students meeting ALL criteria will be auto-marked eligible.</p>
              <div class="form-row three">
                <div class="form-group"><label>Minimum CGPA</label><input type="number" name="minCgpa" step="0.01" min="0" max="10" class="form-control" value="0" placeholder="e.g. 7.0"></div>
                <div class="form-group"><label>Min 10th %</label><input type="number" name="minTenth" step="0.01" class="form-control" value="0" placeholder="e.g. 70"></div>
                <div class="form-group"><label>Min 12th %</label><input type="number" name="minTwelfth" step="0.01" class="form-control" value="0" placeholder="e.g. 70"></div>
              </div>
              <div class="form-group"><label>Min Graduation %</label><input type="number" name="minGrad" step="0.01" class="form-control" value="0" placeholder="e.g. 65" style="max-width:200px;"></div>
              <div class="form-row">
                <div class="form-group">
                  <label>Eligible Batches (comma-separated)</label>
                  <input type="text" name="eligibleBatches" class="form-control" placeholder="e.g. 2024,2025">
                </div>
                <div class="form-group">
                  <label>Eligible Branches (comma-separated)</label>
                  <input type="text" name="eligibleBranches" class="form-control" placeholder="e.g. Computer Science,Electronics">
                </div>
              </div>
            </div>

            <!-- Submit -->
            <div style="display:flex;gap:12px;flex-wrap:wrap;">
              <button type="submit" name="publish" value="true" class="btn btn-success btn-lg">🚀 Create &amp; Publish Drive</button>
              <button type="submit" class="btn btn-outline btn-lg">💾 Save as Draft</button>
              <a href="${pageContext.request.contextPath}/admin/action/drives" class="btn btn-outline btn-lg" style="border-color:#ccc;color:#666;">Cancel</a>
            </div>
            <p style="margin-top:12px;font-size:13px;color:#888;">Publishing will auto-mark eligible students and send them email notifications.</p>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
