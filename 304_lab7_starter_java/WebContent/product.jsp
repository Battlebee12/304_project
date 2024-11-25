<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ray's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background-color: #f8f9fa;
        }

        .product-header {
            text-align: center;
            margin-bottom: 20px;
        }

        .product-description {
            font-size: 1.2rem;
            line-height: 1.5;
            margin-bottom: 20px;
        }

        .product-img {
            max-width: 100%;
            height: auto;
            margin-bottom: 20px;
        }

        .action-btns {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .btn-custom {
            font-size: 1.1rem;
            padding: 10px 20px;
        }

        .product-price {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }

        .product-name {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
        }

        .product-container .card {
            border: none;
        }
    </style>
</head>
<body>

<%-- Include header (optional) --%>
<%-- <%@ include file="header.jsp" %> --%>

<div class="container product-container">
    <%
        String productId = request.getParameter("id");

        if (productId != null && !productId.isEmpty()) {
            try {
                // Connect to the database
                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String uid = "sa";
                String pw = "304#sa#pw";
                Connection con = DriverManager.getConnection(url, uid, pw);

                // Query to fetch product details
                String sql = "SELECT productname, productPrice, productDesc, productImageURL, productId FROM product WHERE productId = ?";
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setInt(1, Integer.parseInt(productId));

                ResultSet rst = pst.executeQuery();

                if (rst.next()) {
                    // Fetch the product details
                    String productName = rst.getString("productname");
                    double productPrice = rst.getDouble("productPrice");
                    String productDescription = rst.getString("productDesc");
                    String productImageURL = rst.getString("productImageURL"); // Image URL stored in database

                    // Encode the product name for URL
                    String encodedProductName = URLEncoder.encode(productName, "UTF-8");
                    String addCartLink = "addCart.jsp?id=" + productId + "&name=" + encodedProductName + "&price=" + productPrice;
                    String continueShoppingLink = "productListing.jsp"; // Assuming you have a page that lists products
    %>

    <div class="product-header">
        <h2 class="product-name"><%= productName %></h2>
        <p class="product-price"><%= NumberFormat.getCurrencyInstance().format(productPrice) %></p>
    </div>

    <div class="row">
        <!-- Left Image from URL -->
        <div class="col-md-6">
            <h4>Image from URL:</h4>
            <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                <img src="<%= productImageURL %>" alt="<%= productName %>" class="product-img"/>
            <% } else { %>
                <p>No image available from URL.</p>
            <% } %>
        </div>

        <!-- Right Image from Binary Data -->
        <div class="col-md-6">
            <h4>Image from Database (Binary Data):</h4>
            <img src="displayImage.jsp?id=<%= productId %>" alt="<%= productName %>" class="product-img"/>
        </div>
    </div>

    <div class="product-description">
        <h4>Description:</h4>
        <p><%= productDescription != null ? productDescription : "No description available." %></p>
    </div>

    <div class="action-btns">
        <!-- Add to Cart Link -->
        <a href="<%= addCartLink %>" class="btn btn-primary btn-custom">Add to Cart</a>

        <!-- Continue Shopping Link -->
        <a href="<%= continueShoppingLink %>" class="btn btn-secondary btn-custom">Continue Shopping</a>
    </div>

    <% 
                } else {
                    out.println("<p>Product not found.</p>");
                }

                con.close();
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p>No product selected.</p>");
        }
    %>
</div>

<script src="js/bootstrap.bundle.min.js"></script>
</body>
</html>
