<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Treasure Chest - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-container { max-width: 900px; margin: 40px auto; padding: 20px; background-color: #ffffff; border: 1px solid #ddd; border-radius: 6px; box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1); }
        .product-header { text-align: center; }
        .product-header h1 { font-size: 2.5rem; color: #0056b3; margin-bottom: 10px; }
        .product-header p { font-size: 1.5rem; color: #28a745; margin-bottom: 20px; }
        .product-image { display: block; max-width: 100%; max-height: 300px; margin: 20px auto; object-fit: contain; }
        .product-description { font-size: 1.2rem; line-height: 1.6; margin-top: 10px; color: #333; }
        .review-section, .submit-review-section { margin-top: 30px; }
        .review-list { list-style: none; padding: 0; }
        .review-list li { border-bottom: 1px solid #ddd; padding: 10px 0; font-size: 1rem; color: #333; }
        .review-form textarea, .review-form select { width: 100%; margin-bottom: 10px; padding: 8px; font-size: 1rem; }
        .btn { font-size: 1rem; }
        .action-btns { margin-top: 20px; text-align: center; }
        .action-btns a { margin: 10px; padding: 10px 20px; text-decoration: none; color: white; border-radius: 5px; display: inline-block; }
        .btn-primary { background-color: #007bff; }
        .btn-primary:hover { background-color: #0056b3; }
        .btn-secondary { background-color: #6c757d; }
        .btn-secondary:hover { background-color: #565e64; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container product-container">
        <% 
            String productId = request.getParameter("id");
            String message = request.getParameter("message");
            String customerId = (String) session.getAttribute("userId");

            if (productId != null && !productId.isEmpty()) {
                try {
                    // Database connection
                    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                    String uid = "sa";
                    String pw = "304#sa#pw";
                    Connection con = DriverManager.getConnection(url, uid, pw);

                    // Query product details
                    String productSql = "SELECT productName, productPrice, productDesc, productImageURL FROM product WHERE productId = ?";
                    PreparedStatement productPst = con.prepareStatement(productSql);
                    productPst.setInt(1, Integer.parseInt(productId));
                    ResultSet productRs = productPst.executeQuery();

                    if (productRs.next()) {
                        String productName = productRs.getString("productName");
                        double productPrice = productRs.getDouble("productPrice");
                        String productDescription = productRs.getString("productDesc");
                        String productImageURL = productRs.getString("productImageURL");

                        // Encode product name for URL
                        String encodedProductName = URLEncoder.encode(productName, "UTF-8");
                        String addCartLink = "addCart.jsp?id=" + productId + "&name=" + encodedProductName + "&price=" + productPrice;
                        String continueShoppingLink = "listprod.jsp"; // Redirect back to product listing
        %>
        <div class="product-header">
            <h1><%= productName %></h1>
            <p><%= NumberFormat.getCurrencyInstance().format(productPrice) %></p>
        </div>

        <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
            <img src="<%= productImageURL %>" alt="<%= productName %>" class="product-image" />
        <% } else { %>
            <p class="text-center">No image available for this product.</p>
        <% } %>

        <div>
            <h2>Description:</h2>
            <p class="product-description"><%= productDescription != null ? productDescription : "No description available." %></p>
        </div>

        <div class="action-btns">
            <!-- Add to Cart Button -->
            <a href="<%= addCartLink %>" class="btn btn-primary">Add to Cart</a>

            <!-- Continue Shopping Button -->
            <a href="<%= continueShoppingLink %>" class="btn btn-secondary">Continue Shopping</a>
        </div>

        <% 
                        // Query reviews
                        String reviewSql = "SELECT reviewId, reviewRating, reviewComment FROM review WHERE productId = ?";
                        PreparedStatement reviewPst = con.prepareStatement(reviewSql);
                        reviewPst.setInt(1, Integer.parseInt(productId));
                        ResultSet reviewRs = reviewPst.executeQuery();

                        ArrayList<String> reviews = new ArrayList<>();
                        while (reviewRs.next()) {
                            int reviewId = reviewRs.getInt("reviewId");
                            int rating = reviewRs.getInt("reviewRating");
                            String comment = reviewRs.getString("reviewComment");
                            reviews.add("Review " + reviewId + " (" + rating + "/5): " + comment);
                        }
        %>

        <div class="review-section">
            <h2>Reviews:</h2>
            <% if (reviews.isEmpty()) { %>
                <p>No reviews yet. Be the first to review!</p>
            <% } else { %>
                <ul class="review-list">
                    <% for (String review : reviews) { %>
                        <li><%= review %></li>
                    <% } %>
                </ul>
            <% } %>
        </div>

        <div class="submit-review-section">
            <h2>Submit Your Review</h2>
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert alert-info"><%= message %></div>
            <% } %>
            <form method="post" action="submitReview.jsp" class="review-form">
                <input type="hidden" name="customerId" value="<%= customerId %>" />
                <input type="hidden" name="productId" value="<%= productId %>" />
                <label for="reviewRating">Rating (1-5):</label>
                <select name="reviewRating" id="reviewRating" required>
                    <option value="">Select...</option>
                    <% for (int i = 1; i <= 5; i++) { %>
                        <option value="<%= i %>"><%= i %></option>
                    <% } %>
                </select>
                <label for="reviewComment">Comment:</label>
                <textarea name="reviewComment" id="reviewComment" rows="4" placeholder="Write your review..." required></textarea>
                <button type="submit" class="btn btn-primary">Submit Review</button>
            </form>
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
