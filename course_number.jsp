<html>


<body>
    
                
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
                        // INSERT the course_number  attributes INTO the course_number  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO course_number VALUES (?, ?, ?)");


                        pstmt.setString(1, request.getParameter("course_id"));
                        pstmt.setString(2, (request.getParameter("course_number")));
                        pstmt.setString(3, (request.getParameter("valid_until")));
                        
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);

                        response.sendRedirect("Course.jsp");
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the course_number  attributes in the course_number  	table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE course_number SET course_number = ?, valid_until = ? " + "WHERE course_id = ?");

                        pstmt.setString(1, request.getParameter("course_number"));
                        pstmt.setString(2, (request.getParameter("valid_until")));
                        pstmt.setString(3, request.getParameter("course_id"));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);

                        response.sendRedirect("Course.jsp");
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the course_number  FROM the course_number  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM course_number  WHERE course_id = ?");

                        pstmt.setString(1, request.getParameter("course_id"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);

                        response.sendRedirect("Course.jsp");
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the course_number  attributes FROM the course_number  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM course_number ");
            %>


            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>course_id</th>
                        <th>course_number</th>
                       <th> valid_until</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="course_number.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="course_id" size="10"></th>
                            <th><input value="" name="course_number" size="10"></th>
                            <th><input value="" name="valid_until" size="15"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="course_number.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the course_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("course_id") %>" 
                                    name="course_id" size="10" readonly="true">
                            </td>
    
                            <%-- Get the course_number --%>
                            <td>
                                <input value="<%= rs.getString("course_number") %>" 
                                    name="course_number" size="10">
                            </td>
    
                            <%-- Get the valid_until --%>
                            <td>
                                <input value="<%= rs.getString("valid_until") %>"
                                    name="valid_until" size="15">
                            </td>    
			   			       
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="course_number.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("course_id") %>" name="course_id">
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
            
</body>

</html>

