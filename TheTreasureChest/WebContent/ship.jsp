<%-- <%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title> Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
    // Get the order ID from the request (assuming it's passed as a query parameter)
    String orderId = request.getParameter("orderId");

    if (orderId == null || orderId.isEmpty()) {
        out.println("<p>Error: No order ID provided.</p>");
        return;
    }

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean transactionSuccess = true;

    try {
        // Get the connection
        getConnection();
        con.setAutoCommit(false); // Start transaction

        // Check if the order ID exists in the database
        String checkOrderSql = "SELECT * FROM ordersummary WHERE orderId = ?";
        pstmt = con.prepareStatement(checkOrderSql);
        pstmt.setInt(1, Integer.parseInt(orderId));
        rs = pstmt.executeQuery();

        if (!rs.next()) {
            out.println("<p>Error: Order ID " + orderId + " not found in database.</p>");
            return;
        }

        // Retrieve all items in the order (assuming it's stored in orderproduct)
        String getOrderItemsSql = "SELECT op.productId, op.quantity, p.productName, pi.quantity AS availableQty " +
                                  "FROM orderproduct op " +
                                  "JOIN product p ON op.productId = p.productId " +
                                  "JOIN productinventory pi ON op.productId = pi.productId " +
                                  "WHERE op.orderId = ? AND pi.warehouseId = 1"; // Assuming warehouse 1
        pstmt = con.prepareStatement(getOrderItemsSql);
        pstmt.setInt(1, Integer.parseInt(orderId));
        rs = pstmt.executeQuery();

        // Check inventory for each product and process shipment
        Map<Integer, Integer> inventoryToUpdate = new HashMap<>();
        while (rs.next()) {
            int productId = rs.getInt("productId");
            int quantity = rs.getInt("quantity");
            int availableQty = rs.getInt("availableQty");

            if (availableQty < quantity) {
                // If not enough inventory, rollback transaction
                transactionSuccess = false;
                out.println("<p>Error: Not enough inventory for product: " + rs.getString("productName") + "</p>");
                break;
            } else {
                // Store the quantity to update for inventory
                inventoryToUpdate.put(productId, quantity);
            }
        }

        // If inventory check passed, create shipment and update inventory
        if (transactionSuccess) {
            // Insert a new shipment record
            String shipmentSql = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (GETDATE(), 'Shipped for order " + orderId + "', 1)";
            pstmt = con.prepareStatement(shipmentSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.executeUpdate();

            // Get the generated shipment ID
            rs = pstmt.getGeneratedKeys();
            rs.next();
            int shipmentId = rs.getInt(1);

            // Update the inventory for each item
            for (Map.Entry<Integer, Integer> entry : inventoryToUpdate.entrySet()) {
                int productId = entry.getKey();
                int quantityToShip = entry.getValue();

                String updateInventorySql = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
                pstmt = con.prepareStatement(updateInventorySql);
                pstmt.setInt(1, quantityToShip);
                pstmt.setInt(2, productId);
                pstmt.executeUpdate();

                // You can also log this in a shipment item table if required
            }

            // Commit the transaction
            con.commit();
            out.println("<p>Shipment processed successfully for order ID " + orderId + "!</p>");
        } else {
            // Rollback if there's an inventory issue
            con.rollback();
            out.println("<p>Transaction rolled back due to insufficient inventory.</p>");
        }
    } catch (SQLException e) {
        try {
            if (con != null) con.rollback(); // Rollback in case of any error
        } catch (SQLException ex) {
            out.println("<p>Error rolling back: " + ex.getMessage() + "</p>");
        }
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            closeConnection();
        } catch (SQLException e) {
            out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
%>

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html> --%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
// Get order id
String ordId = request.getParameter("orderId");
          
try 
{	
	if (ordId == null || ordId.equals(""))
		out.println("<h1>Invalid order id.</h1>");	
	else
	{					
		// Get database connection
        getConnection();
	            
     	// Check if valid order id
        String sql = "SELECT orderId, productId, quantity, price FROM orderproduct WHERE orderId = ?";	
				      
   		con = DriverManager.getConnection(url, uid, pw);
   		PreparedStatement pstmt = con.prepareStatement(sql);
   		pstmt.setInt(1, Integer.parseInt(ordId));
   		ResultSet rst = pstmt.executeQuery();
   		int orderId=0;
   		String custName = "";

   		if (!rst.next())
   		{
   			out.println("<h1>Invalid order id or no items in order.</h1>");
   		}
   		else
   		{	
   			try
   			{
   				// Turn off auto-commit
   				con.setAutoCommit(false);

	   			// Enter shipment information into database
   	   			sql = "INSERT INTO shipment (shipmentDate, warehouseId) VALUES (?, 1);";   	   	
   	   			pstmt = con.prepareStatement(sql);   	   			
   	   			pstmt.setTimestamp(1, new java.sql.Timestamp(new Date().getTime()));
   	   			pstmt.executeUpdate();
   	   			
   				// Verify that each item has sufficient inventory to be shipped
   				// Update inventory
   				String sqlq = "SELECT quantity FROM productinventory WHERE warehouseId = 1 and productId = ?";
   				PreparedStatement pstmtq = con.prepareStatement(sqlq);  
   				boolean success = true;
   				
   				sql = "UPDATE productinventory SET quantity = ? WHERE warehouseId = 1 and productId = ?";
   				pstmt = con.prepareStatement(sql);   
   				
	   			do
	   			{
	   				int prodId = rst.getInt(2);
	   				int qty = rst.getInt(3);
	   				pstmtq.setInt(1, prodId);
	   				ResultSet resq = pstmtq.executeQuery();
	   				if (!resq.next() || resq.getInt(1) < qty)
	   				{
	   					// No inventory record.
	   					out.println("<h1>Shipment not done. Insufficient inventory for product id: "+prodId+"</h1>");
	   					success = false;	   					
	   					break;
	   				}
	   				
	   				// Update inventory record
	   				int inventory = resq.getInt(1);
	   				pstmt.setInt(1, inventory - qty);
	   				pstmt.setInt(2, prodId);
	   				pstmt.executeUpdate();
	   				
	   				out.println("<h2>Ordered product: "+prodId+" Qty: "+qty+" Previous inventory: "+inventory+" New inventory: "+(inventory-qty)+"</h2><br>");
	   			} while (rst.next());
   				
	   			
   				// Commit or rollback
   				if (!success)
   					con.rollback();
   				else
   				{
   					out.println("<h1>Shipment successfully processed.</h1>");
   					con.commit();   				
   				}
   			}
   			catch (SQLException e)
   			{	con.rollback();  
   				out.println(e);
   			}
   			finally
   			{
	   			// Turn on auto-commit
	   			con.setAutoCommit(true);
   			}
		}
   	}
}
catch (SQLException ex)
{ 	out.println(ex);
}
finally
{
	try
	{
		if (con != null)
			con.close();
	}
	catch (SQLException ex)
	{       out.println(ex);
	}
}  
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>