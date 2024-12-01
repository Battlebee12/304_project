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

    // Check if the form was submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String action = request.getParameter("action"); // Action: "update" or "delete"

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            if ("update".equalsIgnoreCase(action)) {
                // Update product
                int productId = Integer.parseInt(request.getParameter("productId"));
                String productName = request.getParameter("productName");
                String productDescription = request.getParameter("productDescription");
                double price = Double.parseDouble(request.getParameter("price"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                String sql = "UPDATE product SET productName = ?, productDesc = ?, productPrice = ?, categoryId = ? WHERE productId = ?";
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setString(1, productName);
                    pstmt.setString(2, productDescription);
                    pstmt.setDouble(3, price);
                    pstmt.setInt(4, categoryId);
                    pstmt.setInt(5, productId);

                    int rowsUpdated = pstmt.executeUpdate();
                    message = (rowsUpdated > 0) ? "Product updated successfully!" : "Failed to update product.";
                }
            } else if ("delete".equalsIgnoreCase(action)) {
                // Delete product
                int productId = Integer.parseInt(request.getParameter("productId"));

                String sql = "DELETE FROM product WHERE productId = ?";
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setInt(1, productId);

                    int rowsDeleted = pstmt.executeUpdate();
                    message = (rowsDeleted > 0) ? "Product deleted successfully!" : "Failed to delete product.";
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
    <title>Update or Delete Product</title>
    <style>
        /* Same CSS as addProduct.jsp */
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
        textarea {
            resize: none;
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
        <h1>Update or Delete Product</h1>
        <form action="updateProduct.jsp" method="post">
            <label for="productId">Product ID:</label>
            <input type="number" id="productId" name="productId" required>

            <label for="productName">Product Name:</label>
            <input type="text" id="productName" name="productName">

            <label for="productDescription">Product Description:</label>
            <textarea id="productDescription" name="productDescription" rows="4"></textarea>

            <label for="price">Price:</label>
            <input type="number" id="price" name="price" step="0.01" min="0">

            <label for="categoryId">Category ID:</label>
            <input type="number" id="categoryId" name="categoryId" min="1">

            <button type="submit" name="action" value="update">Update Product</button>
            <button type="submit" name="action" value="delete" style="background-color: red;">Delete Product</button>
        </form>

        <% if (!message.isEmpty()) { %>
            <p class="message"><%= message %></p>
        <% } %>
    </div>
</body>
</html>
