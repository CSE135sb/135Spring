<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Product Order Page</title>
<%@ page import="java.sql.*"%>


</head>
<body>

	<h2>This is your shopping cart</h2>
	

		<%-- -------- Open Connection Code -------- --%>
		<%
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Statement stmt = null;
			PreparedStatement d_pstmt = null;
			String action = request.getParameter("action");

			try {
				// Registering Postgresql JDBC driver with the DriverManager
				Class.forName("org.postgresql.Driver");
				// Open a connection to the database using DriverManager
				conn = DriverManager
						.getConnection("jdbc:postgresql://localhost/cse135?"
								+ "user=postgres&password=postgres");
		%>
		
		<%
		
		if (action != null && action.equals("orderProduct")) {

			System.out.println("inside orderProduct block");
			// Begin transaction
			conn.setAutoCommit(false);

			String input = request.getParameter("p_name");
			Statement s_stmt = conn.createStatement();

			pstmt = conn
					.prepareStatement("SELECT * FROM products WHERE p_name = '" + input + "'");

			//System.out.println(searchInput);

			rs = pstmt.executeQuery();

			conn.commit();
			conn.setAutoCommit(true);
		}
		
		
		
		%>
		
		<table border="1">
			<tr>
				<th>ID</th>
				<th>Product Name</th>
				<th>SKU</th>
				<th>Category</th>
				<th>Price</th>
			</tr>


			<%
			// Iterate over the ResultSet for insert, update, delete
			while (rs != null && rs.next()) {
			%>

			<tr>

				<%-- Get the id --%>
				<td><%=rs.getInt("id")%></td>

				<%-- Get the p_name --%>
				<td><input value="<%=rs.getString("p_name")%>" name="p_name"
					size="15" /></td>

				<%-- Get the sku --%>
				<td><input value="<%=rs.getInt("sku")%>" name="sku" size="15" />
				</td>

				<%-- Get the category_id --%>
				<td><input value="<%=rs.getInt("category_id")%>" name="sku"
					size="15" /></td>

				<%-- Get the price --%>
				<td><input value="<%=rs.getInt("price")%>" name="price"
					size="15" /></td>


				
			</tr>

			<%
				}
			%>
		</table>


		<%-- -------- Close Connection Code -------- --%>
		<%
			// Close the ResultSet
				if (rs != null)
					rs.close();

				// Close the Statement
				//statement.close();

				// Close the Connection
				if (conn != null)
					conn.close();
			} catch (SQLException e) {

				// Wrap the SQL exception in a runtime exception to propagate
				// it upwards
				throw new RuntimeException(e);
			} finally {
				// Release resources in a finally block in reverse-orde: syntax error at end of input
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
	
</body>
</html>