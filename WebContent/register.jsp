<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String role = request.getParameter("role");
    if(role==null) role="student";
    String error = (String) session.getAttribute("registerError");
    session.removeAttribute("registerError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Register - Campus Recruitment</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-page">
  <div class="auth-container" style="max-width:520px;">
    <div style="text-align:center;margin-bottom:16px;">
      <a href="${pageContext.request.contextPath}/login.jsp?role=<%= role %>" style="color:rgba(255,255,255,.7);font-size:14px;">← Back to Login</a>
    </div>
    <div class="auth-card">
      <div class="auth-header">
        <div class="logo"><%= "company".equals(role)?"🏢":"🎓" %></div>
        <h2>Create Account</h2>
        <p>Register as <%= "company".equals(role)?"Company":"Student" %></p>
      </div>

      <div class="auth-tabs">
        <a href="?role=student" class="tab <%= "student".equals(role)?"active":"" %>">Student</a>
        <a href="?role=company" class="tab <%= "company".equals(role)?"active":"" %>">Company</a>
      </div>

      <% if(error!=null){ %><div class="alert alert-danger auto-dismiss">⚠️ <%= error %></div><% } %>

      <% if("student".equals(role)){ %>
      <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
        <input type="hidden" name="role" value="student">
        <div class="form-row">
          <div class="form-group"><label>Full Name *</label><input type="text" name="name" class="form-control" required placeholder="John Doe"></div>
          <div class="form-group"><label>Email *</label><input type="email" name="email" class="form-control" required placeholder="john@example.com"></div>
        </div>
        <div class="form-row">
          <div class="form-group"><label>Password *</label><input type="password" name="password" class="form-control" required placeholder="Min 6 characters"></div>
          <div class="form-group"><label>Phone</label><input type="text" name="phone" class="form-control" placeholder="9999999999"></div>
        </div>
        <div class="form-row">
          <div class="form-group"><label>Department *</label>
            <select name="department" class="form-control" required>
              <option value="">Select Department</option>
              <option>Computer Science</option><option>Electronics</option>
              <option>Mechanical</option><option>Civil</option>
              <option>Electrical</option><option>Information Technology</option>
              <option>Chemical</option><option>Biotechnology</option>
            </select>
          </div>
          <div class="form-group"><label>Batch *</label><input type="text" name="batch" class="form-control" required placeholder="2024"></div>
        </div>
        <div class="form-group"><label>Roll Number</label><input type="text" name="rollNumber" class="form-control" placeholder="CS2024001"></div>
        <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:12px;">Create Student Account</button>
      </form>
      <% } else { %>
      <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
        <input type="hidden" name="role" value="company">
        <div class="form-row">
          <div class="form-group"><label>Company Name *</label><input type="text" name="name" class="form-control" required placeholder="TechCorp Ltd."></div>
          <div class="form-group"><label>Industry *</label>
            <select name="industry" class="form-control" required>
              <option value="">Select Industry</option>
              <option>Information Technology</option><option>IT Services</option>
              <option>Finance</option><option>Banking</option>
              <option>Manufacturing</option><option>Consulting</option>
              <option>E-commerce</option><option>Healthcare</option><option>Other</option>
            </select>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group"><label>Email *</label><input type="email" name="email" class="form-control" required placeholder="hr@company.com"></div>
          <div class="form-group"><label>Password *</label><input type="password" name="password" class="form-control" required placeholder="Min 6 characters"></div>
        </div>
        <div class="form-row">
          <div class="form-group"><label>Contact Person</label><input type="text" name="contactPerson" class="form-control" placeholder="HR Manager"></div>
          <div class="form-group"><label>Contact Phone</label><input type="text" name="contactPhone" class="form-control" placeholder="9999999999"></div>
        </div>
        <div class="form-group"><label>Website</label><input type="url" name="website" class="form-control" placeholder="https://company.com"></div>
        <div class="form-group"><label>Company Description</label><textarea name="description" class="form-control" placeholder="Brief about the company..."></textarea></div>
        <div class="alert alert-info" style="font-size:13px;">ℹ️ Company accounts require admin approval before login.</div>
        <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:12px;">Register Company</button>
      </form>
      <% } %>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
