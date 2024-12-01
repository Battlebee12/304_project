<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        h1 {
            color: #2c3e50;
            text-align: center;
        }
        h2 {
            text-align: center;
            color: #555;
        }
        table {
            width: 60%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #3498db;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .form-container {
            width: 60%;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-container input[type="text"], .form-container input[type="email"], .form-container input[type="tel"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .form-container input[type="submit"] {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .form-container input[type="submit"]:hover {
            background-color: #2980b9;
        }
        .header-container {
            width: 100%;
        }
    </style>
</head>
<body>

<!-- Include the header spanning full width -->
<div class="header-container">
    <jsp:include page="header.jsp" />
</div>

<%@ include file="auth.jsp" %>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    // Retrieve the logged-in user's username and userId
    String userName = (String) session.getAttribute("username");
    String userId = (String) session.getAttribute("userId");

    // Check if the user is authenticated
    if (userName == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Define the SQL query to fetch customer details
    String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country "
               + "FROM customer WHERE customerId = ?";
    String firstName = "", lastName = "", email = "", phone = "", address = "", city = "", state = "", postalCode = "", country = "";

    try {
        getConnection();

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userId); // Use userId from session to retrieve customer data
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("firstName");
            lastName = rs.getString("lastName");
            email = rs.getString("email");
            phone = rs.getString("phonenum");
            address = rs.getString("address");
            city = rs.getString("city");
            state = rs.getString("state");
            postalCode = rs.getString("postalCode");
            country = rs.getString("country");
        } else {
            out.println("<p style='color:red;'>Error: Customer information not found!</p>");
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
    } finally {
        closeConnection();
    }
%>

<h1>Welcome, <%= firstName + " " + lastName %></h1>
<h2>Your Information</h2>
<form class="form-container" action="customer.jsp" method="post">
    <label>First Name:</label>
    <input type="text" name="firstName" value="<%= firstName %>">

    <label>Last Name:</label>
    <input type="text" name="lastName" value="<%= lastName %>">

    <label>Email:</label>
    <input type="email" name="email" value="<%= email %>">

    <label>Phone:</label>
    <input type="tel" name="phone" value="<%= phone %>">

    <label>Address:</label>
    <input type="text" name="address" value="<%= address %>">

    <label>City:</label>
    <input type="text" name="city" value="<%= city %>">

    <label>State:</label>
    <input type="text" name="state" value="<%= state %>">

    <label>Postal Code:</label>
    <input type="text" name="postalCode" value="<%= postalCode %>">

    <label>Country:</label>
    <input type="text" name="country" value="<%= country %>">

    <input type="submit" value="Update Information">
</form>

<%
    // Update customer information if the form is submitted
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        firstName = request.getParameter("firstName");
        lastName = request.getParameter("lastName");
        email = request.getParameter("email");
        phone = request.getParameter("phone");
        address = request.getParameter("address");
        city = request.getParameter("city");
        state = request.getParameter("state");
        postalCode = request.getParameter("postalCode");
        country = request.getParameter("country");

        String updateSql = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE customerId = ?";
        try {
            getConnection();

            PreparedStatement updatePstmt = con.prepareStatement(updateSql);
            updatePstmt.setString(1, firstName);
            updatePstmt.setString(2, lastName);
            updatePstmt.setString(3, email);
            updatePstmt.setString(4, phone);
            updatePstmt.setString(5, address);
            updatePstmt.setString(6, city);
            updatePstmt.setString(7, state);
            updatePstmt.setString(8, postalCode);
            updatePstmt.setString(9, country);
            updatePstmt.setString(10, userId);

            int rowsUpdated = updatePstmt.executeUpdate();
            if (rowsUpdated > 0) {
                out.println("<p style='color:green;'>Your information has been successfully updated!</p>");
            } else {
                out.println("<p style='color:red;'>Error: Could not update information!</p>");
            }
        } catch (SQLException e) {
            out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
        } finally {
            closeConnection();
        }
    }
%>

</body>
</html>
