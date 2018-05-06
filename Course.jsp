
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
                        // INSERT the Course  attributes INTO the Course  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Course VALUES (?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("course_id"));
    
                        pstmt.setString(2, (request.getParameter("course_number")));
                        pstmt.setString(3, request.getParameter("require_consent"));
                        pstmt.setString(4, request.getParameter("lab_required"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("department_id")));



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
                        // UPDATE the Course  attributes in the Course  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Course SET course_number = ?, require_consent = ?, " +
                            "lab_required = ?,   department_id = ? WHERE course_id = ?");


                        pstmt.setString(1, request.getParameter("course_number"));
                        pstmt.setString(2, request.getParameter("require_consent"));
                        pstmt.setString(3, request.getParameter("lab_required"));

                        pstmt.setInt(4, Integer.parseInt(request.getParameter("department_id")));

                        pstmt.setString(5, request.getParameter("course_id"));

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
                        // DELETE the Course  FROM the Course  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Course  WHERE course_id = ?");

                        pstmt.setString(1, request.getParameter("course_id"));
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
                    // the Course  attributes FROM the Course  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Course ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>course_id</th>
                        <th>course_number</th>
                       <th> require_consent</th>
                       <th>lab_required</th>

                       <th>department_id</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="Course.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="course_id" size="10"></th>
                            <th><input value="" name="course_number" size="10"></th>
                            <th><input value="" name="require_consent" size="15"></th>
						    <th><input value="" name="lab_required" size="15"></th>
						    <th><input value="" name="department_id" size="15"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="Course.jsp" method="get">
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
    
                            <%-- Get the require_consent --%>
                            <td>
                                <input value="<%= rs.getString("require_consent") %>"
                                    name="require_consent" size="15">

                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("lab_required") %>" 
                                    name="lab_required" size="15">
                            </td>
    


<%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("department_id") %>" 
                                    name="department_id" size="15">
                            </td>
    
			   			       
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Course.jsp" method="get">
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
            </td>
        </tr>
    </table>
</body>

</html>