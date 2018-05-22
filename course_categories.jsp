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
                        // INSERT the course_categories  attributes INTO the course_categories  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO course_categories VALUES (?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("degree_id"));
                        pstmt.setString(2, (request.getParameter("course_category")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("min_units")));
                        pstmt.setString(4, request.getParameter("min_avg_grade"));
 
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                        response.sendRedirect("degree_requirements.jsp");
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the course_categories  attributes in the course_categories  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE course_categories SET course_category = ?, min_units = ?, " +
                            "min_avg_grade = ? WHERE degree_id = ? and course_category = ?");

                        pstmt.setString(1, request.getParameter("course_category"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("min_units")));
                        pstmt.setString(3, request.getParameter("min_avg_grade"));

                        pstmt.setString(4, request.getParameter("degree_id"));
                        pstmt.setString(5, request.getParameter("old_course_category"));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                        response.sendRedirect("degree_requirements.jsp");
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the course_categories  FROM the course_categories  table.
                        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM course_categories WHERE degree_id = ?");

                        pstmt.setString(1, request.getParameter("degree_id"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                        response.sendRedirect("degree_requirements.jsp");
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the course_categories  attributes FROM the course_categories  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM course_categories ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <h4 >graduation course category requirements</h4>
                
                        <th>degree_id</th>
                        <th>course_category</th>
                       <th> min_units</th>
                       <th>min_avg_grade</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="course_categories.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="degree_id" size="10"></th>
                            <th><input value="" name="course_category" size="35"></th>
                            <th><input value="" name="min_units" size="15"></th>
                            <th><input value="" name="min_avg_grade" size="15"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="course_categories.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the degree_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("degree_id") %>" 
                                    name="degree_id" size="10" readonly="true">
                            </td>
    
                            <%-- Get the course_category --%>
                            <td>
                                <input value="<%= rs.getString("course_category") %>" 
                                    name="course_category" size="35">
                            </td>
    
                            <%-- Get the min_units --%>
                            <td>
                                <input value="<%= rs.getString("min_units") %>"
                                    name="min_units" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("min_avg_grade") %>" 
                                    name="min_avg_grade" size="15">
                            </td>

                            <input type="hidden" 
                                value="<%= rs.getString("course_category") %>" name="old_course_category">
    
    
                               
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="course_categories.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("degree_id") %>" name="degree_id">
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

