<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Arrays, java.util.List" %>
<jsp:include page="header.jsp" />

<%
    // Predefined list of admin usernames
    List<String> adminUsers = Arrays.asList("arnold");

    // Get the logged-in user's username from the session
    String username = (String) session.getAttribute("username");

    // Redirect non-admin users to login if they are not authorized
    if (username == null || !adminUsers.contains(username)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // SQL query to fetch total sales grouped by day
    String sql = " SELECT CONVERT(DATE, orderDate) AS SaleDate, SUM(totalAmount) AS TotalSales FROM ordersummary GROUP BY CONVERT(DATE, orderDate) ORDER BY SaleDate DESC";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <style>
        /* General styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        /* Background video */
        .background video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: -1;
        }

        /* Layout styles */
        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            gap: 20px;
        }

        .sidebar {
            width: 250px;
            background-color: #0073e6;
            padding: 20px;
            color: white;
            border-radius: 8px;
        }

        .sidebar h2 {
            font-size: 1.5em;
            text-align: center;
            margin-bottom: 20px;
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

        /* Table styles */
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

        /* Button styles */
        .load-data-btn {
            margin: 20px 0;
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .load-data-btn:hover {
            background-color: #218838;
        }

        .message {
            margin-top: 10px;
            font-weight: bold;
            color: #0073e6;
        }

        /* Header styles */
        h1 {
            text-align: center;
            color: #0073e6;
        }
    </style>
    <script>
        function loadData() {
            const messageDiv = document.getElementById('message');
            messageDiv.textContent = "Loading data...";
            fetch('loaddata.jsp')
                .then(response => {
                    if (response.ok) {
                        messageDiv.textContent = "Data loaded successfully!";
                    } else {
                        messageDiv.textContent = "Failed to load data.";
                    }
                })
                .catch(error => {
                    messageDiv.textContent = "Error: " + error.message;
                });
        }
    </script>
</head>
<body>
    <div class="background">
        <video autoplay muted loop>
            <source src="img/v2.mp4" type="video/mp4">
            Your browser does not support the video tag.
        </video>
    </div>
    <div class="container">
        <div class="sidebar">
            <h2>Admin Dashboard</h2>
            <a href="listCustomers.jsp">List All Customers</a>
            <a href="admin.jsp">List Report: Total Sales/Orders</a>
            <a href="addProduct.jsp">Add New Product</a>
            <a href="updateProduct.jsp">Update/Delete Product</a>
            <a href="updateStatus.jsp">Update Order/Shipment</a>
            <a href="warehouse.jsp">Warehouses</a>
        </div>
        <div class="content">
            <h1>Sales Report</h1>
            <button class="load-data-btn" onclick="loadData()">Load Data</button>
            <div id="message" class="message"></div>
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
