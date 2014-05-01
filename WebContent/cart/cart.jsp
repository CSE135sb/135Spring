<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>product Page</title>
</head>
<body>
<h2>My shopping cart</h2>
<h3>Hello, <%= session.getAttribute( "username" ) %></h3>

<!-- Cart item detail -->
<table border="1">
	<tr><th>Product</th><th>Amount</th><th>Price</th><th>Amount Price</th></tr>
	        <%@ page import="java.sql.*"%>
	        <%@ page import="java.util.ArrayList"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            System.out.println("Restart page");
            Connection conn = null;
            PreparedStatement pstmt = null;
            PreparedStatement pstmt2 = null;
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            ResultSet rs3 = null;
            Statement stmt1 = null;
            Statement stmt2 = null;
            Statement stmt3 = null;
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135?" +
                    "user=postgres&password=postgres");
				conn.setAutoCommit(false);
				stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
				%>
				<%-- GET PRODUCTS code --%>
				<%
				String p_name;
				double price;
				int amount;
				double amountPrice;
				double totalPrice = 0;
				rs1 = stmt1.executeQuery("SELECT * FROM cart_items WHERE owner = '" 
					+ session.getAttribute("user_id") +"'");
				if (rs1.first()){
					rs1.beforeFirst();
					while (rs1.next()){
						p_name = rs1.getString("p_name");
						price = rs1.getDouble("price");
						amount = rs1.getInt("amount");
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
					%>
					<tr><td>Total Price: <%=totalPrice%></td></tr>
					<%
				}
				%>
				<%-- SUBMIT code --%>
				<%
                String action = request.getParameter("action");
				
				if (action != null && action.equals("cartSubmit")) {
                    conn.setAutoCommit(false);
                    try{
                    	Integer.parseInt(request.getParameter("cardNumber"));
                    }catch(NumberFormatException e){
						%><p style="color:red;">Please provide a valid card number.</p>
						  <a href="cart">Retry</a>
						<%
						response.sendRedirect("cart");
						return;
                    }
                    if (!(request.getParameter("cardNumber").isEmpty())){
                    	//TRANSFER FROM cart_items TO purchased_items
                    	stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                    			ResultSet.CONCUR_READ_ONLY);
						rs2 = stmt2.executeQuery("SELECT * FROM cart_items WHERE owner = '"
                    		+ session.getAttribute("user_id") + "'");
						String ordered_p_name;
						int ordered_amount;
						double ordered_price;
						int ordered_owner_id;
						int ordered_product_id;
                    	while(rs2.next()){
                    		ordered_p_name = rs2.getString("p_name");
                    		ordered_amount = rs2.getInt("amount");
                    		ordered_price = rs2.getDouble("price");
                    		ordered_owner_id = rs2.getInt("owner");
                    		ordered_product_id = rs2.getInt("product_id");
                    		pstmt = conn.
                    				prepareStatement("SELECT products.id FROM products WHERE id = '" + ordered_product_id +"'");
                    		rs3 = pstmt.executeQuery();
                    		if (! (rs3.first())){
                    			out.println("Sorry, product '" + ordered_p_name + "' has already been deleted by owner");
                    			response.sendRedirect("cart");
                    		}else{
								pstmt = conn
									.prepareStatement("INSERT INTO purchased_items (p_name, price, amount, owner) VALUES (?, ?, ?, ?)");
								pstmt.setString(1, ordered_p_name);
								pstmt.setDouble(2, ordered_price);
								pstmt.setInt(3, ordered_amount);
								pstmt.setInt(4, ordered_owner_id);
                    		}
                    	}
						pstmt.executeUpdate();
 				
                    	//DELETE FROM cart_items
                    	pstmt2 = conn.prepareStatement("DELETE FROM cart_items WHERE owner = '"
                    		+ session.getAttribute("user_id") + "'");
    					pstmt2.executeUpdate();

                    	//TRANSFER USER TO CONFIRMATION PAGE
 	                    conn.commit();
 						conn.setAutoCommit(true);
						response.sendRedirect("confirmation");
                    }
                }
	            if (rs1 != null)
	                rs1.close();
	            if (rs2 != null)
	                rs2.close();
	            if (rs3 != null)
	                rs3.close();
				if (stmt1 != null)
					stmt1.close();
				if (stmt2 != null)
					stmt2.close();
				if (stmt3 != null)
					stmt3.close();
	            if (conn != null)
	                conn.close();
	        }catch (SQLException e){
	            // Wrap the SQL exception in a runtime exception to propagate
	            // it upwards
	            throw new RuntimeException(e);
	        }finally {
	            // Release resources in a finally block in reverse-order of
	            // their creation

	            if (rs1 != null) {
	                try {
	                    rs1.close();
	                } catch (SQLException e) { } // Ignore
	                rs1 = null;
	            }
	            if (rs2 != null) {
	                try {
	                    rs2.close();
	                } catch (SQLException e) { } // Ignore
	                rs2 = null;
	            }
	            if (rs3 != null) {
	                try {
	                    rs3.close();
	                } catch (SQLException e) { } // Ignore
	                rs3 = null;
	            }
	            if (pstmt != null) {
	                try {
	                    pstmt.close();
	                } catch (SQLException e) { } // Ignore
	                pstmt = null;
	            }
	            if (pstmt2 != null) {
	                try {
	                    pstmt2.close();
	                } catch (SQLException e) { } // Ignore
	                pstmt2 = null;
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

<!-- Purchase button -->
<form action="cart" method="POST">
	<input type="hidden" name="action" value="cartSubmit"/>
	<label>Enter your credit card number: </label>
	<input type="text" name="cardNumber"/>
	<input type="submit" name="orderButton" value="Purchase"/>
</form>
</body>
</html>