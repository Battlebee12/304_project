<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>


<% 
try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";        
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw);
    Statement stmt = con.createStatement()) {

// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered

if(custId==null){
	out.println("You have entered NULLLL");
}else{
	try{
		boolean valCustId = false;
		String s= "SELECT customerId FROM customer";
		ResultSet res = stmt.executeQuery(s);
		while(res.next()){
			int idli = res.getInt("customerId");
			if(idli==Integer.parseInt(custId)){
				valCustId = true;
			}
		}
		if(!valCustId){
			out.println("The customer Id is not valid");
		}


	}catch(NumberFormatException e){
		out.println("You have not entered a number");
	}

}




// Determine if there are products in the shopping cart
if (productList == null || productList.isEmpty()) {
    out.println("Your shopping cart is empty");
} 



// If either are not true, display an error message
// Have done this above
// Make connection


// Save order information to database

double total = 0;

if (productList != null) {
    
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = entry.getValue();

        if (product.size() == 4) {
			// We need the productList's arraylist to have 4 values as needed
            try {
                // Price at index 2, Quantity at index 3
                double price = Double.parseDouble(product.get(2).toString());
                int quantity = Integer.parseInt(product.get(3).toString());
                total += price * quantity;
            } catch (NumberFormatException e) {
                out.println("Invalid data for product: " + product.get(0));
            }
        }
    }
	out.println(total);
}
double totalAmount = total;
String khao = "SELECT address, city, state, postalCode, country FROM customer WHERE customerId=?";
PreparedStatement sts = con.prepareStatement(khao);
sts.setString(1,custId);
ResultSet khila = sts.executeQuery();
khila.next();
String stoAddress= khila.getString("address");
String stoCity= khila.getString("city");
String stoState = khila.getString("state");
String stoPostalCode= khila.getString("postalCode");
String stoCountry= khila.getString("country");

String insertOrderSQL = "INSERT INTO ordersummary (totalAmount, customerId, orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry) VALUES (?, ?, GETDATE(), ?, ?, ?, ?, ?)";
PreparedStatement pstmt = con.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);

pstmt.setDouble(1, totalAmount);
pstmt.setString(2, custId);
pstmt.setString(3, stoAddress);
pstmt.setString(4, stoCity);
pstmt.setString(5, stoState);
pstmt.setString(6, stoPostalCode);
pstmt.setString(7, stoCountry);

pstmt.executeUpdate();
ResultSet generatedKeys = pstmt.getGeneratedKeys();

int orderId = -1;
if (generatedKeys.next()) {
    orderId = generatedKeys.getInt(1);
    out.println("Order has been successfully placed \n Your Order ID is " + orderId);
} else {
    out.println("Order ID could not be generated.");
}







	// // Use retrieval of auto-generated keys.
	// PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	// ResultSet keys = pstmt.getGeneratedKeys();
	// keys.next();
	// int orderId = keys.getInt(1);


// Insert each item into OrderProduct table using OrderId from previous INSERT

if (orderId > 0) {
	// Just checking if the order Id is greatre=er than 0
    String insertOrderProductSQL = "INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
    PreparedStatement productStmt = con.prepareStatement(insertOrderProductSQL);

    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = entry.getValue();

        if (product.size() == 4) {
            // try {
                String productId = product.get(0).toString();
                double price = Double.parseDouble(product.get(2).toString());
                int quantity = Integer.parseInt(product.get(3).toString());
                productStmt.setInt(1, orderId);         
                productStmt.setString(2, productId);    
                productStmt.setInt(3, quantity);        
                productStmt.setDouble(4, price);        
                productStmt.executeUpdate();
			
            // } catch (NumberFormatException e) {
            //     out.println("Invalid data for product: " + product.get(0));
            // }
        }
    }

    productStmt.close();
} else {
    out.println("Not able to insert into OrderProduct table");
}


// Update total amount for order record
// Done above when updating the database (orderSummary) with the order details

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary
out.println();
out.println("<h2>Order Summary</h2>");
out.println("<table border='1'><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
while (iterator.hasNext()) {
    Map.Entry<String, ArrayList<Object>> entry = iterator.next();
    ArrayList<Object> product = entry.getValue();

    if (product.size() == 4) {
        String productId = product.get(0).toString();
        String productName = product.get(1).toString();
        int quantity = Integer.parseInt(product.get(3).toString());
        double price = Double.parseDouble(product.get(2).toString());
        double totalProductPrice = price * quantity;
        
        out.println("<tr>");
        out.println("<td>" + productId + "</td>");
        out.println("<td>" + productName + "</td>");
        out.println("<td>" + quantity + "</td>");
        out.println("<td>" + price + "</td>");
        out.println("<td>" + totalProductPrice + "</td>");
        out.println("</tr>");
    }
}

out.println("<tr><td colspan='4'><strong>Total</strong></td><td>" + totalAmount + "</td></tr>");
out.println("</table>");

    // Order placed successfully, display confirmation
    String customerQuery = "SELECT firstName, lastName, address, city, state, postalCode, country FROM customer WHERE customerId=?";
    PreparedStatement customerStmt = con.prepareStatement(customerQuery);
    customerStmt.setString(1, custId);
    ResultSet customerRes = customerStmt.executeQuery();
    
    if (customerRes.next()) {
        String firstName = customerRes.getString("firstName");
        String lastName = customerRes.getString("lastName");
        String fullName = firstName + " " + lastName;
        out.println("<h2>Order completed. Will be shipped soon...</h2>");
        out.println("<p>Your order reference number is: " + orderId + "</p>");
        out.println("<h3>Shipping to customer:</h3>");
        out.println("<h3>1 Name: " + fullName + "</h3>");
        
    } else {
        out.println("<p>Error retrieving customer information.</p>");
    }


// Clear cart if order placed successfully
session.setAttribute("productList", null);


}
%>
</BODY>
</HTML>

