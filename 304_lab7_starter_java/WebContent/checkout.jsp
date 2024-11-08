<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ray's Grocery Checkout</title>
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

        /* Form styling */
        form {
            background-color: #fff;
            width: 80%;
            max-width: 500px;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        label {
            font-size: 1em;
            color: #333;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0 20px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            box-sizing: border-box;
        }

        /* Button styling */
        input[type="submit"],
        input[type="reset"] {
            background-color: #2ecc71;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 1em;
            margin: 5px;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover,
        input[type="reset"]:hover {
            background-color: #ff4c4c;
        }
    </style>
</head>
<body>

<h1>Enter Your Customer ID and Password to Complete the Transaction:</h1>

<form method="get" action="order.jsp">
    <label for="customerId">Customer ID:</label>
    <input type="text" id="customerId" name="customerId" required>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>

    <input type="submit" value="Submit">
    <input type="reset" value="Reset">
</form>

</body>
</html>
