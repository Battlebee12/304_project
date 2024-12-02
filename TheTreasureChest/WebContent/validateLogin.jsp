<%@ page language="java" import="java.io.*,java.sql.*" %>
<%
    session = request.getSession(true);

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
        session.setAttribute("loginMessage", "Username or password cannot be empty.");
        response.sendRedirect("login.jsp");
        return;
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    boolean isAuthenticated = false;
    String userId = null;

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String sql = "SELECT customerId FROM customer WHERE userid = ? AND password = ?";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, username);
        pst.setString(2, password);

        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            isAuthenticated = true;
            userId = rs.getString("customerId");  // Store customerId
        }
    } catch (SQLException e) {
        session.setAttribute("loginMessage", "Database error: " + e.getMessage());
    }

    if (isAuthenticated) {
        session.removeAttribute("loginMessage");
        session.setAttribute("userId", userId);  // Set userId
        session.setAttribute("username", username);  // Set username
        response.sendRedirect("index.jsp");
    } else {
        session.setAttribute("loginMessage", "Invalid username or password.");
        response.sendRedirect("login.jsp");
    }
%>
