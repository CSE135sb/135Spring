<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>

	<%@ page import="java.sql.*"%>

	<%
		Connection c_conn = null;
		ResultSet c_rs = null;

		try {
			// Registering Postgresql JDBC driver with the DriverManager
			Class.forName("org.postgresql.Driver");

			// Open a connection to the database using DriverManager
			c_conn = DriverManager
					.getConnection("jdbc:postgresql://localhost/cse135?"
							+ "user=postgres&password=postgres");


	%>


		<%


			} catch (SQLException e) {

				// Wrap the SQL exception in a runtime exception to propagate
				// it upwards
				throw new RuntimeException(e);
			} finally {

				if (c_rs != null) {
					try {
						c_rs.close();
					} catch (SQLException e) {
					} // Ignore
					c_rs = null;
					if (c_conn != null) {
						try {
							c_conn.close();
						} catch (SQLException e) {
						} // Ignore
						c_conn = null;
					}
				}
			}
		%>



</body>
</html>