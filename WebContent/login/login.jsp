<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login Page</title>
</head>
<body>
<h2>Login to our super functional based pages</h2>






            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            Connection conn = null;
            PreparedStatement pstmt = null;
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
            %>
            
            <%-- -------- SUBMIT Code -------- --%>
            <%
                String action = request.getParameter("action");
                if (action != null && action.equals("loginSubmit")) {
                    conn.setAutoCommit(false);

                    String username = request.getParameter("username");
                    stmt1 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                    		ResultSet.CONCUR_READ_ONLY);
                    stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, 
                    		ResultSet.CONCUR_READ_ONLY);
                    stmt3 = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                    		ResultSet.CONCUR_READ_ONLY);
                    rs1 = stmt1.executeQuery("SELECT * FROM owners WHERE username = '" 
                    		+ username + "'");
                    rs2 = stmt2.executeQuery("SELECT * FROM customers WHERE username = '" 
                    		+ username + "'");
					if (rs1.first()){
						rs1.beforeFirst();
						rs3 = stmt3.executeQuery("SELECT owners.id FROM owners WHERE username = '"
							+ username + "'");
	                    rs3.next();
	                  	int id = rs3.getInt("id");
						session.setAttribute("user_id", id);
						session.setAttribute("username",username);
						session.setAttribute("role", "owner");
						System.out.println("login.jsp: user id = " 
							+ session.getAttribute("user_id"));
						System.out.println("login.jsp: user name = "
							+ session.getAttribute("username"));
						System.out.println("login.jsp: role = "
								+ session.getAttribute("role"));
						response.sendRedirect("category");
					}else if (rs2.first()){
						rs2.beforeFirst();
						rs3 = stmt3.executeQuery("SELECT customers.id FROM customers WHERE username = '" 
							+ username + "'");
	                    rs3.next();
	                  	int id = rs3.getInt("id");
						session.setAttribute("user_id", id);
						session.setAttribute("username",username);
						session.setAttribute("role", "customer");
						System.out.println("login.jsp: user id = "
							+ session.getAttribute("user_id"));
						System.out.println("login.jsp: user name = "
								+ session.getAttribute("username"));
						System.out.println("login.jsp: role = "
								+ session.getAttribute("role"));
						session.setAttribute("username", username);
						response.sendRedirect("browsing");
					}else if (username.isEmpty()){
						%><b>Please enter a user name. </b>
						  <a href="login">Retry</a>
						<%
						return;
					}else{
						%><b>User name does not exist. </b>
						  <a href="login">Retry</a>
						<%
						return;						
					}
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                // Close the Statement
                //statement.close();
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

                // Close the Connection
                if (conn != null)
                	conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            finally {
                // Release resources in a finally block in reverse-orde: syntax error at end of input
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
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>











<form action="login" method="POST">
    <input type="hidden" name="action" value="loginSubmit"/>
	<input name="username" type="text"/>
	<br>
	<input type="submit" name="submitButton" value="Submit"/>
</form>
<label>Not a member? </label><a href="signup">Sign up.</a>
</body>
</html>