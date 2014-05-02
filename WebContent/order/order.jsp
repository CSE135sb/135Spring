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

	<h2>Selected item</h2>
	<h3>Hello, <%= session.getAttribute( "username" ) %></h3>


		<%-- -------- Open Connection Code -------- --%>
		<%
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ResultSet os = null;
			Statement stmt = null;
			PreparedStatement d_pstmt = null;
			PreparedStatement o_pstmt = null;

			String action = request.getParameter("action");
			String add = request.getParameter("add");

			try {
              	if (session.getAttribute("role").equals("owner"))
              	{
              		out.println("Sorry! You don't have the permissions to view this page.");
              	}
              	if (session.getAttribute("role").equals("customer")){
				// Registering Postgresql JDBC driver with the DriverManager
				Class.forName("org.postgresql.Driver");
				// Open a connection to the database using DriverManager
				conn = DriverManager
						.getConnection("jdbc:postgresql://localhost/cse135?"
								+ "user=postgres&password=postgres");
		%>


		<%-- Do action passed in by Browsing page --%>
		<%
		//action was passed in by browsing.jsp 
		if (action != null && action.equals("orderProduct")) {

			System.out.println("inside orderProduct block");
			// Begin transaction
			conn.setAutoCommit(false);

			String product_id = request.getParameter("id");
			Statement s_stmt = conn.createStatement();

			pstmt = conn
					.prepareStatement("SELECT * FROM products WHERE id = '" + product_id + "'");

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
				<th>Amount</th>
			</tr>


			<%
			// Iterate over the PRODUCT item
			while (rs != null && rs.next()) {
			%>
			<tr>

			<form action="order" method="GET">
                    <input type="hidden" name="add" value="add_to_cart"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

				<%-- Get the id --%>
				<td><%=rs.getInt("id")%></td>

				<%-- Get the p_name --%>
				<td><input value="<%=rs.getString("p_name")%>" name="p_name" size="15" readonly="true" /></td>

				<%-- Get the sku --%>
				<td><%=rs.getInt("sku")%></td>

				<%-- Get the category_id --%>
				<td><%=rs.getInt("category_id")%></td>

				<%-- Get the price --%>
				<td><input value="<%=rs.getInt("price")%>" name="price" size="15" readonly="true" /></td>

				<%-- Get the amount --%>
				 <td><input value="" name="amount" size="5"/></td>

				 <td><input type="submit" value="Update"/></td>

		 </form>

			</tr>

			<%
				}
			%>
		</table>


		<%-- Add product to cart_Items db --%>
		<%
		if (add != null && add.equals("add_to_cart")) {

	System.out.println("inside add_to_cart block");
			// Begin transaction
			conn.setAutoCommit(false);

			double price, amount;
			String input = request.getParameter("id");
			int id = Integer.parseInt(input);
			Statement s_stmt = conn.createStatement();

			try
        	{
				String p = request.getParameter("price");
				String a = request.getParameter("amount");
				System.out.println("amount is: " + a);
				System.out.println("price is: " + p);

        		price = Double.parseDouble(p);
        		amount = Double.parseDouble(a);
        	}
        	catch (NumberFormatException e)
        	{
        		price = -1.0;
        		amount = -1.0;
        	}
        	
        	if( amount <= 0 || amount != (long)amount )
        	{
        		out.println("Failure to add to cart.");
        	%>
        	
        	<br>
        	<a href="browsing">Click here to go back to browsing page</a>
        	
        	<%
        		//response.sendRedirect("order");
        	}
        	else {
				pstmt = conn
                    .prepareStatement("INSERT INTO cart_items (p_name, price, amount, owner, product_id) VALUES (?, ?, ?, ?, ?)");
                pstmt.setString(1, request.getParameter("p_name"));
                pstmt.setInt(2, Integer.parseInt(request.getParameter("price")));
                pstmt.setInt(3, Integer.parseInt(request.getParameter("amount")));
                pstmt.setInt(4, (Integer)(session.getAttribute("user_id")));
                pstmt.setInt(5, id);
                System.out.println("product id = " + id);
				System.out.println("FLAG1");
                int rowCount = pstmt.executeUpdate();
				System.out.println("FLAG2");
				conn.commit();
				conn.setAutoCommit(true);
				//handle duplicate submission
				//then redirect to browsing page
				response.sendRedirect("browsing");
        	}
		}
		Statement statement = conn.createStatement();

        // Use the created statement to SELECT
        // the student attributes FROM the Student table.
        os = statement.executeQuery("SELECT * FROM cart_items WHERE owner = '" 
        	+ session.getAttribute("user_id") + "'");
		System.out.println("FLAG3");

		%>
		<h3>Shopping Cart</h3>
		<table border="1">

			<tr>
				<th>ID</th>
				<th>Product Name</th>
				<th>Price</th>
				<th>Amount</th>
				<th>Owner</th>
			</tr>

			<%
			//	iterate through shopping cart
			while (os != null && os.next()) 
			{
			%>
			<tr>

				<%-- Get the id --%>
				<td><%=os.getInt("id")%></td>

				<%-- Get the p_name --%>
				<td><%=os.getString("p_name")%></td>

				<%-- Get the price --%>
				<td><%=os.getInt("price")%></td>

				<%-- Get the amount --%>
				<td><input value="<%=os.getInt("amount")%>" name="amount" size="10" /></td>

				<%-- Get the owner --%>
				<td><%=os.getInt("owner")%></td>

			</tr>

			<%
				}
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