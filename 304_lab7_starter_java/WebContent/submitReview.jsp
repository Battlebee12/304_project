<%@ page import="java.sql.*" %>
<%
    String productId = request.getParameter("productId");
    String customerId = request.getParameter("customerId");
    String reviewRating = request.getParameter("reviewRating");
    String reviewComment = request.getParameter("reviewComment");

    try {
        // Database connection
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";
        Connection con = DriverManager.getConnection(url, uid, pw);

        // Check if the customer has already reviewed the product
        String checkSql = "SELECT COUNT(*) FROM review WHERE customerId = ? AND productId = ?";
        PreparedStatement checkPst = con.prepareStatement(checkSql);
        checkPst.setString(1, customerId);
        checkPst.setString(2, productId);
        ResultSet rs = checkPst.executeQuery();
        rs.next();
        int count = rs.getInt(1);

        if (count > 0) {
            // If the customer has already reviewed this product, show a message
            response.sendRedirect("product.jsp?id=" + productId + "&message=You have already reviewed this product.");
        } else {
            // If no review exists, insert the new review
            String insertSql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, GETDATE(), ?, ?, ?)";
            PreparedStatement insertPst = con.prepareStatement(insertSql);
            insertPst.setInt(1, Integer.parseInt(reviewRating));
            insertPst.setString(2, customerId);
            insertPst.setString(3, productId);
            insertPst.setString(4, reviewComment);
            insertPst.executeUpdate();

            // Redirect to product page with the review submitted
            response.sendRedirect("product.jsp?id=" + productId);
        }

        con.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
