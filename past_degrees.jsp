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
                            "INSERT INTO past_degrees VALUES (?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("student"));
                        pstmt.setString(2, request.getParameter("ins"));
                        pstmt.setString(3, request.getParameter("de"));
                        pstmt.setString(4, request.getParameter("ma"));
 
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                        response.sendRedirect("students.jsp");
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
                            "UPDATE past_degrees SET institution = ?, degree = ?, " +
                            "major = ? WHERE student_id = ?");

                        pstmt.setString(1, request.getParameter("ins"));
                        pstmt.setString(2, request.getParameter("de"));
                        pstmt.setString(3, request.getParameter("ma"));
                        pstmt.setString(4, request.getParameter("student"));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                        response.sendRedirect("students.jsp");
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
                        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM past_degrees WHERE student_id = ?");

                        pstmt.setString(1, request.getParameter("student"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                        response.sendRedirect("students.jsp");
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the course_categories  attributes FROM the course_categories  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM past_degrees ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <h4>students' past degrees information</h4>
                
                        <th>student_id</th>
                        <th>institution</th>
                       <th> degree</th>
                       <th>major</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="past_degrees.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="student" size="10"></th>
                            <th><input value="" name="ins" size="30"></th>
                            <th><input value="" name="de" size="15"></th>
                            <th><input value="" name="ma" size="15"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="past_degrees.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the degree_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("student_id") %>" 
                                    name="student" size="10" readonly="true">
                            </td>
    
                            <%-- Get the course_category --%>
                            <td>
                                <input value="<%= rs.getString("institution") %>" 
                                    name="ins" size="30">
                            </td>
    
                            <%-- Get the min_units --%>
                            <td>
                                <input value="<%= rs.getString("degree") %>"
                                    name="de" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("major") %>" 
                                    name="ma" size="15">
                            </td>
    
    
                               
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="past_degrees.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("student_id") %>" name="student">
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

