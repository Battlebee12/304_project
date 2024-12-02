<%@ page import="java.sql.*, java.util.*" %>

<%-- Include the header file at the top --%>
<jsp:include page="header.jsp" />

<%
    // Predefined list of admin usernames
    List<String> adminUsers = Arrays.asList("arnold");

    // Get the logged-in user's username from the session
    String username = (String) session.getAttribute("username");

    // Check if the user is logged in and is an admin
    if (username == null || !adminUsers.contains(username)) {
        response.sendRedirect("login.jsp"); // Redirect non-admin users to login
        return;
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // SQL query to fetch all customers
    String sql = "SELECT customerId, firstName, lastName, email FROM customer ORDER BY lastName";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List of Customers</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 100%;
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #0073e6;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #0073e6;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>List of Customers</h1>
        <table>
            <tr>
                <th>Customer ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
            </tr>
<%
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();
         ResultSet rst = stmt.executeQuery(sql)) {

        while (rst.next()) {
            int customerId = rst.getInt("customerId");
            String firstName = rst.getString("firstName");
            String lastName = rst.getString("lastName");
            String email = rst.getString("email");
%>
            <tr>
                <td><%= customerId %></td>
                <td><%= firstName %></td>
                <td><%= lastName %></td>
                <td><%= email %></td>
            </tr>
<%
        }
    } catch (SQLException e) {
%>
            <tr>
                <td colspan="4">Error fetching customer data: <%= e.getMessage() %></td>
            </tr>
<%
    }
%>
        </table>
    </div>
</body>
</html>
