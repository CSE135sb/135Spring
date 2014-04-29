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

                if (action != null && action.equals("loginSubmit")) {
                    conn.setAutoCommit(false);
                    
                    String username = request.getParameter("username");
                    stmt = conn.createStatement();
                    
                    rs = stmt.executeQuery("SELECT * FROM users WHERE username = " + username);
					if (rs == null){
						session.setAttribute("username",username);
						response.sendRedirect("/ownermain");
					}
                    int rowCount = pstmt.executeUpdate();

                     
                    conn.commit();
                    conn.setAutoCommit(true);
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
                // Release resources in a finally block in reverse-orde: syntax error at end of input
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











<form action="login/login.jsp" method="POST">
    <input type="hidden" name="action" value="loginSubmit"/>
	<input name="username" type="text"/>
	<br>
	<input type="submit" name="submitButton" value="Submit"/>
</form>
</body>
</html>