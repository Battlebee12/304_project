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
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background-color: #f4f6f8;
            color: #2c3e50;
            margin: 0;
            padding: 20px;
        }
        h1 {
            text-align: center;
            font-size: 2em;
            color: #3498db;
            margin-top: 0;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
            margin-top: 20px;
        }
        th {
            background-color: #3498db;
            color: #fff;
            font-weight: 600;
            padding: 12px;
            text-transform: uppercase;
        }
        td {
            padding: 12px;
            color: #34495e;
            font-size: 0.95em;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #eaf2f8;
        }
        .order-row {
            font-weight: bold;
            background-color: #ecf0f1;
            color: #2980b9;
        }
        .nested-table {
            width: 90%;
            margin: 15px auto;
            border: 1px solid #ddd;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .nested-table th {
            background-color: #2ecc71;
            color: #fff;
            font-size: 0.9em;
            padding: 10px;
        }
        .nested-table td {
            padding: 8px;
            text-align: left;
            font-size: 0.9em;
            color: #34495e;
        }
        .price {
            color: #e74c3c;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h1>Your Name Grocery Order List</h1>


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
                   "customer.firstName, customer.lastName, ordersummary.totalAmount " +
                   "FROM ordersummary " +
                   "JOIN customer ON ordersummary.customerId = customer.customerId";

    String q2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";
    PreparedStatement pst = con.prepareStatement(q2);

    ResultSet rst = stmt.executeQuery(query);

    // Display results in an HTML table
    out.print("<table>");
    out.print("<tr><th>Order ID</th><th>Order Date</th><th>Customer ID</th><th>Customer Name</th><th>Total Amount</th></tr>");

    while (rst.next()) {
        int orderId = rst.getInt("orderId");
        
        out.print("<tr>");
        out.print("<td>" + orderId + "</td>");
        out.print("<td>" + rst.getString("orderDate") + "</td>");
        out.print("<td>" + rst.getInt("customerId") + "</td>");
        out.print("<td>" + rst.getString("firstName") + " " + rst.getString("lastName") + "</td>");
        out.print("<td>" + rst.getBigDecimal("totalAmount") + "</td>");
        out.print("</tr>");
        
        // Query for products in the current order
        pst.setInt(1, orderId);
        ResultSet r2 = pst.executeQuery();

        // Nested table for order products
        out.print("<tr><td colspan='5'><table class='nested-table'>");
        out.print("<tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");

        while (r2.next()) {
            out.print("<tr>");
            out.print("<td>" + r2.getInt("productId") + "</td>");
            out.print("<td>" + r2.getInt("quantity") + "</td>");
            out.print("<td>" + r2.getBigDecimal("price") + "</td>");
            out.print("</tr>");
        }
        out.print("</table></td></tr>");
    }
    out.print("</table>");
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
%>

</body>
</html>
