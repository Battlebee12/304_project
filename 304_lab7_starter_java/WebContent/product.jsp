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
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        .product-container {
            max-width: 1000px;
            margin: 60px auto 20px; /* Reduced margin */
            padding: 20px; /* Reduced padding */
            border: 1px solid #ddd;
            border-radius: 6px;
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
            background-color: #ffffff;
        }

        .product-header {
            text-align: center;
            margin-bottom: 20px; /* Reduced spacing */
        }

        .product-header h2 {
            font-size: 2rem; /* Reduced font size */
            font-weight: bold;
            color: #333;
        }

        .product-header p {
            font-size: 1.4rem; /* Reduced font size */
            font-weight: bold;
            color: #28a745;
            margin-top: 8px;
        }

        .product-img {
            max-width: 100%;
            height: auto;
            border-radius: 6px; /* Reduced border radius */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px; /* Reduced spacing */
        }

        .product-description {
            font-size: 1rem; /* Reduced font size */
            line-height: 1.4; /* Adjusted spacing */
            margin-top: 15px; /* Reduced margin */
        }

        .action-btns {
            display: flex;
            justify-content: center;
            gap: 15px; /* Reduced button spacing */
            margin-top: 20px; /* Reduced margin */
        }

        .btn-custom {
            font-size: 1rem; /* Reduced font size */
            padding: 8px 20px; /* Reduced padding */
        }

        .no-image {
            font-size: 1rem; /* Reduced font size */
            color: #888;
        }
    </style>
</head>
<body>
    <%-- Include the header --%>
    <jsp:include page="header.jsp" />

    <%-- Main content --%>
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
                    String sql = "SELECT productname, productPrice, productDesc, productImageURL FROM product WHERE productId = ?";
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
                        String continueShoppingLink = "listprod.jsp"; // Redirect back to product listing
        %>

        <div class="product-header">
            <h2><%= productName %></h2>
            <p><%= NumberFormat.getCurrencyInstance().format(productPrice) %></p>
        </div>

        <div class="row">
            <!-- Product Image -->
            <div class="col-md-6">
                <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                    <img src="<%= productImageURL %>" alt="<%= productName %>" class="product-img" />
                <% } else { %>
                    <p class="no-image">No image available for this product.</p>
                <% } %>
            </div>

            <!-- Product Description -->
            <div class="col-md-6">
                <h4>Description:</h4>
                <p class="product-description">
                    <%= productDescription != null ? productDescription : "No description available." %>
                </p>
            </div>
        </div>

        <div class="action-btns">
            <!-- Add to Cart Button -->
            <a href="<%= addCartLink %>" class="btn btn-primary btn-custom">Add to Cart</a>

            <!-- Continue Shopping Button -->
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
