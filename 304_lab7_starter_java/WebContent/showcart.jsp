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

        out.println("<h2><a href='checkout.jsp'>Check Out</a></h2>");
    }
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html>
