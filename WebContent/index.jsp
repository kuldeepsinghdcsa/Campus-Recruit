<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Campus Recruitment Management System</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="landing">
  <!-- Navbar -->
  <nav class="landing-nav">
    <div class="brand">Campus<span>Recruit</span></div>
    <div class="nav-links">
      <a href="${pageContext.request.contextPath}/login.jsp?role=student">Student Login</a>
      <a href="${pageContext.request.contextPath}/login.jsp?role=company">Company Login</a>
      <a href="${pageContext.request.contextPath}/login.jsp?role=admin">Admin Login</a>
    </div>
  </nav>

  <!-- Hero -->
  <div class="hero">
    <h1>Smart <span>Campus Recruitment</span><br>Management Platform</h1>
    <p>Bridging students with opportunities. A complete end-to-end campus placement system for universities, companies, and students.</p>
    <div class="hero-btns">
      <a href="${pageContext.request.contextPath}/register.jsp?role=student" class="btn btn-white">Register as Student</a>
      <a href="${pageContext.request.contextPath}/register.jsp?role=company" class="btn btn-ghost">Register as Company</a>
    </div>
  </div>

  <!-- Portal Cards -->
  <div class="portal-cards">
    <div class="portal-card">
      <div class="icon">🎓</div>
      <h3>Student Portal</h3>
      <p>Register, build your profile, upload resume, get notified about drives, and apply — all in one place.</p>
      <a href="${pageContext.request.contextPath}/login.jsp?role=student">Login / Register →</a>
    </div>
    <div class="portal-card">
      <div class="icon">🏢</div>
      <h3>Company Portal</h3>
      <p>Post placement drives, request admin approval, and access the list of applied students with export.</p>
      <a href="${pageContext.request.contextPath}/login.jsp?role=company">Login / Register →</a>
    </div>
    <div class="portal-card">
      <div class="icon">⚙️</div>
      <h3>Admin Portal</h3>
      <p>Manage students, approve companies, create & publish drives, set eligibility, and view placement analytics.</p>
      <a href="${pageContext.request.contextPath}/login.jsp?role=admin">Admin Login →</a>
    </div>
  </div>

  <!-- Features -->
  <div class="features-section">
    <h2>Everything you need for Campus Placements</h2>
    <div class="features-grid">
      <div class="feature-item"><div class="f-icon">📊</div><h4>Placement Analytics</h4><p>Real-time dashboard with department-wise and company-wise placement statistics.</p></div>
      <div class="feature-item"><div class="f-icon">✅</div><h4>Smart Eligibility</h4><p>Auto-mark eligible students based on CGPA, percentage, branch, and batch criteria.</p></div>
      <div class="feature-item"><div class="f-icon">📧</div><h4>Email Notifications</h4><p>Students receive instant email notifications when eligible drives are published.</p></div>
      <div class="feature-item"><div class="f-icon">📥</div><h4>Data Export</h4><p>Export student/applicant data as Excel with customizable field templates.</p></div>
      <div class="feature-item"><div class="f-icon">📄</div><h4>Resume Upload</h4><p>Students upload and manage their resumes directly from their profile.</p></div>
      <div class="feature-item"><div class="f-icon">🔔</div><h4>In-App Notifications</h4><p>Real-time in-app notification centre for students to track drive updates.</p></div>
    </div>
  </div>

  <div class="landing-footer">
    <p>© 2024 Campus Recruitment Management System. Built with Java Servlet, JSP &amp; MySQL.</p>
  </div>
</div>
</body>
</html>
