<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
  <title>Your Orders</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f7f7f7;
      color: #333;
      margin: 0;
      padding: 0;
    }

    /* Header Section */
    .header-container {
      background-color: #0073e6;
      
    }
    .header-container h1, .header-container nav {
      color: white;
      text-align: center;
      margin: 0;
    }

    .container {
      max-width: 800px;
      width: 100%;
      padding: 20px;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
      margin: 20px auto;
    }

    h2 {
      color: #0073e6;
      text-align: center;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

    table, th, td {
      border: 1px solid #ddd;
    }

    th, td {
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

    tr:hover {
      background-color: #e8f4ff;
    }

    .error-message {
      color: #e74c3c;
      font-weight: bold;
      margin-top: 10px;
    }
  </style>
</head>
<body>

<!-- Header Section -->
<div class="header-container">
  <jsp:include page="header.jsp" />
</div>

<div class="container">
  <h2>Your Orders</h2>

  <%
    String customerId = (String) session.getAttribute("userId");  // Get the logged-in user's customerId
    if (customerId == null) {
  %>
      <p class="error-message">You must be logged in to view your orders.</p>
  <%
    } else {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            out.println("<p class='error-message'>Error loading database driver.</p>");
        }

        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";        
        String uid = "sa";
        String pw = "304#sa#pw";

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            String query = "SELECT orderId, orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry " +
                           "FROM ordersummary WHERE customerId = ? ORDER BY orderDate DESC";
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, customerId);
            ResultSet rs = stmt.executeQuery();

            if (!rs.isBeforeFirst()) {
  %>
      <p>No orders found.</p>
  <%
            } else {
  %>
      <table>
        <tr>
          <th>Order ID</th>
          <th>Order Date</th>
          <th>Total Amount</th>
          <th>Shipping Address</th>
        </tr>
  <%
                while (rs.next()) {
                    int orderId = rs.getInt("orderId");
                    String orderDate = rs.getString("orderDate");
                    double totalAmount = rs.getDouble("totalAmount");
                    String shippingAddress = rs.getString("shiptoAddress") + ", " +
                                             rs.getString("shiptoCity") + ", " +
                                             rs.getString("shiptoState") + " " +
                                             rs.getString("shiptoPostalCode") + ", " +
                                             rs.getString("shiptoCountry");
  %>
        <tr>
          <td><a href="orderDetails.jsp?orderId=<%= orderId %>"><%= orderId %></a></td>
          <td><%= orderDate %></td>
          <td><%= NumberFormat.getCurrencyInstance().format(totalAmount) %></td>
          <td><%= shippingAddress %></td>
        </tr>
  <%
                }
  %>
      </table>
  <%
            }
        } catch (SQLException e) {
            out.println("<p class='error-message'>Database connection error: " + e.getMessage() + "</p>");
        }
    }
  %>

</div>

</body>
</html>
