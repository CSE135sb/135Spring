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
            System.out.println("FLAG0");
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
            
            <%-- -------- SUBMIT Code -------- --%>
            <%
                String action = request.getParameter("action");

                if (action != null && action.equals("signupSubmit")) {
                    conn.setAutoCommit(false);
                    
                    String username = request.getParameter("username");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM users WHERE username = " + username);
					if (rs != null){
						pstmt = conn
						.prepareStatement("INSERT INTO users (username, role, age, state) VALUES (?, ?, ?, ?)");
						pstmt.setString(1, username);
						pstmt.setString(2, request.getParameter("role"));
						pstmt.setString(3, request.getParameter("age"));
						pstmt.setString(4, request.getParameter("state"));
					}
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                if (rs!= null)
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











<form action="signup/signup.jsp" method="POST">
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
	<label>Age: </label>
	<input name="age" type="text"/>
	<br>
	<label>State: : </label>
	<select name="state">
		<option value="Arizona">Arizona</option>
		<option value="Arkansas">Arkansas</option>
		<option value="California">California</option>
	</select>
	<br>
	<input type="submit" name="submitButton" value="Submit"/>
</form>
<label>Already signed up? </label><a href="login">Login.</a>
</body>
</html>