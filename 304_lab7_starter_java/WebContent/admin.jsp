<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Arrays, java.util.List" %>

<%-- Include the header file --%>
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

    // SQL query to fetch total sales grouped by day
    String sql = "SELECT CONVERT(DATE, orderDate) AS SaleDate, SUM(totalAmount) AS TotalSales " +
                 "FROM ordersummary GROUP BY CONVERT(DATE, orderDate) ORDER BY SaleDate DESC";

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
           
        }
        .container {
            display: flex;
            width: 100%;
            max-width: 1200px;
            margin-top: 20px;
        }
        .sidebar {
            width: 250px;
            background-color: #0073e6;
            padding: 20px;
            color: white;
            border-radius: 8px;
            height: 100%;
        }
        .sidebar h2 {
            font-size: 1.5em;
            margin-bottom: 20px;
            text-align: center;
        }
        .sidebar a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 4px;
            background-color: #005bb5;
            text-align: center;
        }
        .sidebar a:hover {
            background-color: #004494;
        }
        .content {
            flex: 1;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #0073e6;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        h1 {
            text-align: center;
            color: #0073e6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <h2>Admin Dashboard</h2>
            <a href="listCustomers.jsp">List All Customers</a>
            <a href="admin.jsp">List Report: Total Sales/Orders</a>
            <a href="addProduct.jsp">Add New Product</a>
            <a href="updateProduct.jsp">Update/Delete Product</a>
            <a href="updateStatus.jsp">Update Order/Shipmentt</a>
        </div>
        <div class="content">
            <h1>Sales Report</h1>
            <table>
                <tr>
                    <th>Date</th>
                    <th>Total Sales</th>
                </tr>
<%
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();
         ResultSet rst = stmt.executeQuery(sql)) {

        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

        while (rst.next()) {
            String saleDate = rst.getString("SaleDate");
            double totalSales = rst.getDouble("TotalSales");
%>
                <tr>
                    <td><%= saleDate %></td>
                    <td><%= currencyFormat.format(totalSales) %></td>
                </tr>
<%
        }
    } catch (SQLException e) {
%>
                <tr>
                    <td colspan="2">Error fetching sales report: <%= e.getMessage() %></td>
                </tr>
<%
    }
%>
            </table>
        </div>
    </div>
</body>
</html>
