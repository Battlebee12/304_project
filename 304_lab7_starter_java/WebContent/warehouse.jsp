<%@ page import="java.sql.*, java.util.*" %>
<jsp:include page="header.jsp" />

<%
    // Check if the user is logged in
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    List<Map<String, Object>> warehouses = new ArrayList<>();
    List<Map<String, Object>> inventory = new ArrayList<>();

    String selectedWarehouseId = request.getParameter("warehouseId");
    String message = "";

    // Handle updates or deletions
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double price = Double.parseDouble(request.getParameter("price"));

            String updateSql = "UPDATE productinventory SET quantity = ?, price = ? WHERE productId = ? AND warehouseId = ?";
            try (Connection con = DriverManager.getConnection(url, uid, pw);
                 PreparedStatement pstmt = con.prepareStatement(updateSql)) {
                pstmt.setInt(1, quantity);
                pstmt.setDouble(2, price);
                pstmt.setInt(3, productId);
                pstmt.setInt(4, Integer.parseInt(selectedWarehouseId));

                int rowsUpdated = pstmt.executeUpdate();
                message = rowsUpdated > 0 ? "Inventory updated successfully!" : "Failed to update inventory.";
            } catch (SQLException e) {
                message = "Error: " + e.getMessage();
            }
        } else if ("delete".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));

            String deleteSql = "DELETE FROM productinventory WHERE productId = ? AND warehouseId = ?";
            try (Connection con = DriverManager.getConnection(url, uid, pw);
                 PreparedStatement pstmt = con.prepareStatement(deleteSql)) {
                pstmt.setInt(1, productId);
                pstmt.setInt(2, Integer.parseInt(selectedWarehouseId));

                int rowsDeleted = pstmt.executeUpdate();
                message = rowsDeleted > 0 ? "Inventory item deleted successfully!" : "Failed to delete inventory item.";
            } catch (SQLException e) {
                message = "Error: " + e.getMessage();
            }
        }
    }

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        // Fetch all warehouses
        String warehouseQuery = "SELECT warehouseId, warehouseName FROM warehouse";
        try (Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(warehouseQuery)) {
            while (rs.next()) {
                Map<String, Object> warehouse = new HashMap<>();
                warehouse.put("id", rs.getInt("warehouseId"));
                warehouse.put("name", rs.getString("warehouseName"));
                warehouses.add(warehouse);
            }
        }

        // If a warehouse is selected, fetch inventory for that warehouse
        if (selectedWarehouseId != null) {
            String inventoryQuery = "SELECT p.productId, p.productName, pi.quantity, pi.price " +
                                    "FROM productinventory pi " +
                                    "JOIN product p ON pi.productId = p.productId " +
                                    "WHERE pi.warehouseId = ?";
            try (PreparedStatement pstmt = con.prepareStatement(inventoryQuery)) {
                pstmt.setInt(1, Integer.parseInt(selectedWarehouseId));
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> item = new HashMap<>();
                        item.put("productId", rs.getInt("productId"));
                        item.put("productName", rs.getString("productName"));
                        item.put("quantity", rs.getInt("quantity"));
                        item.put("price", rs.getBigDecimal("price"));
                        inventory.add(item);
                    }
                }
            }
        }
    } catch (SQLException e) {
        message = "Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Inventory</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 800px;
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
        select, table {
            width: 100%;
            margin-top: 10px;
        }
        button {
            margin-top: 10px;
            padding: 10px;
            background-color: #0073e6;
            color: white;
            border: none;
            cursor: pointer;
        }
        table {
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #0073e6;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Warehouse Inventory</h1>
        <form action="warehouse.jsp" method="get">
            <label for="warehouseId">Select Warehouse:</label>
            <select id="warehouseId" name="warehouseId" required>
                <option value="" disabled selected>-- Select Warehouse --</option>
                <% for (Map<String, Object> warehouse : warehouses) { %>
                    <option value="<%= warehouse.get("id") %>" 
                            <%= selectedWarehouseId != null && selectedWarehouseId.equals(String.valueOf(warehouse.get("id"))) ? "selected" : "" %>>
                        <%= warehouse.get("name") %>
                    </option>
                <% } %>
            </select>
            <button type="submit">View Inventory</button>
        </form>

        <% if (!inventory.isEmpty()) { %>
            <h2>Inventory Details</h2>
            <table>
                <thead>
                    <tr>
                        <th>Product ID</th>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> item : inventory) { %>
                        <tr>
                            <form action="warehouse.jsp" method="post">
                                <td><%= item.get("productId") %></td>
                                <td><%= item.get("productName") %></td>
                                <td>
                                    <input type="number" name="quantity" value="<%= item.get("quantity") %>" required>
                                </td>
                                <td>
                                    <input type="number" name="price" value="<%= item.get("price") %>" step="0.01" required>
                                </td>
                                <td>
                                    <input type="hidden" name="warehouseId" value="<%= selectedWarehouseId %>">
                                    <input type="hidden" name="productId" value="<%= item.get("productId") %>">
                                    <button type="submit" name="action" value="update">Update</button>
                                    <button type="submit" name="action" value="delete">Delete</button>
                                </td>
                            </form>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else if (selectedWarehouseId != null) { %>
            <p>No inventory found for the selected warehouse.</p>
        <% } %>
        <% if (!message.isEmpty()) { %>
            <p><%= message %></p>
        <% } %>
    </div>
</body>
</html>
