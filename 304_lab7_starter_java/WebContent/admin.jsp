<%@ page import="java.sql.*,java.text.NumberFormat" %>

<%
    // Check if user is logged in
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // SQL query to fetch total sales grouped by day
    String sql = "SELECT CONVERT(DATE, orderDate) AS SaleDate, SUM(totalAmount) AS TotalSales " +
                 "FROM ordersummary GROUP BY CONVERT(DATE, orderDate) ORDER BY SaleDate DESC";

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();
         ResultSet rst = stmt.executeQuery(sql)) {

        out.println("<h1>Sales Report</h1>");
        out.println("<table border='1' style='width:100%;border-collapse:collapse;text-align:center;'>");
        out.println("<tr><th>Date</th><th>Total Sales</th></tr>");

        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

        while (rst.next()) {
            String saleDate = rst.getString("SaleDate");
            double totalSales = rst.getDouble("TotalSales");
            out.println("<tr><td>" + saleDate + "</td><td>" + currencyFormat.format(totalSales) + "</td></tr>");
        }

        out.println("</table>");
    } catch (SQLException e) {
        out.println("<p>Error fetching sales report: " + e.getMessage() + "</p>");
    }
%>
