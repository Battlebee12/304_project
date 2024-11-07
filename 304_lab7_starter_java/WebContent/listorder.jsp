<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Name Grocery Order List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

<h1>Order List</h1>

<%
try {
    // Load SQL Server JDBC driver
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";        
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw);
     Statement stmt = con.createStatement()) {

    // SQL query to fetch order details
    String query = "SELECT ordersummary.orderId, ordersummary.orderDate, customer.customerId, " +
                   "customer.firstName, ordersummary.totalAmount " +
                   "FROM ordersummary " +
                   "JOIN orderProduct ON ordersummary.orderId = orderProduct.orderId " +
                   "JOIN customer ON ordersummary.customerId = customer.customerId";
    ResultSet rst = stmt.executeQuery(query);

    // Display results in an HTML table
    out.print("<table>");
    out.print("<tr><th>Order ID</th><th>Order Date</th><th>Customer ID</th><th>Customer Name</th><th>Total Amount</th></tr>");

    while (rst.next()) {
        out.print("<tr>");
        out.print("<td>" + rst.getString("orderId") + "</td>");
        out.print("<td>" + rst.getString("orderDate") + "</td>");
        out.print("<td>" + rst.getString("customerId") + "</td>");
        out.print("<td>" + rst.getString("firstName") + "</td>");
        out.print("<td>" + rst.getString("totalAmount") + "</td>");
        out.print("</tr>");
    }
    out.print("</table>");
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
%>

</body>
</html>
