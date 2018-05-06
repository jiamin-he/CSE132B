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
                    // Load Oracle Driver class file
                    DriverManager.registerDriver
                        (new org.postgresql.Driver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                        ("jdbc:postgresql:cse132?user=postgres&password=admin" 
                          );

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO classes_taken_in_the_past VALUES (?, ?, ?, ?,?)");

                        
                        
                        pstmt.setString(1, request.getParameter("student"));
                        pstmt.setString(2, request.getParameter("course"));
                        pstmt.setString(3, request.getParameter("quarter"));
                        pstmt.setString(4, request.getParameter("section"));
                        pstmt.setString(5, request.getParameter("grade"));
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
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE  classes_taken_in_the_past SET course_id = ?, grade = ? " +
                            "WHERE student_id = ? and section_id = ? and quarter = ? ");

                        pstmt.setString(1, request.getParameter("course"));
                        pstmt.setString(2, request.getParameter("grade"));
                        pstmt.setString(3, request.getParameter("student"));
                        pstmt.setString(4, request.getParameter("section"));
                        pstmt.setString(5, request.getParameter("quarter"));
                        
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
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM classes_taken_in_the_past WHERE student_id = ? and section_id = ? and quarter = ?");

                        pstmt.setString(1, request.getParameter("student"));
                        pstmt.setString(2, request.getParameter("section"));
                        pstmt.setString(3, request.getParameter("quarter"));
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
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM classes_taken_in_the_past");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>studentID</th>
                        <th>courseID</th>
                        <th>quarter</th>
                        <th>sectionID</th>
			            <th>grade</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="pastClasses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="student" size="10"></th>
                            <th><input value="" name="course" size="10"></th>
                            <th><input value="" name="quarter" size="10"></th>
                            <th><input value="" name="section" size="15"></th>
                            <th><input value="" name="grade" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="pastClasses.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("student_id") %>" 
                                    name="student" size="15">
                            </td>

                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("course_id") %>"
                                    name="course" size="15">
                            </td>

                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("quarter") %>"
                                    name="quarter" size="15">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("section_id") %>" 
                                    name="section" size="10">
                            </td>

                            <%-- Get the courseID, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("grade") %>" 
                                    name="grade" size="10">
                            </td>
    
                            
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="pastClasses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden"
                                value="<%= rs.getString("section_id") %>" name="section">
                            <input type="hidden" 
                                value="<%= rs.getString("student_id") %>" name="student">
                            <input type="hidden" 
                                value="<%= rs.getString("quarter") %>" name="quarter">
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
