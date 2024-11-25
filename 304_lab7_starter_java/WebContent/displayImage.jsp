<%@ page trimDirectiveWhitespaces="true" import="java.sql.*, java.io.*" %>
<%@ include file="jdbc.jsp" %>
<%
    // Indicate that we are sending a JPG picture
    response.setContentType("image/jpeg");  

    // Get the product id from the request parameter
    String id = request.getParameter("id");

    if (id == null || id.isEmpty()) {
        out.println("Invalid or missing image ID.");
        return;
    }

    int idVal;
    try {
        idVal = Integer.parseInt(id); // Parse product ID
    } catch (NumberFormatException e) {
        out.println("Invalid image ID: " + id + ". Error: " + e.getMessage());
        return;
    }

    String sql = "SELECT productImage FROM product WHERE productId = ?"; // SQL query to fetch binary image

    try {
        // Establish the database connection
        getConnection();

        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, idVal); // Set the product ID in the query
        ResultSet rst = stmt.executeQuery();        

        if (rst.next()) {
            // Fetch the binary image data
            InputStream istream = rst.getBinaryStream("productImage");
            OutputStream ostream = response.getOutputStream();

            int BUFFER_SIZE = 10240; // 10KB buffer
            byte[] data = new byte[BUFFER_SIZE];

            int count;
            while ((count = istream.read(data)) != -1) {
                ostream.write(data, 0, count); // Write the binary data to the output stream
            }

            ostream.close();
            istream.close();
        } else {
            out.println("No image found for the provided ID.");
        }
    } catch (SQLException e) {
        out.println("Database error: " + e.getMessage());
    } finally {
        // Close the database connection
        closeConnection();
    }
%>
