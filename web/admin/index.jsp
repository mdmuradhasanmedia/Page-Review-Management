<%-- 
    Document   : admin_login
    Created on : Jun 20, 2025, 12:43:40 AM
    Author     : mdmuradhasanmedia
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - Page Review Management</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin:0; padding:0;}
        .box { max-width: 400px; margin: 70px auto; padding: 32px 25px 24px; background: white; border-radius: 10px; box-shadow:0 6px 24px #bbb;}
        h2 { text-align:center; margin-bottom: 18px; color: #225;}
        .form-group { margin-bottom: 15px; }
        label { display:block; margin-bottom: 6px; font-weight: 500;}
        input[type=text], input[type=password] {
            width:100%; padding:9px; border:1px solid #ccc; border-radius:4px;
        }
        .btn { width:100%; padding:10px; background:#2671e4; color:white; border:none; border-radius:4px; font-size:1em;}
        .btn:hover { background:#1451a3; cursor:pointer;}
        .err { color:#c00; background: #ffeaea; border-radius:4px; padding:8px; margin-bottom:15px; text-align:center;}
    </style>
</head>
<body>
    <div class="box">
        <h2>Admin Login</h2>
        <% String msg = request.getParameter("msg");
           if ("fail".equals(msg)) { %>
            <div class="err">Invalid username or password!</div>
        <% } %>
        <form method="post" action="AdminLoginServlet">
            <div class="form-group">
                <label for="username">Username</label>
                <input name="username" id="username" required type="text" placeholder="Enter admin username" />
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input name="password" id="password" required type="password" placeholder="Enter password" />
            </div>
            <button class="btn" type="submit">Login</button>
        </form>
    </div>
</body>
</html>
