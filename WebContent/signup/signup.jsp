<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sign Up Page</title>
</head>
<body>
<h2>Welcome! Please sign up.</h2>






            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            Statement stmt1 = null;
            Statement stmt2 = null;

            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135?" +
                    "user=postgres&password=postgres");
            %>
            
            <%-- -------- SUBMIT Code -------- --%>
            <%
                String action = request.getParameter("action");
                if (action != null && action.equals("signupSubmit")) {
        
                    conn.setAutoCommit(false);
                    String username = request.getParameter("username");
					if (username.isEmpty()){
						%><b>Your signup failed. Please provide a user name.</b>
						  <a href="signup">Retry</a>
						<%
						return;
					}
                    System.out.println("username = " + username);
                    stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, 
                    		ResultSet.CONCUR_READ_ONLY);
                    stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, 
                    		ResultSet.CONCUR_READ_ONLY);
                    rs1 = stmt1.executeQuery("SELECT * FROM owners WHERE username = '"
                    		+ username + "'");
                    rs2 = stmt2.executeQuery("SELECT * FROM customers WHERE username = '"
                    		+ username+ "'");
					if(!(rs1.next()) && !(rs2.next())){
						if (request.getParameter("role").equals("owner")){
							pstmt = conn
							.prepareStatement("INSERT INTO owners (username, age, state) VALUES (?, ?, ?)");
							pstmt.setString(1, username);
							try{
								pstmt.setInt(2, Integer.parseInt(request.getParameter("age")));
							}catch(NumberFormatException e){
								%><b>Your signup failed. Please provide a valid age.</b>
								  <a href="signup">Retry</a>
								<%
								return;
							}
							pstmt.setString(3, request.getParameter("state"));
							pstmt.executeUpdate();
							response.sendRedirect("login");
						}
						else{
							pstmt = conn
							.prepareStatement("INSERT INTO customers (username, age, state) VALUES (?, ?, ?)");
							pstmt.setString(1, username);
							pstmt.setInt(2, Integer.parseInt(request.getParameter("age")));
							pstmt.setString(3, request.getParameter("state"));
							pstmt.executeUpdate();
							response.sendRedirect("login");
						}
					}else{
						%>
						<p>Your signup failed. Username already exists.</p>
						<%
					}

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                 if (rs1!= null)
                	rs1.close();
            	if (rs2!= null)
            		rs2.close();
 
                // Close the Statement
                if (stmt1 != null)
                	stmt1.close();
                if (stmt2 != null)
                	stmt2.close();

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

                 if (rs2 != null) {
                     try {
                         rs2.close();
                     } catch (SQLException e) { } // Ignore
                     rs2 = null;
                 }
                if (rs1 != null) {
                   try {
                        rs1.close();
                    } catch (SQLException e) { } // Ignore
                    rs1 = null;
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
                    } catch (SQLException e) {} // Ignore
                    conn = null;
                }
            }
           %>











<form action="signup" method="POST">
    <input type="hidden" name="action" value="signupSubmit"/>
    <label>User name: </label>
	<input name="username" type="text"/>
 	<br>
	<label>Role: </label>
	<select name="role">
		<option value="owner">Owner</option>
		<option value="customer">Customer</option>			
	</select>
	<br>
	<label>Age:</label>
	<input name="age" type="text"/>
	<br>
	<label>State: </label>
	<select name="state">
		<option value="Alabama">Alabama</option>
		<option value="Alaska">Alaska</option>
		<option value="Arizona">Arizona</option>
		<option value="Arkansas">Arkansas</option>
		<option value="California">California</option>
		<option value="Colorado">Colorado</option>
		<option value="Connecticut">Connecticut</option>
		<option value="Delaware">Delaware</option>
		<option value="Florida">Florida</option>
		<option value="Georgia">Georgia</option>
		<option value="Hawaii">Hawaii</option>
		<option value="Idaho">Idaho</option>
		<option value="Illinois">Illinois</option>
		<option value="Indiana">Indiana</option>
		<option value="Iowa">Iowa</option>
		<option value="Kansas">Kansas</option>
		<option value="Kentucky">Kentucky</option>
		<option value="Louisiana">Louisiana</option>
		<option value="Maine">Maine</option>
		<option value="Maryland">Maryland</option>
		<option value="Massachusetts">Massachusetts</option>
		<option value="Michigan">Michigan</option>
		<option value="Minnesota">Minnesota</option>
		<option value="Mississippi">Mississippi</option>
		<option value="Missouri">Missouri</option>
		<option value="Montana">Montana</option>
		<option value="Nebraska">Nebraska</option>
		<option value="Nevada">Nevada</option>
		<option value="New Hampshire">New Hampshire</option>
		<option value="New Jersey">New Jersey</option>
		<option value="New Mexico">New Mexico</option>
		<option value="New York">New York</option>
		<option value="North Carolina">North Carolina</option>
		<option value="North Dakota">North Dakota</option>
		<option value="Ohio">Ohio</option>
		<option value="Oklahoma">Oklahoma</option>
		<option value="Oregon">Oregon</option>
		<option value="Pennsylvania">Pennsylvania</option>
		<option value="Rhode Island">Rhode Island</option>
		<option value="South Carolina">South Carolina</option>
		<option value="South Dakota">South Dakota</option>
		<option value="Tennessee">Tennessee</option>
		<option value="Texas">Texas</option>
		<option value="Utah">Utah</option>
		<option value="Vermont">Vermont</option>
		<option value="Virginia">Virginia</option>
		<option value="Washington">Washington</option>
		<option value="West Virginia">West Virginia</option>
		<option value="Wisconsin">Wisconsin</option>
		<option value="Wyoming">Wyoming</option>
		<option value="District of Columbia">District of Columbia</option>
		<option value="American Samoa">American Samoa</option>
		<option value="Guam">Guam</option>
		<option value="Northern Mariana Islands">Northern Mariana Islands</option>
		<option value="Puerto Rico">Puerto Rico</option>
		<option value="U.S. Virgin Islands">U.S. Virgin Islands</option>
		<option value="Others">Others</option>
	</select>
	<br>
	<input type="submit" value="Submit"/>
</form>
<label>Already signed up? </label><a href="login">Login.</a>
</body>
</html>