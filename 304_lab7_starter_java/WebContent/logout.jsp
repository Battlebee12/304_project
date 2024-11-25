<%
	// Remove the user from the session to log them out
	session.setAttribute("username",null);
	session.setAttribute("userId",null);
	response.sendRedirect("index.jsp");		// Re-direct to main page
%>

