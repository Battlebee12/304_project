<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>The Loot</title>
    <style>
    body {
        margin: 0;
        padding: 0;
        font-family: 'Arial', sans-serif;
        background-image: url('img/b1.jpg'); /* Set your image path here */
        
       
        background-position: center center;
        height: 100%;
    }

    .header {
        width: 100%;
        background-color: rgba(0, 123, 255, 0.8); /* Slight transparency so background is visible through header */
        color: white;
        padding: 10px 0;
        text-align: center;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 1000;
        width: 100%;
    }

    .header nav ul {
        margin: 0;
        padding: 0;
        list-style-type: none;
        display: flex;
        justify-content: center;
        gap: 20px;
    }

    .header nav ul li {
        display: inline;
    }

    .header nav ul li a {
        color: white;
        text-decoration: none;
        font-size: 1.2em;
    }

    .header nav ul li a:hover {
        text-decoration: underline;
    }

    .content {
        padding-top: 80px; /* Prevent overlap with fixed header */
        padding: 20px;
        min-height: 100vh;
    }

    .search-bar {
        margin-bottom: 20px;
        display: flex;
        justify-content: center;
        gap: 10px;
        align-items: center;
    }

    .search-bar input[type="text"] {
        padding: 10px 15px;
        font-size: 1em;
        border: 1px solid #ddd;
        border-radius: 25px;
        outline: none;
        width: 300px;
        box-sizing: border-box;
        transition: all 0.3s ease;
    }

    .search-bar input[type="text"]:focus {
        border-color: #007BFF; /* Blue border on focus */
        box-shadow: 0 0 8px rgba(0, 123, 255, 0.4); /* Subtle glow */
    }

    .search-bar select {
        padding: 10px 15px;
        font-size: 1em;
        border: 1px solid #ddd;
        border-radius: 25px;
        background-color: white;
        outline: none;
        transition: all 0.3s ease;
    }

    .search-bar select:focus {
        border-color: #007BFF;
        box-shadow: 0 0 8px rgba(0, 123, 255, 0.4);
    }

    .search-bar button {
        padding: 10px 20px;
        font-size: 1em;
        background-color: #007BFF;
        color: white;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .search-bar button:hover {
        background-color: #0056b3; /* Darker blue on hover */
    }

    h1 {
        font-size: 5em;
        text-align: center;
        margin-bottom: 20px;
        color: #ffffff;
        font-weight: 600;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2); /* Soft text shadow */
    }

    .product-list {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        justify-content: center;
    }

    .product-item {
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 10px;
        width: calc(33% - 20px);
        box-sizing: border-box;
        text-align: center;
        background-color: white;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .product-item:hover {
        transform: translateY(-5px); /* Lift the card on hover */
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2); /* Stronger shadow */
    }

    .product-item img {
        max-width: 100%;
        height: 150px;
        object-fit: cover;
        display: block;
        margin: 0 auto 10px;
    }

    .product-item h3 {
        font-size: 1.2em;
        margin: 10px 0;
    }

    .product-item p {
        font-size: 1em;
        color: #555;
        margin: 5px 0;
    }

    .product-item a {
        text-decoration: none;
        color: #007BFF;
        font-weight: bold;
    }

    .product-item a:hover {
        text-decoration: underline;
    }
</style>

</head>
<body>
    <%-- Include the header --%>
    <jsp:include page="header.jsp" />

    <%-- Main content area --%>
    <div class="content">
        <h1>The Loot</h1>
        <form method="GET" class="search-bar">
            <input type="text" name="search" placeholder="Search products..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <select name="category">
                <option value="">All Categories</option>
                <% 
                    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                    String uid = "sa";
                    String pw = "304#sa#pw";

                    try (Connection con = DriverManager.getConnection(url, uid, pw);
                         Statement stmt = con.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT categoryId, categoryName FROM category")) {
                        while (rs.next()) {
                            int categoryId = rs.getInt("categoryId");
                            String categoryName = rs.getString("categoryName");
                            String selected = (request.getParameter("category") != null && request.getParameter("category").equals(String.valueOf(categoryId))) ? "selected" : "";
                %>
                <option value="<%= categoryId %>" <%= selected %>><%= categoryName %></option>
                <% 
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </select>
            <button type="submit">Search</button>
        </form>

        <%-- Fetch and display products --%>
        <div class="product-list">
            <% 
                String searchQuery = request.getParameter("search");
                String categoryFilter = request.getParameter("category");

                String query = "SELECT productId, productName, productPrice, productImageURL FROM product";
                boolean hasCondition = false;

                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    query += " WHERE productName LIKE ?";
                    hasCondition = true;
                }
                if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                    query += hasCondition ? " AND categoryId = ?" : " WHERE categoryId = ?";
                }

                try (Connection con = DriverManager.getConnection(url, uid, pw);
                     PreparedStatement stmt = con.prepareStatement(query)) {

                    int paramIndex = 1;
                    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                        stmt.setString(paramIndex++, "%" + searchQuery + "%");
                    }
                    if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                        stmt.setInt(paramIndex++, Integer.parseInt(categoryFilter));
                    }

                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        int productId = rs.getInt("productId");
                        String productName = rs.getString("productName");
                        double productPrice = rs.getDouble("productPrice");
                        String productImageURL = rs.getString("productImageURL");
            %>
            <div class="product-item">
                <img src="<%= productImageURL %>" alt="<%= productName %>">
                <h3><a href="product.jsp?id=<%= productId %>"><%= productName %></a></h3>
                <p>Price: $<%= productPrice %></p>
            </div>
            <% 
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
</body>
</html>
