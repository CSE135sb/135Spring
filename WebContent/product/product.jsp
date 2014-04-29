<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>product Page</title>
</head>
<body>
<h2>This is a product page here</h2>
<table>
	<tr>
		<td>
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
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135?" +
                    "user=postgres&password=postgres");
            %>
            
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insertProduct")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // INSERT product values INTO the product table.
                    pstmt = conn
                    .prepareStatement("INSERT INTO product (p_name, sku, price) VALUES (?, ?, ?)");

                    //pstmt.setInt(1, Integer.parseInt(request.getParameter("pid")));
                    //pstmt.setString(2, request.getParameter("first"));
                    pstmt.setString(1, request.getParameter("p_name"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("price")));
                    
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("updateProduct")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // UPDATE product values in the product table.
                    pstmt = conn
                        .prepareStatement("UPDATE product SET p_name = ?, sku = ?, price = ? WHERE id = ?");

                    
                    pstmt.setString(1, request.getParameter("p_name"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("price")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("id")));
                    
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
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
                        .prepareStatement("DELETE FROM product WHERE id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>        

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM product");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
            	<th>ID</th>
                <th>Product Name</th>
                <th>SKU</th>
                <th>Price</th>
            </tr>

            <tr>
                <form action="product.jsp" method="POST">
                    <input type="hidden" name="action" value="insertProduct"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="p_name" size="10"/></th>
                    <th><input value="" name="sku" size="15"/></th>
                    <th><input value="" name="price" size="15"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="product.jsp" method="POST">
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
                
                <%-- Get the price --%>
                <td>
                    <input value="<%=rs.getInt("price")%>" name="price" size="15"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                
                </form>
                
                
                <form action="product.jsp" method="POST">
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

</body>
</html>