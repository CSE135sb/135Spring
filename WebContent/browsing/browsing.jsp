<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Browsing Page</title>
<%@ page import="java.sql.*"%>


</head>
<body>

	<h2>This is a product browsing page</h2>
	<h3>
		Hello,
		<%=session.getAttribute("username")%></h3>


	<label>Search for products</label>
	<table>

		<tr>
			<!-- <form action="product" method="POST"> -->
			<form action="browsing" method="POST">
				<input type="hidden" name="search" value="searchSubmit" /> <input
					type="hidden" name="categoryFilter"
					value="<%=request.getParameter("c_id")%>" /> <input value=""
					name="searchInput" size="15" /> <input type="submit"
					value="Search" />
			</form>
		</tr>

	</table>

	<%-- -------- Open Connection Code -------- --%>
	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		PreparedStatement d_pstmt = null;
		PreparedStatement s_pstmt = null;
		String action = request.getParameter("action");
		String display = request.getParameter("display");
		String search = request.getParameter("search");

		try {
			// Registering Postgresql JDBC driver with the DriverManager
			Class.forName("org.postgresql.Driver");
			// Open a connection to the database using DriverManager
			conn = DriverManager
					.getConnection("jdbc:postgresql://localhost/cse135?"
							+ "user=postgres&password=postgres");
	%>



	<%-- display category table on the side --%>
	<%@ include file="/display_category/display_category.jsp"%>


	<%-- -------- SELECT Statement Code -------- --%>
	<%
		// Use the created statement to SELECT
			// the student attributes FROM the Student table.
			Statement c_statement = c_conn.createStatement();
			c_rs = c_statement.executeQuery("SELECT * FROM categories");
	%>

	<table border="1">
		<tr>
			<th>Category</th>
			<th>ID</th>
		</tr>



		<%-- -------- Iteration Code -------- --%>
		<%
			// Iterate over the ResultSet
				while (c_rs != null && c_rs.next()) {
		%>

		<tr>
			<%-- Get the first name --%>
			<td><%=c_rs.getString("c_name")%></td>

			<%-- Get the id --%>
			<td><%=c_rs.getInt("id")%></td>

			<form action="browsing" method="POST">
				<input type="hidden" name="display" value="displayCategory" /> <input
					type="hidden" name="c_id" value="<%=c_rs.getInt("id")%>" /> <input
					type="hidden" name="search_text"
					value="<%=request.getParameter("searchInput")%>" />
				<td><input type="submit" value="Display" /></td>
			</form>

		</tr>


		<%
			}
		%>

	</table>


	<%-- -------- display category Code -------- --%>
	<%
		//DISPLAY
			if (display != null && display.equals("displayCategory")) {

				System.out.println("in display mode");
				// Begin transaction
				conn.setAutoCommit(false);

				String searchText = request.getParameter("search_text");

				//System.out.println("search_text is: " + searchText );

				//without search text
				if (searchText.equals("null")) {
					d_pstmt = conn
							.prepareStatement("SELECT * FROM products WHERE category_id = ?");

					d_pstmt.setInt(1,
							Integer.parseInt(request.getParameter("c_id")));
				}
				//with search text
				else {
					d_pstmt = conn
							.prepareStatement("SELECT * FROM products WHERE category_id = ? AND p_name LIKE '%"
									+ searchText + "%'");

					d_pstmt.setInt(1,
							Integer.parseInt(request.getParameter("c_id")));
				}
				rs = d_pstmt.executeQuery();

				// Commit transaction
				conn.commit();
				conn.setAutoCommit(true);
			}

			//SEARCH
			else if (search != null && search.equals("searchSubmit")) {

				System.out.println("inside search block");
				// Begin transaction
				conn.setAutoCommit(false);

				String category = request.getParameter("categoryFilter");
				//out.println("category is: " + category);

				String searchInput = request.getParameter("searchInput");
				Statement s_stmt = conn.createStatement();

				if (category.equals("null")) {
					s_pstmt = conn
							.prepareStatement("SELECT * FROM products WHERE p_name LIKE '%"
									+ searchInput + "%'");
				} else {
					s_pstmt = conn
							.prepareStatement("SELECT * FROM products WHERE category_id = ? AND p_name LIKE '%"
									+ searchInput + "%'");
					s_pstmt.setInt(1, Integer.parseInt(category));

					//System.out.println("search input is: " + searchInput);

				}
				rs = s_pstmt.executeQuery();

				conn.commit();
				conn.setAutoCommit(true);
			}

			//display all
			else {
				System.out.println("in all products mode");
				Statement statement = conn.createStatement();

				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				rs = statement.executeQuery("SELECT * FROM products");

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


			<form action="order" method="POST">
				<input type="hidden" name="action" value="orderProduct" /> <input
					type="hidden" value="<%=rs.getInt("id")%>" name="id" /> <input
					type="hidden" value="<%=rs.getString("p_name")%>" name="p_name" />
				<%-- Button --%>
				<td><input type="submit" value="Add to Cart" /></td>
			</form>
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

	<a href="product"> Product Page</a>
	<br>
	<a href="cart"> My Shopping Cart</a>
	
	</body>
</html>