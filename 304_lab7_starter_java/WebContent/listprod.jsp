<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Name Grocery</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f7f7f7;
        color: #333;
        padding: 20px;
    }
    h1 {
        color: #2c3e50;
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
        background-color: #3498db;
        color: white;
    }
    tr:nth-child(even) {
        background-color: #f2f2f2;
    }
    a {
        color: #3498db;
        text-decoration: none;
    }
</style>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
    <input type="text" name="productName" size="50">
    <input type="submit" value="Submit">
    <input type="reset" value="Reset"> (Leave blank for all products)
</form>

<%
String name = request.getParameter("productName");
try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {

    String query = "SELECT productId, productname, productPrice FROM product WHERE productName LIKE ?";
    PreparedStatement pst = con.prepareStatement(query);
    String pname_sql = "%" + (name != null ? name : "") + "%";
    pst.setString(1, pname_sql);

    ResultSet rst = pst.executeQuery();

    // Display results in an HTML table
    out.print("<table>");
    out.print("<tr><th>Product Name</th><th>Price</th><th>Action</th></tr>");

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    while (rst.next()) {
        int productId = rst.getInt("productId");
        String productName = rst.getString("productname");
        double productPrice = rst.getDouble("productPrice");

        String encodedName = URLEncoder.encode(productName, "UTF-8");
        String addCartLink = "addcart.jsp?id=" + productId + "&name=" + encodedName + "&price=" + productPrice;

        out.print("<tr>");
        out.print("<td>" + productName + "</td>");
        out.print("<td>" + currFormat.format(productPrice) + "</td>");
        out.print("<td><a href='" + addCartLink + "'>Add to Cart</a></td>");
        out.print("</tr>");
    }

    out.print("</table>");

} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
%>

</body>
</html>
