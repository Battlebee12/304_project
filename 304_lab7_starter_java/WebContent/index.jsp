<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home Page</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            color: white;
        }

        header {
            background-color: #333;
            color: white;
            padding: 20px 20px;
            text-align: center;
            font-size: 1.5em;
            z-index: 10; /* Ensure header is always on top */
        }

        .background {
            position: relative;
            width: 100%;
            height: 100vh;
            overflow: hidden;
        }

        .background video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: -1; /* Ensure video stays behind all content */
        }

        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* Dark overlay for readability */
            z-index: 0; /* Stays above the video but below the content */
        }

        .content {
            position: relative; /* Allows layering on top of the video */
            text-align: center;
            padding: 50px 20px;
            z-index: 1; /* Content appears on top of the overlay */
        }

        .content h1 {
            font-size: 3em;
            margin-bottom: 20px;
        }

        .content p {
            font-size: 1.5em;
            margin-bottom: 30px;
        }

        .button-container {
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .button-container a {
            text-decoration: none;
            color: white;
            background-color: #007BFF;
            padding: 15px 25px;
            border-radius: 5px;
            font-size: 1.2em;
            transition: 0.3s ease;
        }

        .button-container a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <!-- Include the header -->
    <jsp:include page="header.jsp" />

    <!-- Background Section with Video -->
    <div class="background">
        <video autoplay muted loop>
            <source src="img/v1.mp4" type="video/mp4">
            <!-- Fallback message in case the video can't be loaded -->
            Your browser does not support the video tag.
        </video>
        <div class="overlay"></div>

        <!-- Main content section -->
        <div class="content">
            <h1>Welcome to Our Online Store</h1>
            <p>Your one-stop shop for all your needs!</p>

            <!-- Buttons for usual homepage features -->
            <div class="button-container">
                <a href="listprod.jsp">Browse Products</a>
                <a href="showcart.jsp">View Cart</a>
                <a href="login.jsp">Login/Register</a>
            </div>
        </div>
    </div>
</body>
</html>
