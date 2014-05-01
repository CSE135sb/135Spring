<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>product Page</title>
</head>
<body>
<h2>This is a product page </h2>
<h3>Hello, <%= session.getAttribute( "username" ) %></h3>

<label>Search for products</label>
<table>

		<tr>
			<form search="product" method="POST">
				<input type="hidden" name="search" value="searchSubmit" /> 
				<input type="hidden" name="categoryFilter" value="<%= request.getParameter("c_id") %>" />
				<input value="" name="searchInput" size="15"/>
				<input type="submit" value="Search" />
			</form>
		</tr>

</table>


<table>
	<tr>
		<td valign = "top">
				<b>Choose a category</b>

            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            ResultSet d_rs = null;
            Statement stmt = null;

            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135?" +
                    "user=postgres&password=postgres");
            %>
            
            <%-- -------------- -------------- --%>
			<%
			// Create the statement
            //Statement c_statement = conn.createStatement();
			PreparedStatement d_pstmt = null;
			PreparedStatement s_pstmt = null;

			String action = request.getParameter("action");
			String display = request.getParameter("display");
			String search = request.getParameter("search");

			%>
            	
			<%-- display category table on the side --%>
			<%@ include file="/display_category/display_category.jsp" %>
			<%-- display category table on the side --%>

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

			<form action="product" method="POST">
				<input type="hidden" name="display" value="displayCategory" /> 
				<input type="hidden" name="c_id" value="<%=c_rs.getInt("id")%>" />
				<input type="hidden" name="search_text" value="<%=request.getParameter("searchInput") %>" />
				<td><input type="submit" value="Display" /></td>
			</form>

		</tr>

		<%

				}
		%>

     
            <%-- -------- INSERT Code -------- --%>
            <%
                
            if (action != null && action.equals("insertProduct")) {

        		System.out.println("in insert block.");
        				double price = 0;
        								
        				String sku = request.getParameter("sku");
        				String name = request.getParameter("p_name");
        				if(sku != "")
        				{

        					stmt = conn.createStatement();
        					rs = stmt
        						.executeQuery("SELECT * FROM products WHERE sku = "+ sku);
        	
        					try {
        						price = Double.parseDouble(request.getParameter("price"));
        						} catch (NumberFormatException e) {
        							price = -1.0;
        						}
        					}

        				else if (price < 0 || name == "" || sku == "" || rs.next()) {
        		System.out.println("in if");
        					out.println("Failure to insert a new product.");
        					rs = null;
        				}

        				else {
        		System.out.println("in else");
        					// Begin transaction
        					conn.setAutoCommit(false);

        					// Create the prepared statement and use it to
        					// INSERT product values INTO the product table.
        					pstmt = conn
        						.prepareStatement("INSERT INTO products (p_name, sku, category_id, price) VALUES (?, ?, ?, ?)");

        					pstmt.setString(1, request.getParameter("p_name"));
        					pstmt.setInt(2,Integer.parseInt(request.getParameter("sku")));
        					pstmt.setInt(3, Integer.parseInt(request.getParameter("category_id")));
        					pstmt.setInt(4,Integer.parseInt(request.getParameter("price")));

        					int rowCount = pstmt.executeUpdate();

        					// Commit transaction
        					conn.commit();
        					conn.setAutoCommit(true);
        					response.sendRedirect("product");
        					}
        				}
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("updateProduct")) {
                	
    System.out.println("in update block.");
                	double price;
                	
                	stmt = conn.createStatement();
                	rs = stmt.executeQuery("SELECT * FROM products WHERE sku = " + request.getParameter("sku") + "AND id != " 
                	+ request.getParameter("id"));
                	
                	try
                	{
                		price = Double.parseDouble(request.getParameter("price"));
                	}
                	catch (NumberFormatException e)
                	{
                		price = -1.0;
                	}
                	
                	if( price < 0 || request.getParameter("p_name") == "" || rs.next() )
                	{
                		out.println("Failure to update a product.");
                		rs = null;
                	}
                	else {
	                    // Begin transaction
	                    conn.setAutoCommit(false);

	                    // Create the prepared statement and use it to
	                    // UPDATE product values in the product table.
	                    pstmt = conn
	                        .prepareStatement("UPDATE products SET p_name = ?, sku = ?, category_id = ?, price = ? WHERE id = ?");


	                    pstmt.setString(1, request.getParameter("p_name"));
	                    pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
	                    pstmt.setInt(3, Integer.parseInt(request.getParameter("cid")));
	                    pstmt.setInt(4, Integer.parseInt(request.getParameter("price")));
	                    pstmt.setInt(5, Integer.parseInt(request.getParameter("id")));

	                    int rowCount = pstmt.executeUpdate();

	                    // Commit transaction
	                    conn.commit();
	                    conn.setAutoCommit(true);
	                    response.sendRedirect("product");
                	}
                }
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("deleteProduct")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM products WHERE id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    response.sendRedirect("product");
                }
            %>        

            <%-- -------- SELECT Statement Code (for different feature)-------- --%>
            <%
            if(action != null)
				System.out.println("action is: " + action.toString());
            
            if(search != null)
				System.out.println("search is: " + search.toString());
            
            if(display != null)
				System.out.println("display is: " + display.toString());

			// DISPLAY
			if (display != null && display.equals("displayCategory")) {

	System.out.println("in display mode");
				// Begin transaction
                conn.setAutoCommit(false);

				String searchText = request.getParameter("search_text");

	//System.out.println("search_text is: " + searchText );

				//without search text
				if(searchText.equals("null"))
				{
					d_pstmt = conn
		                	.prepareStatement("SELECT * FROM products WHERE category_id = ?");

		                	d_pstmt.setInt(1, Integer.parseInt(request.getParameter("c_id")));	
				}
				//with search text
				else
				{
                	d_pstmt = conn
                	.prepareStatement("SELECT * FROM products WHERE category_id = ? AND p_name LIKE '%" + searchText + "%'");

                	d_pstmt.setInt(1, Integer.parseInt(request.getParameter("c_id")));
				}
                rs = d_pstmt.executeQuery();

                // Commit transaction
                conn.commit();
                conn.setAutoCommit(true);
            }
 			
 			else if( search != null && (search.equals("searchSubmit")))
            {
 		System.out.println("inside search block");
            	// Begin transaction
                conn.setAutoCommit(false);
            	
            	String category = request.getParameter("categoryFilter");
        //out.println("category is: " + category);  	
          
            	String searchInput = request.getParameter("searchInput");
                Statement s_stmt = conn.createStatement();
               
                if(category.equals("null"))
                {
                	s_pstmt = conn
                            .prepareStatement("SELECT * FROM products WHERE p_name LIKE '%" + searchInput + "%'");
                }
                else
                {
                	s_pstmt = conn
                        .prepareStatement("SELECT * FROM products WHERE category_id = ? AND p_name LIKE '%" + searchInput + "%'");
                	s_pstmt.setInt(1, Integer.parseInt(category));

         //System.out.println("search input is: " + searchInput);
                        
                }
                rs = s_pstmt.executeQuery();
                
                conn.commit();
                conn.setAutoCommit(true);
            } 
			// display all products
			else 
			{

		System.out.println("in all products mode");
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM products");

			}
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
            	<th>ID</th>
                <th>Product Name</th>
                <th>SKU</th>
                <th>Category</th>
                <th>Price</th>
            </tr>

            <tr>
                <form action="product" method="POST">
                    <input type="hidden" name="action" value="insertProduct"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="p_name" size="10"/></th>
                    <th><input value="" name="sku" size="15"/></th>
                    <th><input value="" name="category_id" size="15"/></th>
                    <th><input value="" name="price" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
     
            <%
                // Iterate over the ResultSet for insert, update, delete
                while (rs != null && rs.next()) {
            %>

            <tr>
                <form action="product" method="POST">
                    <input type="hidden" name="action" value="updateProduct"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

				<%-- Get the id --%>
                <td>
                    <%=rs.getInt("id")%>
                </td>

                <%-- Get the p_name --%>
                <td>
                    <input value="<%=rs.getString("p_name")%>" name="p_name" size="15"/>
                </td>

                <%-- Get the sku --%>
                <td>
                    <input value="<%=rs.getInt("sku")%>" name="sku" size="15"/>
                </td>
                
                <%-- Get the category_id --%>
                <td>
                    <input value="<%=rs.getInt("category_id")%>" name="cid" size="15"/>
                </td>
                
                <%-- Get the price --%>
                <td>
                    <input value="<%=rs.getInt("price")%>" name="price" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                
                </form>
                
                
                <form action="product" method="POST">
                    <input type="hidden" name="action" value="deleteProduct"/>
                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
                </form>
            </tr>

            <%
                }
            %>
            
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                if (rs != null)
                	rs.close();
            
            	if (c_rs != null)
					c_rs.close();

				if (c_conn != null)
					c_conn.close(); 

                // Close the Statement
                //statement.close();

                // Close the Connection
                if (conn != null)
                	conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                
                               
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
			</table>
        </td>
    </tr>
</table>

<a href="browsing" > Product Browsing Page </a>
<br>
<a href="browsing" > Category Page </a>

</body>
</html>