<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<style>
    /* Body styling */
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        color: #333;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    
    h1 {
        color: #333;
        text-align: center;
        font-size: 2em;
        margin-top: 20px;
    }

    /* Table styling */
    table {
        width: 80%;
        border-collapse: collapse;
        margin: 20px 0;
        background-color: #fff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    
    th, td {
        padding: 15px;
        text-align: left;
    }

    th {
        background-color: #3498db;
        color: #fff;
        font-weight: bold;
        font-size: 1.1em;
    }

    td {
        border-bottom: 1px solid #ddd;
        color: #555;
    }

    tr:last-child td {
        border-bottom: none;
    }

    /* Currency and quantity styling */
    td:last-child, th:last-child {
        text-align: right;
    }

    /* Button styling */
    input[type="submit"], a {
        background-color: #2ecc71;
        color: #fff;
        border: none;
        border-radius: 5px;
        padding: 8px 12px;
        cursor: pointer;
        text-decoration: none;
        font-size: 1em;
        transition: background-color 0.3s ease;
    }

    input[type="submit"]:hover, a:hover {
        background-color: #ff4c4c;
    }

    /* Quantity input styling */
    input[type="number"] {
        width: 50px;
        padding: 5px;
        font-size: 1em;
        text-align: center;
        border: 1px solid #ddd;
        border-radius: 4px;
    }

    /* Checkout and continue shopping links */
    .checkout-container {
        text-align: center;
        margin: 20px 0;
    }
</style>
</head>
<body>

<%
    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    // Check if the form was submitted to update or remove an item
    String updateProductId = request.getParameter("updateProductId");
    String newQuantityStr = request.getParameter("newQuantity");
    String removeProductId = request.getParameter("removeProductId");

    if (removeProductId != null && productList != null) {
        // Remove the product from the cart
        productList.remove(removeProductId);
        out.println("<p style='color:green;'>Item removed from the cart.</p>");
    } else if (updateProductId != null && newQuantityStr != null && productList != null) {
        try {
            int newQuantity = Integer.parseInt(newQuantityStr);
            if (newQuantity > 0) {
                ArrayList<Object> product = productList.get(updateProductId);
                if (product != null) {
                    product.set(3, newQuantity); // Update the quantity in the product array
                }
            } else {
                out.println("<p style='color:red;'>Quantity must be greater than 0.</p>");
            }
        } catch (NumberFormatException e) {
            out.println("<p style='color:red;'>Invalid quantity entered.</p>");
        }
    }

    if (productList == null || productList.isEmpty()) {
        out.println("<H1>Your shopping cart is empty!</H1>");
        productList = new HashMap<String, ArrayList<Object>>();
    } else {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        out.println("<h1>Your Shopping Cart</h1>");
        out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
        out.println("<th>Price</th><th>Subtotal</th><th>Actions</th></tr>");

        double total = 0;
        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
            ArrayList<Object> product = entry.getValue();
            if (product.size() < 4) {
                out.println("Expected product with four entries. Got: " + product);
                continue;
            }

            out.print("<tr><td>" + product.get(0) + "</td>");
            out.print("<td>" + product.get(1) + "</td>");

            // Display quantity with an input field and update button
            out.print("<td align='center'><form method='post' action=''>");
            out.print("<input type='hidden' name='updateProductId' value='" + entry.getKey() + "'/>");
            out.print("<input type='number' name='newQuantity' value='" + product.get(3) + "' min='1' size='2'/>");
            out.print("<input type='submit' value='Update Quantity'/>");
            out.print("</form></td>");

            Object price = product.get(2);
            Object itemqty = product.get(3);
            double pr = 0;
            int qty = 0;

            try {
                pr = Double.parseDouble(price.toString());
            } catch (Exception e) {
                out.println("Invalid price for product: " + product.get(0) + " price: " + price);
            }
            try {
                qty = Integer.parseInt(itemqty.toString());
            } catch (Exception e) {
                out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
            }

            out.print("<td align='right'>" + currFormat.format(pr) + "</td>");
            out.print("<td align='right'>" + currFormat.format(pr * qty) + "</td>");

            // Add a "Remove" button for each product
            out.print("<td><form method='post' action=''>");
            out.print("<input type='hidden' name='removeProductId' value='" + entry.getKey() + "'/>");
            out.print("<input type='submit' value='Remove'/>");
            out.print("</form></td>");

            out.println("</tr>");
            total += pr * qty;
        }
        out.println("<tr><td colspan='4' align='right'><b>Order Total</b></td>"
                + "<td align='right'>" + currFormat.format(total) + "</td><td></td></tr>");
        out.println("</table>");

        out.println("<div class='checkout-container'><h2><a href='checkout.jsp'>Check Out</a></h2></div>");
    }
%>
<div class="checkout-container"><h2><a href="listprod.jsp">Continue Shopping</a></h2></div>
</body>
</html>
