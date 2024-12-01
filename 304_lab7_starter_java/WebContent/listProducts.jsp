<%@ page import="java.sql.*, java.text.NumberFormat" %>

<%-- Include the header file at the top --%>
<jsp:include page="header.jsp" />

<%
    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // SQL query to fetch all products
    String sql = "SELECT productId, productName, productPrice FROM product ORDER BY productId";

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List of Products</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 1000px;
            margin: 50px auto;
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
            text-align: center;
        }
        th {
            background-color: #0073e6;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e8f4ff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>List of Products</h1>
        <table>
            <tr>
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Price</th>
            </tr>
<%
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();
         ResultSet rst = stmt.executeQuery(sql)) {

        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

        while (rst.next()) {
            int productId = rst.getInt("productId");
            String productName = rst.getString("productName");
            double price = rst.getDouble("productPrice");
%>
            <tr>
                <td><%= productId %></td>
                <td><%= productName %></td>
                <td><%= currencyFormat.format(price) %></td>
            </tr>
<%
        }
    } catch (SQLException e) {
%>
            <tr>
                <td colspan="3">Error fetching products: <%= e.getMessage() %></td>
            </tr>
<%
    }
%>
        </table>
    </div>
</body>
</html>
