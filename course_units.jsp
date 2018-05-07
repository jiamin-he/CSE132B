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
                        // INSERT the course_prerequisites  attributes INTO the course_prerequisites  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO course_units VALUES (?, ?)");

                        pstmt.setString(1, request.getParameter("course"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("unit"))); 
                        

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
                        PreparedStatement pstmt = conn.prepareStatement("UPDATE course_units SET units = ? WHERE course_id = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("unit")));
                        pstmt.setString(2, request.getParameter("course"));
                        

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
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM course_units WHERE course_id = ? and units = ? ");

                        pstmt.setString(1, request.getParameter("course"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("unit")));
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
                    // the course_prerequisites  attributes FROM the course_prerequisites  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM course_units ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <h4 >graduation course categories requirement</h4>
                

                    <tr>

                        <th>course_id</th>
                        <th>units</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="course_units.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="course" size="10"></th>
                            <th><input value="" name="unit" size="10"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="course_units.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the course_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("course_id") %>" 
                                    name="course" size="10" readonly="true">
                            </td>
    
                            <%-- Get the prerequisites_course_id --%>
                            <td>
                                <input value="<%= rs.getInt("units") %>" 
                                    name="unit" size="10">
                            </td>

                            
       
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="course_units.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden"
                                value="<%= rs.getString("course_id") %>" name="course">
                            <input type="hidden"
                                value="<%= rs.getInt("units") %>" name="unit">
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

