<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Header</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #333;
            padding: 10px 20px;
            color: white;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 0 15px;
            font-size: 16px;
        }
        .nav-links a:hover {
            text-decoration: underline;
        }
        .user-info {
            display: flex;
            align-items: center;
        }
        .user-info a {
            color: white;
            text-decoration: none;
            padding: 0 15px;
        }
        .user-info a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <!-- Navigation Links -->
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="listprod.jsp">Shop</a>
            <a href="showcart.jsp">Cart</a>
            <a href="userOrder.jsp">Orders</a>
            <a href="admin.jsp">Admin</a>
        </div>

        <!-- User Info Section -->
        <div class="user-info">
            <% 
                // Check if the user is logged in
                String username = (String) session.getAttribute("username");
                if (username != null) {
            %>
                Welcome, <b><%= username %></b>! 
                <a href="customer.jsp" style="margin-left: 15px;">Profile</a> <!-- Profile Link -->
                <a href="logout.jsp" style="margin-left: 15px;">Logout</a>
            <% } else { %>
                <a href="login.jsp">Login</a>
            <% } %>
        </div>
    </div>
</body>
</html>
