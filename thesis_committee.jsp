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
                            "INSERT INTO thesis_committee VALUES (?, ?)");

                        
                        
                        pstmt.setString(1, request.getParameter("student"));
                        pstmt.setString(2, request.getParameter("faculty"));
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
                            "UPDATE  thesis_committee SET faculty_id = ? " +
                            "WHERE student_id = ? and faculty_id = ?");

                        pstmt.setString(1, request.getParameter("faculty"));
                        pstmt.setString(2, request.getParameter("student"));
                        pstmt.setString(3, request.getParameter("oldFaculty"));
                
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
                            "DELETE FROM thesis_committee WHERE student_id = ? and faculty_id = ?");

                        pstmt.setString(1, request.getParameter("student"));
                        pstmt.setString(2, request.getParameter("faculty"));
                        
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
                        ("SELECT * FROM thesis_committee");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>studentID</th>
                        <th>facultyID</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="thesis_committee.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="student" size="10" ></th>
                            <th><input value="" name="faculty" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="thesis_committee.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("student_id") %>" 
                                    name="student" size="15" readonly="true">
                            </td>

                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("faculty_id") %>"
                                    name="faculty" size="15">
                            </td>

                            
                            <input type="hidden" 
                                value="<%= rs.getString("faculty_id") %>" name="oldFaculty">
                            
                           
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="thesis_committee.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden"
                                value="<%= rs.getString("student_id") %>" name="student">
                            <input type="hidden" 
                                value="<%= rs.getString("faculty_id") %>" name="faculty">
                            
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
