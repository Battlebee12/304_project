<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f9f9f9;
        }
        h1 {
            color: #2c3e50;
        }
        table {
            width: 60%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #3498db;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    // Retrieve the logged-in user's username and userId
   String userName = (String) session.getAttribute("username");
   String userId = (String) session.getAttribute("userId");

    // Check if the user is authenticated
    if (userName == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Define the SQL query to fetch customer details
    String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country "
               + "FROM customer WHERE customerId = ?";
    try {
        getConnection();

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userId); // Use userId from session to retrieve customer data

        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            String customerId = rs.getString("customerId");
            String firstName = rs.getString("firstName");
            String lastName = rs.getString("lastName");
            String email = rs.getString("email");
            String phone = rs.getString("phonenum");
            String address = rs.getString("address");
            String city = rs.getString("city");
            String state = rs.getString("state");
            String postalCode = rs.getString("postalCode");
            String country = rs.getString("country");

            // Display customer information
%>
            <h1>Welcome, <%= firstName + " " + lastName %></h1>
            <h2>Your Information</h2>
            <table>
                <tr><th>Field</th><th>Details</th></tr>
                <tr><td>Customer ID</td><td><%= customerId %></td></tr>
                <tr><td>First Name</td><td><%= firstName %></td></tr>
                <tr><td>Last Name</td><td><%= lastName %></td></tr>
                <tr><td>Email</td><td><%= email %></td></tr>
                <tr><td>Phone</td><td><%= phone %></td></tr>
                <tr><td>Address</td><td><%= address %>, <%= city %>, <%= state %>, <%= postalCode %>, <%= country %></td></tr>
            </table>
<%
        } else {
            out.println("<p style='color:red;'>Error: Customer information not found!</p>");
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
    } finally {
        closeConnection();
    }
%>

</body>
</html>
