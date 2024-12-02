<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - The Treasure Chest</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .register-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .btn {
            font-size: 1rem;
            padding: 10px 15px;
        }
        .alert {
            margin-top: 15px;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
    <div class="container register-container">
        <h1 class="text-center">Register</h1>
        <%
            String message = "";
            boolean success = false;

            if (request.getMethod().equalsIgnoreCase("POST")) {
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phonenum");
                String address = request.getParameter("address");
                String city = request.getParameter("city");
                String state = request.getParameter("state");
                String postalCode = request.getParameter("postalCode");
                String country = request.getParameter("country");
                String userid = request.getParameter("userid");
                String password = request.getParameter("password");

                // Validation
                if (firstName == null || firstName.isEmpty() || 
                    lastName == null || lastName.isEmpty() || 
                    email == null || email.isEmpty() || 
                    !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$") || 
                    phone == null || phone.isEmpty() || 
                    !phone.matches("^\\+?[0-9\\-\\s]+$") || 
                    address == null || address.isEmpty() || 
                    city == null || city.isEmpty() || 
                    state == null || state.isEmpty() || 
                    postalCode == null || postalCode.isEmpty() || 
                    country == null || country.isEmpty() || 
                    userid == null || userid.isEmpty() || 
                    password == null || password.isEmpty()) {
                    
                    message = "Please fill out all fields correctly.";
                } else {
                    try {
                        // Database connection
                        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                        String uid = "sa";
                        String pw = "304#sa#pw";
                        Connection con = DriverManager.getConnection(url, uid, pw);

                        // Check if the userid or email already exists
                        String checkSql = "SELECT COUNT(*) FROM customer WHERE userid = ? OR email = ?";
                        PreparedStatement checkStmt = con.prepareStatement(checkSql);
                        checkStmt.setString(1, userid);
                        checkStmt.setString(2, email);
                        ResultSet checkRs = checkStmt.executeQuery();
                        checkRs.next();
                        int count = checkRs.getInt(1);

                        if (count > 0) {
                            message = "User ID or Email already exists. Please use a different one.";
                        } else {
                            // Insert new user
                            String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                            PreparedStatement pst = con.prepareStatement(sql);
                            pst.setString(1, firstName);
                            pst.setString(2, lastName);
                            pst.setString(3, email);
                            pst.setString(4, phone);
                            pst.setString(5, address);
                            pst.setString(6, city);
                            pst.setString(7, state);
                            pst.setString(8, postalCode);
                            pst.setString(9, country);
                            pst.setString(10, userid);
                            pst.setString(11, password);

                            int rowsAffected = pst.executeUpdate();
                            if (rowsAffected > 0) {
                                success = true;
                                message = "Account created successfully! You can now log in.";
                            } else {
                                message = "Failed to create an account. Please try again.";
                            }
                        }

                        con.close();
                    } catch (Exception e) {
                        message = "Error: " + e.getMessage();
                    }
                }
            }
        %>

        <% if (!message.isEmpty()) { %>
            <div class="alert <%= success ? "alert-success" : "alert-danger" %>">
                <%= message %>
            </div>
        <% } %>

        <form method="post" action="register.jsp">
            <div class="form-group">
                <label for="firstName">First Name:</label>
                <input type="text" id="firstName" name="firstName" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name:</label>
                <input type="text" id="lastName" name="lastName" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="phonenum">Phone Number:</label>
                <input type="text" id="phonenum" name="phonenum" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="city">City:</label>
                <input type="text" id="city" name="city" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="state">State:</label>
                <input type="text" id="state" name="state" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="postalCode">Postal Code:</label>
                <input type="text" id="postalCode" name="postalCode" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="country">Country:</label>
                <input type="text" id="country" name="country" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="userid">User ID:</label>
                <input type="text" id="userid" name="userid" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">Register</button>
        </form>
    </div>
</body>
</html>
