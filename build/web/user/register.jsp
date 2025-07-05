<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f7fa; }
        .register-box { max-width: 400px; margin: 90px auto; background: #fff; border-radius: 10px; box-shadow:0 6px 24px #bbb; padding: 32px 25px; }
        h2 { text-align:center; color: #235; margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        label { display:block; margin-bottom: 7px; font-weight: 500; }
        input[type=text], input[type=email], input[type=password] { width:100%; padding:9px; border:1px solid #bbb; border-radius:4px; }
        .btn { width:100%; padding:10px; background:#2671e4; color:white; border:none; border-radius:4px; font-size:1em; }
        .btn:hover { background:#1853b0; cursor:pointer; }
        .msg { color:#c00; background: #ffeaea; border-radius:4px; padding:8px; margin-bottom:17px; text-align:center;}
        .login-link { text-align: center; margin-top: 12px; }
        .login-link a { color: #1853b0; text-decoration: none; }
    </style>
</head>
<body>

<div class="register-box">
    <h2>Register</h2>

    <%
        String msg = request.getParameter("msg");
        if ("fail".equals(msg)) {
    %>
        <div class="msg">Registration failed. Please try again.</div>
    <%
        }
    %>

    <form action="${pageContext.request.contextPath}/user/RegisterServlet" method="post">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit" class="btn">Register</button>
    </form>

    <div class="login-link">
        Already have an account? <a href="${pageContext.request.contextPath}/user/login.jsp">Login here</a>
    </div>
</div>

</body>
</html>
