<%@ page import="java.sql.*, java.util.*, java.io.*" %>

<%-- Include the header file --%>
<jsp:include page="header.jsp" />

<%
    // Predefined list of admin usernames
    List<String> adminUsers = Arrays.asList("arnold");

    // Get the logged-in user's username from the session
    String username = (String) session.getAttribute("username");

    // Check if the user is logged in and is an admin
    if (username == null || !adminUsers.contains(username)) {
        response.sendRedirect("login.jsp"); // Redirect non-admin users to login if not admin
        return;
    }

    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    String message = "";

    // Handle form submission
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String action = request.getParameter("action"); // Action: "updateOrder" or "updateShipment"

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            if ("updateOrder".equalsIgnoreCase(action)) {
                // Update order status
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("orderStatus");

                String sql = "UPDATE ordersummary SET shiptoState = ? WHERE orderId = ?";
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setString(1, newStatus);
                    pstmt.setInt(2, orderId);

                    int rowsUpdated = pstmt.executeUpdate();
                    message = (rowsUpdated > 0) ? "Order status updated successfully!" : "Failed to update order status.";
                }
            } else if ("updateShipment".equalsIgnoreCase(action)) {
                // Update shipment status
                int shipmentId = Integer.parseInt(request.getParameter("shipmentId"));
                String shipmentDesc = request.getParameter("shipmentDesc");

                String sql = "UPDATE shipment SET shipmentDesc = ? WHERE shipmentId = ?";
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setString(1, shipmentDesc);
                    pstmt.setInt(2, shipmentId);

                    int rowsUpdated = pstmt.executeUpdate();
                    message = (rowsUpdated > 0) ? "Shipment status updated successfully!" : "Failed to update shipment status.";
                }
            }
        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Order and Shipment Status</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
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
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        label {
            font-weight: bold;
        }
        input[type="text"], textarea, input[type="number"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            padding: 10px;
            background-color: #0073e6;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-align: center;
        }
        button:hover {
            background-color: #005bb5;
        }
        .message {
            text-align: center;
            font-weight: bold;
            color: green;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Change Order and Shipment Status</h1>

        <%-- Form to update order status --%>
        <form action="changeOrderAndShipStatus.jsp" method="post">
            <h2>Update Order Status</h2>
            <label for="orderId">Order ID:</label>
            <input type="number" id="orderId" name="orderId" required>

            <label for="orderStatus">New Order Status:</label>
            <input type="text" id="orderStatus" name="orderStatus" required>

            <button type="submit" name="action" value="updateOrder">Update Order Status</button>
        </form>

        <%-- Form to update shipment status --%>
        <form action="changeOrderAndShipStatus.jsp" method="post">
            <h2>Update Shipment Status</h2>
            <label for="shipmentId">Shipment ID:</label>
            <input type="number" id="shipmentId" name="shipmentId" required>

            <label for="shipmentDesc">New Shipment Description:</label>
            <input type="text" id="shipmentDesc" name="shipmentDesc" required>

            <button type="submit" name="action" value="updateShipment">Update Shipment Status</button>
        </form>

        <%-- Display message after action --%>
        <% if (!message.isEmpty()) { %>
            <p class="message"><%= message %></p>
        <% } %>
    </div>
</body>
</html>
