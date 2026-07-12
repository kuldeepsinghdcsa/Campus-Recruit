<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.model.*" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    if(studentId==null){response.sendRedirect(request.getContextPath()+"/login.jsp?role=student");return;}
    Student student = (Student) request.getAttribute("student");
    if(student==null) student = (Student) session.getAttribute("studentObj");
    String success=(String)session.getAttribute("success"); session.removeAttribute("success");
    String error=(String)session.getAttribute("error"); session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>My Profile - Student</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="wrapper">
  <%@ include file="sidebar.jsp" %>
  <div class="main-content">
    <div class="topbar">
      <div><div class="topbar-title">My Profile</div><div style="font-size:12px;color:#888;">Keep your profile updated for better opportunities</div></div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-danger btn-sm">Logout</a>
    </div>
    <div class="page-content">
      <% if(success!=null){ %><div class="alert alert-success auto-dismiss">✅ <%= success %></div><% } %>
      <% if(error!=null){ %><div class="alert alert-danger auto-dismiss">⚠️ <%= error %></div><% } %>

      <!-- Profile Header -->
      <div class="profile-header" style="margin-bottom:24px;">
        <div class="profile-avatar">👤</div>
        <div class="profile-info">
          <h2><%= student.getName() %></h2>
          <p><%= student.getEmail() %> <% if(student.getPhone()!=null && !student.getPhone().isEmpty()){ %>· <%= student.getPhone() %><% } %></p>
          <p><%= student.getDepartment()!=null?student.getDepartment():"" %> <% if(student.getBatch()!=null){ %>· Batch <%= student.getBatch() %><% } %></p>
          <p style="margin-top:8px;">
            CGPA: <strong><%= student.getCgpa() %></strong>
            &nbsp;|&nbsp; Roll: <strong><%= student.getRollNumber()!=null?student.getRollNumber():"-" %></strong>
          </p>
          <% if(student.getResumePath()!=null && !student.getResumePath().isEmpty()){ %>
          <p style="margin-top:8px;"><a href="${pageContext.request.contextPath}/<%= student.getResumePath() %>" target="_blank" style="color:#c5cae9;">📄 View Current Resume</a></p>
          <% } %>
        </div>
      </div>

      <div style="display:grid;grid-template-columns:2fr 1fr;gap:20px;">
        <!-- Update Profile Form -->
        <div class="card">
          <div class="card-header"><h3>Update Profile</h3></div>
          <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/student/action/update-profile">
              <div class="form-section">
                <h4>Personal Information</h4>
                <div class="form-row">
                  <div class="form-group"><label>Full Name *</label><input type="text" name="name" class="form-control" value="<%= student.getName() %>" required></div>
                  <div class="form-group"><label>Phone</label><input type="text" name="phone" class="form-control" value="<%= student.getPhone()!=null?student.getPhone():"" %>"></div>
                </div>
                <div class="form-row">
                  <div class="form-group"><label>Date of Birth</label><input type="date" name="dob" class="form-control" value="<%= student.getDob()!=null?student.getDob():"" %>"></div>
                  <div class="form-group"><label>Gender</label>
                    <select name="gender" class="form-control">
                      <option value="">Select</option>
                      <option value="Male" <%= "Male".equals(student.getGender())?"selected":"" %>>Male</option>
                      <option value="Female" <%= "Female".equals(student.getGender())?"selected":"" %>>Female</option>
                      <option value="Other" <%= "Other".equals(student.getGender())?"selected":"" %>>Other</option>
                    </select>
                  </div>
                </div>
                <div class="form-group"><label>Address</label><textarea name="address" class="form-control"><%= student.getAddress()!=null?student.getAddress():"" %></textarea></div>
              </div>

              <div class="form-section">
                <h4>Academic Details</h4>
                <div class="form-row">
                  <div class="form-group"><label>Department</label>
                    <select name="department" class="form-control">
                      <option value="">Select Department</option>
                      <% String[] depts={"Computer Science","Electronics","Mechanical","Civil","Electrical","Information Technology","Chemical","Biotechnology"};
                         for(String d: depts){ %>
                      <option value="<%= d %>" <%= d.equals(student.getDepartment())?"selected":"" %>><%= d %></option>
                      <% } %>
                    </select>
                  </div>
                  <div class="form-group"><label>Batch</label><input type="text" name="batch" class="form-control" value="<%= student.getBatch()!=null?student.getBatch():"" %>" placeholder="e.g. 2024"></div>
                </div>
                <div class="form-row">
                  <div class="form-group"><label>Roll Number</label><input type="text" name="rollNumber" class="form-control" value="<%= student.getRollNumber()!=null?student.getRollNumber():"" %>"></div>
                  <div class="form-group"><label>CGPA (out of 10)</label><input type="number" name="cgpa" step="0.01" min="0" max="10" class="form-control" value="<%= student.getCgpa() %>"></div>
                </div>

                <h4 style="margin-top:10px;">Marks (Percentages)</h4>
                <div class="form-row">
                  <div class="form-group"><label>10th %</label><input type="number" name="tenthPercent" step="0.01" min="0" max="100" class="form-control" value="<%= student.getTenthPercent() %>"></div>
                  <div class="form-group"><label>12th %</label><input type="number" name="twelfthPercent" step="0.01" min="0" max="100" class="form-control" value="<%= student.getTwelfthPercent() %>"></div>
                </div>
                <div class="form-row">
                  <div class="form-group"><label>Graduation % <span style="color:#888;font-size:11px;">(if completed)</span></label><input type="number" name="gradPercent" step="0.01" min="0" max="100" class="form-control" value="<%= student.getGradPercent() %>"></div>
                  <div class="form-group"><label>Masters % <span style="color:#888;font-size:11px;">(if applicable)</span></label><input type="number" name="mastersPercent" step="0.01" min="0" max="100" class="form-control" value="<%= student.getMastersPercent() %>"></div>
                </div>
              </div>

              <div class="form-section">
                <h4>Skills &amp; Others</h4>
                <div class="form-group"><label>Technical Skills</label>
                  <textarea name="skills" class="form-control" placeholder="e.g. Java, Python, SQL, React, Machine Learning..."><%= student.getSkills()!=null?student.getSkills():"" %></textarea>
                </div>
              </div>

              <button type="submit" class="btn btn-primary btn-lg">💾 Save Profile</button>
            </form>
          </div>
        </div>

        <!-- Resume Upload -->
        <div>
          <div class="card" style="margin-bottom:16px;">
            <div class="card-header"><h3>📄 Resume</h3></div>
            <div class="card-body">
              <% if(student.getResumePath()!=null && !student.getResumePath().isEmpty()){ %>
              <div class="alert alert-success" style="margin-bottom:14px;font-size:13px;">✅ Resume uploaded</div>
              <a href="${pageContext.request.contextPath}/<%= student.getResumePath() %>" target="_blank" class="btn btn-info" style="margin-bottom:16px;display:inline-block;">📄 View Current Resume</a>
              <hr style="margin:16px 0;border:none;border-top:1px solid #eee;">
              <p style="color:#888;font-size:13px;margin-bottom:10px;">Upload a new resume to replace existing:</p>
              <% } else { %>
              <div class="alert alert-warning" style="margin-bottom:14px;font-size:13px;">⚠️ No resume uploaded yet. Upload your resume to apply for drives.</div>
              <% } %>
              <form method="post" action="${pageContext.request.contextPath}/student/action/upload-resume" enctype="multipart/form-data">
                <div class="form-group"><label>Select Resume (PDF, max 5MB)</label>
                  <input type="file" name="resume" class="form-control" accept=".pdf,.doc,.docx" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">📤 Upload Resume</button>
              </form>
            </div>
          </div>

          <!-- Marks Summary -->
          <div class="card">
            <div class="card-header"><h3>Academic Summary</h3></div>
            <div class="card-body" style="padding:16px;">
              <div style="display:flex;flex-direction:column;gap:12px;">
                <div>
                  <div style="display:flex;justify-content:space-between;margin-bottom:4px;font-size:13px;"><span>CGPA</span><strong><%= student.getCgpa() %>/10</strong></div>
                  <div class="progress-bar"><div class="progress-fill" style="width:<%= Math.min(student.getCgpa()*10,100) %>%;background:#3949ab;"></div></div>
                </div>
                <div>
                  <div style="display:flex;justify-content:space-between;margin-bottom:4px;font-size:13px;"><span>10th Marks</span><strong><%= student.getTenthPercent() %>%</strong></div>
                  <div class="progress-bar"><div class="progress-fill" style="width:<%= student.getTenthPercent() %>%;background:#00897b;"></div></div>
                </div>
                <div>
                  <div style="display:flex;justify-content:space-between;margin-bottom:4px;font-size:13px;"><span>12th Marks</span><strong><%= student.getTwelfthPercent() %>%</strong></div>
                  <div class="progress-bar"><div class="progress-fill" style="width:<%= student.getTwelfthPercent() %>%;background:#fb8c00;"></div></div>
                </div>
                <% if(student.getGradPercent()>0){ %>
                <div>
                  <div style="display:flex;justify-content:space-between;margin-bottom:4px;font-size:13px;"><span>Graduation</span><strong><%= student.getGradPercent() %>%</strong></div>
                  <div class="progress-bar"><div class="progress-fill" style="width:<%= student.getGradPercent() %>%;background:#e53935;"></div></div>
                </div>
                <% } %>
                <% if(student.getMastersPercent()>0){ %>
                <div>
                  <div style="display:flex;justify-content:space-between;margin-bottom:4px;font-size:13px;"><span>Masters</span><strong><%= student.getMastersPercent() %>%</strong></div>
                  <div class="progress-bar"><div class="progress-fill" style="width:<%= student.getMastersPercent() %>%;background:#8e24aa;"></div></div>
                </div>
                <% } %>
              </div>
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
