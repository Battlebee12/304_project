<%@ page import="java.sql.*, java.util.*, java.io.*" %>

<%-- Include the header file at the top --%>
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

    // Handle form submission
    String message = "";
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String productName = request.getParameter("productName");
        String productDescription = request.getParameter("productDescription");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        String sql = "INSERT INTO product (productName, productDesc, productPrice, categoryId) VALUES (?, ?, ?, ?)";

        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, productName);
            pstmt.setString(2, productDescription);
            pstmt.setDouble(3, price);
            pstmt.setInt(4, categoryId);

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                message = "Product added successfully!";
            } else {
                message = "Failed to add product.";
            }
            System.out.println(message);
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
    <title>Add New Product</title>
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
        <h1>Add New Product</h1>
        <form action="addProduct.jsp" method="post">
            <label for="productName">Product Name:</label>
            <input type="text" id="productName" name="productName" required>

            <label for="productDescription">Product Description:</label>
            <textarea id="productDescription" name="productDescription" rows="4" required></textarea>

            <label for="price">Price:</label>
            <input type="number" id="price" name="price" step="0.01" min="0" required>

            <label for="categoryId">Category ID:</label>
            <input type="number" id="categoryId" name="categoryId" min="1" required>

            <button type="submit">Add Product</button>
        </form>

        <% if (!message.isEmpty()) { %>
            <p class="message"><%= message %></p>
        <% } %>
    </div>
</body>
</html>
