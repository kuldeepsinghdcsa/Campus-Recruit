<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Error</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
  body{display:flex;align-items:center;justify-content:center;min-height:100vh;background:#f0f2f5;margin:0;font-family:sans-serif;}
  .err-box{background:#fff;border-radius:12px;padding:40px;max-width:720px;width:100%;box-shadow:0 4px 24px rgba(0,0,0,.1);}
  .err-code{font-size:64px;font-weight:900;color:#e53935;margin:0 0 8px;}
  .err-title{font-size:22px;font-weight:700;color:#1a237e;margin:0 0 6px;}
  .err-msg{color:#555;margin-bottom:20px;}
  .err-detail{background:#f5f5f5;border-left:4px solid #e53935;padding:14px 16px;border-radius:4px;font-size:13px;font-family:monospace;word-break:break-all;white-space:pre-wrap;color:#333;max-height:300px;overflow:auto;}
  .err-uri{font-size:13px;color:#888;margin:12px 0;}
  .btn{display:inline-block;padding:10px 22px;background:#1a237e;color:#fff;border-radius:6px;text-decoration:none;font-size:14px;margin-top:16px;}
</style>
</head>
<body>
<%
  Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
  String  errMsg     = (String)  request.getAttribute("javax.servlet.error.message");
  String  errUri     = (String)  request.getAttribute("javax.servlet.error.request_uri");
  Throwable cause    = (Throwable) request.getAttribute("javax.servlet.error.exception");
  if(statusCode == null) statusCode = 500;
  if(errMsg == null || errMsg.isEmpty()) errMsg = "An unexpected error occurred.";
%>
<div class="err-box">
  <div class="err-code"><%= statusCode %></div>
  <div class="err-title">
    <% if(statusCode==404){ %>Page Not Found
    <% } else if(statusCode==403){ %>Access Denied
    <% } else { %>Server Error<% } %>
  </div>
  <div class="err-msg"><%= errMsg %></div>
  <% if(errUri!=null){ %><div class="err-uri">URL: <code><%= errUri %></code></div><% } %>

  <% if(cause != null){ %>
  <div class="err-detail"><strong><%= cause.getClass().getName() %>:</strong> <%= cause.getMessage() %>
<%
  for(StackTraceElement el : cause.getStackTrace()){
    String c = el.getClassName();
    if(c.startsWith("com.campus") || c.startsWith("org.apache")){
      out.print("\n  at " + el);
      break;
    }
  }
%>
  </div>
  <% } %>

  <a href="${pageContext.request.contextPath}/index.jsp" class="btn">← Go to Home</a>
  <a href="${pageContext.request.contextPath}/login.jsp" class="btn" style="margin-left:8px;background:#555;">Login Page</a>
</div>
</body>
</html>
