<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*,java.util.*" %>
<%
    if(session.getAttribute("adminId")==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=admin");return;}
    Drive drive = (Drive) request.getAttribute("drive");
    if(drive==null){response.sendRedirect(request.getContextPath()+"/admin/action/drives");return;}
    List<Application> apps = (List<Application>) request.getAttribute("applications");
    List<Student> eligible  = (List<Student>) request.getAttribute("eligibleStudents");
    if(apps==null) apps=new ArrayList<>();
    if(eligible==null) eligible=new ArrayList<>();
    int adminId = (int)session.getAttribute("adminId");
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title><%= drive.getTitle() %> - Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">Drive Detail</div><div style="font-size:12px;color:#888;"><a href="${pageContext.request.contextPath}/admin/action/drives">← Back to Drives</a></div></div>
      <div class="topbar-right">
        <% if("draft".equals(drive.getStatus())||"pending_approval".equals(drive.getStatus())){ %>
        <form method="post" action="${pageContext.request.contextPath}/admin/action/publish-drive" style="display:inline;">
          <input type="hidden" name="driveId" value="<%= drive.getId() %>">
          <button class="btn btn-success btn-sm" data-confirm="Publish this drive and notify all eligible students?">🚀 Publish Drive</button>
        </form>
        <% } %>
        <button class="btn btn-primary btn-sm" id="exportBtn">📥 Export Students</button>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
      </div>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>

      <!-- Drive Info Card -->
      <div class="card" style="border-top:4px solid #1a237e;margin-bottom:20px;">
        <div class="card-body">
          <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:16px;">
            <div>
              <h2 style="font-size:22px;font-weight:800;color:#1a237e;margin-bottom:6px;"><%= drive.getTitle() %></h2>
              <div style="display:flex;gap:16px;flex-wrap:wrap;color:#666;font-size:14px;">
                <span>🏢 <%= drive.getCompanyName()!=null?drive.getCompanyName():"University Drive" %></span>
                <span>💼 <%= drive.getRole() %></span>
                <% if(drive.getSalary()!=null){ %><span style="color:#2e7d32;font-weight:600;">💰 <%= drive.getSalary() %></span><% } %>
                <% if(drive.getLocation()!=null){ %><span>📍 <%= drive.getLocation() %></span><% } %>
              </div>
            </div>
            <div>
              <% String st=drive.getStatus(); String bc="badge-muted";
                 if("published".equals(st)) bc="badge-success";
                 else if("pending_approval".equals(st)) bc="badge-warning";
                 else if("closed".equals(st)) bc="badge-danger"; %>
              <span class="badge <%= bc %>" style="font-size:14px;padding:8px 16px;"><%= st.replace("_"," ").toUpperCase() %></span>
            </div>
          </div>

          <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:16px;margin-top:20px;">
            <div style="text-align:center;background:#f5f5f5;border-radius:8px;padding:14px;">
              <div style="font-size:24px;font-weight:700;color:#3949ab;"><%= apps.size() %></div>
              <div style="font-size:12px;color:#888;">Applications</div>
            </div>
            <div style="text-align:center;background:#f5f5f5;border-radius:8px;padding:14px;">
              <div style="font-size:24px;font-weight:700;color:#00897b;"><%= eligible.size() %></div>
              <div style="font-size:12px;color:#888;">Eligible Students</div>
            </div>
            <div style="text-align:center;background:#f5f5f5;border-radius:8px;padding:14px;">
              <% long sel = apps.stream().filter(a->"selected".equals(a.getStatus())).count(); %>
              <div style="font-size:24px;font-weight:700;color:#2e7d32;"><%= sel %></div>
              <div style="font-size:12px;color:#888;">Selected</div>
            </div>
            <div style="text-align:center;background:#fff8e1;border-radius:8px;padding:14px;border:1px solid #ffe082;">
              <div style="font-size:13px;font-weight:600;color:#f57f17;">Deadline</div>
              <div style="font-size:13px;color:#e65100;margin-top:4px;"><%= drive.getApplicationDeadline()!=null?drive.getApplicationDeadline():"N/A" %></div>
            </div>
          </div>

          <!-- Eligibility criteria summary -->
          <div style="margin-top:18px;padding:14px;background:#e8eaf6;border-radius:8px;">
            <strong style="color:#1a237e;font-size:13px;">Eligibility Criteria:</strong>
            <div style="display:flex;gap:16px;flex-wrap:wrap;margin-top:8px;font-size:13px;color:#444;">
              <span>CGPA ≥ <strong><%= drive.getMinCgpa() %></strong></span>
              <span>10th ≥ <strong><%= drive.getMinTenth() %>%</strong></span>
              <span>12th ≥ <strong><%= drive.getMinTwelfth() %>%</strong></span>
              <span>Grad ≥ <strong><%= drive.getMinGrad() %>%</strong></span>
              <% if(drive.getEligibleBatches()!=null && !drive.getEligibleBatches().isEmpty()){ %><span>Batches: <strong><%= drive.getEligibleBatches() %></strong></span><% } %>
              <% if(drive.getEligibleBranches()!=null && !drive.getEligibleBranches().isEmpty()){ %><span>Branches: <strong><%= drive.getEligibleBranches() %></strong></span><% } %>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/action/mark-eligible" style="margin-top:12px;display:inline;">
              <input type="hidden" name="driveId" value="<%= drive.getId() %>">
              <button class="btn btn-primary btn-sm" data-confirm="Re-run eligibility check? This will replace the current eligible list.">🔄 Re-run Eligibility</button>
            </form>
          </div>

          <% if(drive.getDescription()!=null){ %>
          <div style="margin-top:16px;">
            <strong style="font-size:13px;color:#666;">Description:</strong>
            <p style="margin-top:6px;font-size:14px;line-height:1.6;"><%= drive.getDescription() %></p>
          </div>
          <% } %>
        </div>
      </div>

      <!-- Tabs: Applications / Eligible Students -->
      <div class="tab-group">
        <div class="tab-nav">
          <div class="tab" data-target="tab-applications">Applications (<%= apps.size() %>)</div>
          <div class="tab" data-target="tab-eligible">Eligible Students (<%= eligible.size() %>)</div>
        </div>

        <div id="tab-applications" class="tab-content">
          <div class="card">
            <div class="card-body" style="padding:0;">
              <div class="table-responsive">
                <table>
                  <thead><tr><th>#</th><th>Student</th><th>Email</th><th>Dept</th><th>CGPA</th><th>Applied At</th><th>Status</th><th>Update</th></tr></thead>
                  <tbody>
                  <% if(apps.isEmpty()){ %>
                  <tr><td colspan="8" style="text-align:center;padding:40px;color:#888;">No applications yet.</td></tr>
                  <% } %>
                  <% int ai=1; for(Application app: apps){ %>
                  <tr>
                    <td><%= ai++ %></td>
                    <td style="font-weight:600;"><%= app.getStudentName() %></td>
                    <td><%= app.getStudentEmail() %></td>
                    <td><%= app.getStudentDepartment() %></td>
                    <td><%= app.getStudentCgpa() %></td>
                    <td style="font-size:12px;color:#888;"><%= app.getAppliedAt()!=null?app.getAppliedAt().toString().substring(0,10):"" %></td>
                    <td>
                      <% String as=app.getStatus(); String abc="badge-muted";
                         if("selected".equals(as)) abc="badge-success";
                         else if("shortlisted".equals(as)) abc="badge-info";
                         else if("rejected".equals(as)) abc="badge-danger";
                         else if("applied".equals(as)) abc="badge-primary"; %>
                      <span class="badge <%= abc %>"><%= as %></span>
                    </td>
                    <td>
                      <form method="post" action="${pageContext.request.contextPath}/admin/action/update-application-status" style="display:flex;gap:4px;">
                        <input type="hidden" name="applicationId" value="<%= app.getId() %>">
                        <select name="status" class="form-control" style="width:120px;padding:5px;">
                          <option value="applied" <%= "applied".equals(as)?"selected":"" %>>Applied</option>
                          <option value="shortlisted" <%= "shortlisted".equals(as)?"selected":"" %>>Shortlisted</option>
                          <option value="selected" <%= "selected".equals(as)?"selected":"" %>>Selected</option>
                          <option value="rejected" <%= "rejected".equals(as)?"selected":"" %>>Rejected</option>
                        </select>
                        <button class="btn btn-sm btn-primary">Save</button>
                      </form>
                    </td>
                  </tr>
                  <% } %>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <div id="tab-eligible" class="tab-content">
          <div class="card">
            <div class="card-body" style="padding:0;">
              <div class="table-responsive">
                <table>
                  <thead><tr><th>#</th><th>Name</th><th>Roll No</th><th>Dept</th><th>Batch</th><th>CGPA</th><th>10th%</th><th>12th%</th></tr></thead>
                  <tbody>
                  <% if(eligible.isEmpty()){ %>
                  <tr><td colspan="8" style="text-align:center;padding:40px;color:#888;">No eligible students marked. <a href="javascript:void(0)">Re-run eligibility above.</a></td></tr>
                  <% } %>
                  <% int ei=1; for(Student es: eligible){ %>
                  <tr>
                    <td><%= ei++ %></td>
                    <td style="font-weight:600;"><a href="${pageContext.request.contextPath}/admin/action/student-detail?id=<%= es.getId() %>"><%= es.getName() %></a></td>
                    <td><%= es.getRollNumber()!=null?es.getRollNumber():"-" %></td>
                    <td><%= es.getDepartment() %></td>
                    <td><%= es.getBatch() %></td>
                    <td><strong><%= es.getCgpa() %></strong></td>
                    <td><%= es.getTenthPercent() %>%</td>
                    <td><%= es.getTwelfthPercent() %>%</td>
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
  </div>
</div>

<!-- Export Modal -->
<div class="modal-overlay" id="exportModal">
  <div class="modal-box">
    <h3>📥 Export Student Data</h3>
    <p style="color:#888;font-size:13px;margin-bottom:16px;">Select the fields you want to include in the Excel export.</p>
    <form method="get" action="${pageContext.request.contextPath}/admin/export-students" target="_blank">
      <input type="hidden" name="driveId" value="<%= drive.getId() %>">
      <div style="margin-bottom:12px;"><label class="checkbox-item"><input type="checkbox" id="selectAllFields"> <strong>Select All</strong></label></div>
      <div class="checkbox-grid">
        <label class="checkbox-item"><input type="checkbox" name="fields" value="name" class="export-field" checked> Name</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="email" class="export-field" checked> Email</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="phone" class="export-field" checked> Phone</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="department" class="export-field" checked> Department</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="batch" class="export-field" checked> Batch</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="rollNumber" class="export-field"> Roll Number</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="cgpa" class="export-field" checked> CGPA</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="tenthPercent" class="export-field"> 10th %</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="twelfthPercent" class="export-field"> 12th %</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="gradPercent" class="export-field"> Grad %</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="mastersPercent" class="export-field"> Masters %</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="skills" class="export-field"> Skills</label>
        <label class="checkbox-item"><input type="checkbox" name="fields" value="status" class="export-field" checked> App Status</label>
      </div>
      <div class="modal-footer">
        <button type="button" id="closeModal" class="btn btn-outline">Cancel</button>
        <button type="submit" class="btn btn-success">📥 Download Excel</button>
      </div>
    </form>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
