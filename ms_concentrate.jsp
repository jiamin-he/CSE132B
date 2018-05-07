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
                        // INSERT the ms_concentrate  attributes INTO the ms_concentrate  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO ms_concentrate VALUES (?, ?, ?)");

                        pstmt.setString(1, request.getParameter("degree_id"));
                        pstmt.setString(2, (request.getParameter("concentration")));
                        pstmt.setString(3, (request.getParameter("course_id")));

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
                        // UPDATE the ms_concentrate  attributes in the ms_concentrate  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE ms_concentrate SET concentration = ?, course_id = ? WHERE degree_id = ?");

                        pstmt.setString(1, request.getParameter("concentration"));
                        pstmt.setString(2, (request.getParameter("course_id")));
						pstmt.setString(3, request.getParameter("degree_id"));

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
                        // DELETE the ms_concentrate  FROM the ms_concentrate  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM ms_concentrate  WHERE degree_id = ?");

                        pstmt.setString(1, request.getParameter("degree_id"));
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
                    // the ms_concentrate  attributes FROM the ms_concentrate  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM ms_concentrate ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>degree_id</th>
                        <th>concentration</th>
                       	<th> course_id</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="ms_concentrate.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="degree_id" size="10"></th>
                            <th><input value="" name="concentration" size="10"></th>
                            <th><input value="" name="course_id" size="15"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
            %>
                    <tr>
                        <form action="ms_concentrate.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the degree_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("degree_id") %>" 
                                    name="degree_id" size="10">
                            </td>
    
                            <%-- Get the concentration --%>
                            <td>
                                <input value="<%= rs.getString("concentration") %>" 
                                    name="concentration" size="50">
                            </td>
    
                            <%-- Get the course_id --%>
                            <td>
                                <input value="<%= rs.getString("course_id") %>"
                                    name="course_id" size="15">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="ms_concentrate.jsp" method="get">
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
            </td>
        </tr>
    </table>
</body>

</html>