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
                        // INSERT the department  attributes INTO the department  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO department VALUES (?, ?)");


                        pstmt.setString(1, request.getParameter("department_id"));
                        pstmt.setString(2, (request.getParameter("department_name")));
                   
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
                        // UPDATE the department  attributes in the department  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE department SET department_name = ? WHERE department_id = ?");

                        pstmt.setString(1, request.getParameter("department_name"));

                        pstmt.setString(2, request.getParameter("department_id"));

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
                        // DELETE the department  FROM the department  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM department  WHERE department_id = ?");

                        pstmt.setString(1, request.getParameter("department_id"));
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
                    // the department  attributes FROM the department  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM department ");
            %>








            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>   
                        <h4 >departments</h4>
                        <th>department_id</th>
                        <th>department_name</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="department.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="department_id" size="10"></th>
                            <th><input value="" name="department_name" size="10"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="department.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the department_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("department_id") %>" 
                                    name="department_id" size="10" readonly="true">
                            </td>
    
                            <%-- Get the department_name --%>
                            <td>
                                <input value="<%= rs.getString("department_name") %>" 
                                    name="department_name" size="50">
                            </td>
    
                            <%-- Get the rdate --%>
                            <%-- Get the LASTNAME --%>    
			   			       
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="department.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("department_id") %>" name="department_id">
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

