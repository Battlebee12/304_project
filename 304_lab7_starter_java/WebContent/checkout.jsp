<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ray's Grocery CheckOut Line</title>
</head>
<body>

<h1>Enter your customer ID and password to complete the transaction:</h1>

<form method="get" action="order.jsp">
    <label for="customerId">Customer ID:</label>
    <input type="text" id="customerId" name="customerId" required size="50"><br><br>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required size="50"><br><br>

    <input type="submit" value="Submit">
    <input type="reset" value="Reset">
</form>

</body>
</html>
