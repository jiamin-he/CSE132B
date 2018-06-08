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

                        
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO classes_taken_in_the_past VALUES (?, ?, ?, ?,?,?)");

                        
                        
                        pstmt.setString(1, request.getParameter("student"));
                        pstmt.setString(4, request.getParameter("grading"));
                        pstmt.setString(3, request.getParameter("quarter"));
                        pstmt.setString(2, request.getParameter("course_id"));
                        pstmt.setString(6, request.getParameter("grade"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("units")));
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
                            "UPDATE  classes_taken_in_the_past SET course_id = ?, grade = ?, grading_option = ? , quarter = ?, units = ?" +
                            "WHERE student_id = ? and course_id = ? and quarter = ? ");

                        pstmt.setString(1, request.getParameter("course_id"));
                        pstmt.setString(2, request.getParameter("grade"));
                        pstmt.setString(3, request.getParameter("grading"));
                        pstmt.setString(4, request.getParameter("quarter"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("units")));
                        pstmt.setString(6, request.getParameter("student"));
                        pstmt.setString(7, request.getParameter("oldCourse"));
                        pstmt.setString(8, request.getParameter("oldQuarter"));
                        
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
                            "DELETE FROM classes_taken_in_the_past WHERE student_id = ? and course_id = ? and quarter = ?");

                        pstmt.setString(1, request.getParameter("student"));
                        pstmt.setString(2, request.getParameter("course_id"));
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
                        ("SELECT * FROM classes_taken_in_the_past order by student_id");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <h4> Students' past classes</h4>
                        <th>studentID</th>
                        
                        <th>courseID</th>
                        <th>quarter</th>
			            <th>grading_option</th>
                        <th>units</th>
                        <th>grade</th>
                        
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="pastClasses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="student" size="10"></th>
                             
                            
                            <th><input value="" name="course_id" size="10"></th>
                            <th><input value="" name="quarter" size="10"></th>
                            <th><input value="" name="grading" size="15"></th>
                            <th><input value="" name="units" size="15"></th>
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
                                    name="student" size="15" readonly="true">
                            </td>

                            

                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("course_id") %>"
                                    name="course_id" size="15">
                            </td>



                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("quarter") %>"
                                    name="quarter" size="15">
                            </td>

                             <td>
                                <input value="<%= rs.getString("grading_option") %>" 
                                    name="grading" size="15" >
                            </td>
    

                            

                            <td>
                                <input value="<%= rs.getInt("units") %>" 
                                    name="units" size="10">
                            </td>

                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("grade") %>" 
                                    name="grade" size="10">
                            </td>

                            <input type="hidden" 
                                value="<%= rs.getString("course_id") %>" name="oldCourse">

                            <input type="hidden" 
                                value="<%= rs.getString("quarter") %>" name="oldQuarter">

    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="pastClasses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden"
                                value="<%= rs.getString("course_id") %>" name="course_id">
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
