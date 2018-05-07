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
                            "INSERT INTO graduate VALUES (?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("student"));
                        pstmt.setString(2, request.getParameter("clas"));
                        pstmt.setString(3, request.getParameter("cand"));
                        pstmt.setString(4, request.getParameter("dep"));
                        pstmt.setString(5, request.getParameter("advisor"));
 
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
                            "UPDATE graduate SET classification = ?, candidacy = ?, department_id = ? ," +
                            "advisor = ? WHERE student_id = ?");

                        pstmt.setString(1, request.getParameter("clas"));
                        pstmt.setString(2, request.getParameter("cand"));
                        pstmt.setString(3, request.getParameter("dep"));
                        pstmt.setString(4, request.getParameter("advisor"));
                        pstmt.setString(5, request.getParameter("student"));

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
                        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM graduate WHERE student_id = ?");

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
                        ("SELECT * FROM graduate ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <h4>Graduate students</h4>
                
                        <th>student_id</th>
                        <th>classfication</th>
                       <th> candidacy</th>
                       <th> department_id</th>
                       <th> advisor</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="graduate.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="student" size="10"></th>
                            <th><input value="" name="clas" size="15"></th>
                            <th><input value="" name="cand" size="15"></th>
                            <th><input value="" name="dep" size="15"></th>
                            <th><input value="" name="advisor" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="graduate.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the degree_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("student_id") %>" 
                                    name="student" size="10" readonly="true">
                            </td>
    
                            <%-- Get the course_category --%>
                            <td>
                                <input value="<%= rs.getString("classification") %>" 
                                    name="clas" size="15">
                            </td>
    
                            <%-- Get the min_units --%>
                            <td>
                                <input value="<%= rs.getString("candidacy") %>"
                                    name="cand" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("department_id") %>" 
                                    name="dep" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("advisor") %>" 
                                    name="advisor" size="15">
                            </td>
    
    
                               
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="graduate.jsp" method="get">
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

