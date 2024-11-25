<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Ray's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%-- <%@ include file="header.jsp" %> --%>

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
        String sql = "SELECT productName, productPrice, productDesc AS productDescription, productImageURL FROM product WHERE productId = ?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, Integer.parseInt(productId));

        ResultSet rst = pst.executeQuery();

        if (rst.next()) {
            String productName = rst.getString("productName");
            double productPrice = rst.getDouble("productPrice");
            String productDescription = rst.getString("productDescription");
            String productImageURL = rst.getString("productImageURL");

            // Display the retrieved details
%>
            <div class="container mt-5">
                <h2>Product Name: <%= productName %></h2>
                <p>Price: <%= NumberFormat.getCurrencyInstance().format(productPrice) %></p>
                <p>Description: <%= productDescription != null ? productDescription : "No description available." %></p>
<%
            // Display the product image if URL is available
            if (productImageURL != null && !productImageURL.isEmpty()) {
%>
                <div>
                    <img src="<%= productImageURL %>" alt="<%= productName %>" style="max-width: 300px; height: auto;">
                </div>
<%
            } else {
                out.println("<p>No image available for this product.</p>");
            }

            // TODO: Retrieve and display image stored in the database via displayImage.jsp
%>
                <p>
                    <a href="displayImage.jsp?productId=<%= productId %>" class="btn btn-primary">View Additional Images</a>
                </p>

                <p>
                    <a href="addToCart.jsp?productId=<%= productId %>" class="btn btn-success">Add to Cart</a>
                    <a href="productList.jsp" class="btn btn-secondary">Continue Shopping</a>
                </p>
            </div>
<%
        } else {
            out.println("<div class='container mt-5'><p>Product not found.</p></div>");
        }

        con.close();
    } catch (Exception e) {
        out.println("<div class='container mt-5'><p>Error: " + e.getMessage() + "</p></div>");
    }
} else {
    out.println("<div class='container mt-5'><p>No product selected.</p></div>");
}
%>

</body>
</html>
