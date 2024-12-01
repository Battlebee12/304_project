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
        padding: 50px 20px; /* Increased padding */
        text-align: center;
        font-size: 2.5em; /* Increased font size */
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
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            z-index: 1; /* Content appears on top of the overlay */
        }

        .content h1 {
            font-size: 4em; /* Increase the font size */
            margin-bottom: 20px;
        }

        .content p {
            font-size: 2em; /* Increase the font size */
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
            padding: 20px 35px; /* Increase button size */
            border-radius: 5px;
            font-size: 1.5em; /* Increase font size */
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
            <h1>Welcome to The Treasure Chest</h1>
            <p>Your one-stop shop for all your needs!</p>

            <!-- Buttons for usual homepage features -->
            <div class="button-container">
				<a href="listprod.jsp">Browse Products</a>
				<% 
					if (session.getAttribute("username") != null) { 
				%>
					<a href="showcart.jsp">View Cart</a>
				<% 
					} 
				%>
				<% 
					if (session.getAttribute("username") == null) { 
				%>
					<a href="login.jsp">Login/Register</a>
				<% 
					} 
				%>
			</div>


        </div>
    </div>
</body>
</html>
