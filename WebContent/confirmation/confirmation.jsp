<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>product Page</title>
</head>
<body>
	<h2>Thanks for you purchase! Here is your receipt.</h2>
	<h3>
		Hello,
		<%=session.getAttribute("username")%></h3>

	<!-- Purchased item detail -->
	<table border="1">
		<tr>
			<th>Product</th>
			<th>Amount</th>
			<th>Price</th>
			<th>Amount Price</th>
		</tr>
		<%@ page import="java.sql.*"%>
		<%-- -------- Open Connection Code -------- --%>
		<%
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Statement stmt = null;

			try {
				// Registering Postgresql JDBC driver with the DriverManager
				Class.forName("org.postgresql.Driver");

				// Open a connection to the database using DriverManager
				conn = DriverManager
						.getConnection("jdbc:postgresql://localhost/cse135?"
								+ "user=postgres&password=postgres");
				conn.setAutoCommit(false);
				stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
		%>
		<%-- GET PRODUCTS code --%>
		<%
			rs = stmt
						.executeQuery("SELECT * FROM purchased_items WHERE owner = '"
								+ session.getAttribute("user_id") + "'");
				System.out.println("FLAG1");
				if (rs.first()) {
					System.out.println("FLAG2");
					rs.beforeFirst();
					String p_name;
					double price;
					int amount;
					double amountPrice;
					double totalPrice = 0;
					System.out.println("FLAG3");
					while (rs.next()) {
						System.out.println("FLAG4");
						p_name = rs.getString("p_name");
						price = rs.getDouble("price");
						amount = rs.getInt("amount");
						amountPrice = price * amount;
						totalPrice += amountPrice;
		%>
		<tr>
			<td><%=p_name%></td>
			<td><%=amount%></td>
			<td><%=price%></td>
			<td><%=amountPrice%></td>
		</tr>
		<%
			}
					System.out.println("FLAG5");
					conn.setAutoCommit(true);
		%>
		<tr>
			<td>Total Price: <%=totalPrice%></td>
		</tr>
		<%
			}
		%>
		<%-- SUBMIT code --%>
		<%
			String action = request.getParameter("action");
				if (action != null && action.equals("browsing")) {
					System.out.println("FLAG6");
					response.sendRedirect("browsing");
				}
				// Close the ResultSet
				if (rs != null)
					rs.close();
				// Close the Connection
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				// Wrap the SQL exception in a runtime exception to propagate
				// it upwards
				throw new RuntimeException(e);
			} finally {
				// Release resources in a finally block in reverse-order of
				// their creation

				if (rs != null) {
					try {
						rs.close();
					} catch (SQLException e) {
					} // Ignore
					rs = null;
				}
				if (pstmt != null) {
					try {
						pstmt.close();
					} catch (SQLException e) {
					} // Ignore
					pstmt = null;
				}
				if (conn != null) {
					try {
						conn.close();
					} catch (SQLException e) {
					} // Ignore
					conn = null;
				}
			}
		%>
	</table>

	<!-- Transfer button -->
	<form action="confirmation" method="POST">
		<input type="hidden" name="action" value="browsing" /> <input
			type="submit" name="transferButton" value="Continue Browsing" />
	</form>

</body>
</html>