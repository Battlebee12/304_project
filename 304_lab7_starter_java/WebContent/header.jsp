<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Header</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            background-color: #333;
            padding: 10px;
            color: white;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 0 15px;
        }
        .navbar a:hover {
            text-decoration: underline;
        }
        .user-info {
            display: flex;
            align-items: center;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <!-- Navigation Links -->
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="shop.html">Shop</a>
            <%-- <a href="listprod.jsp">Products</a> --%>
            <a href="showcart.jsp">Cart</a>
            <a href="order.jsp">Orders</a>
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
                <a href="logout.jsp" style="margin-left: 15px;">Logout</a>
            <% } else { %>
                <a href="login.jsp">Login</a>
            <% } %>
        </div>
    </div>
</body>
</html>
