<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>
                
            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql:cse132?user=postgres&password=admin";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the course_waitlist  attributes INTO the course_waitlist  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO course_waitlist VALUES (?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("student_id"));
                        pstmt.setString(2, (request.getParameter("course_id")));
                        pstmt.setString(3, (request.getParameter("section_id")));
                        pstmt.setString(4, request.getParameter("units"));
                        
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the course_waitlist  attributes in the course_waitlist  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE course_waitlist SET course_id = ?, section_id = ?, " +
                            "units = ? WHERE student_id = ?");

                        pstmt.setString(1, request.getParameter("course_id"));
                        pstmt.setString(2, (request.getParameter("section_id")));
                        pstmt.setString(3, request.getParameter("units"));

                        pstmt.setString(4, request.getParameter("student_id"));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {
                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the course_waitlist  FROM the course_waitlist  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM course_waitlist  WHERE student_id = ?");

                        pstmt.setString(1, request.getParameter("student_id"));
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
                    // the course_waitlist  attributes FROM the course_waitlist  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM course_waitlist ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>student_id</th>
                        <th>course_id</th>
                       <th> section_id</th>
                       <th>units</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="course_waitlist.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="student_id" size="10"></th>
                            <th><input value="" name="course_id" size="10"></th>
                            <th><input value="" name="section_id" size="15"></th>
						    <th><input value="" name="units" size="15"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="course_waitlist.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the student_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("student_id") %>" 
                                    name="student_id" size="10">
                            </td>
    
                            <%-- Get the course_id --%>
                            <td>
                                <input value="<%= rs.getString("course_id") %>" 
                                    name="course_id" size="50">
                            </td>
    
                            <%-- Get the section_id --%>
                            <td>
                                <input value="<%= rs.getString("section_id") %>"
                                    name="section_id" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("units") %>" 
                                    name="units" size="15">
                            </td>
    
			   			       
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="course_waitlist.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("student_id") %>" name="student_id">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>


