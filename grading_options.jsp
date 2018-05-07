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
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO course_grading_options VALUES (?, ?)");

                        pstmt.setString(1, request.getParameter("course"));
                        pstmt.setString(2, (request.getParameter("option")));

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
                        PreparedStatement pstmt = conn.prepareStatement("UPDATE course_grading_options SET grading_option = ? WHERE course_id = ?");

                        pstmt.setString(1, request.getParameter("option"));
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
                            "DELETE FROM course_grading_options WHERE course_id = ? ");

                        pstmt.setString(1, request.getParameter("course"));
                        
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
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM course_grading_options ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <h4 >course grading options information</h4>
                

                    <tr>

                        <th>course_id</th>
                        <th>grading_option</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="grading_options.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="course" size="10"></th>
                            <th><input value="" name="option" size="10"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="grading_options.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the course_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("course_id") %>" 
                                    name="course" size="10" readonly="true">
                            </td>
    
                            <%-- Get the prerequisites_course_id --%>
                            <td>
                                <input value="<%= rs.getString("grading_option") %>" 
                                    name="option" size="10">
                            </td>

                            
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="grading_options.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden"
                                value="<%= rs.getString("course_id") %>" name="course">
                            
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

