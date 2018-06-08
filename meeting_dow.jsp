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
                            "INSERT INTO meeting_dow VALUES (?, ?)");

                        pstmt.setString(1, request.getParameter("meeting_id"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("dow")));
                        
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                        response.sendRedirect("class.jsp");
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
                        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM meeting_dow WHERE meeting_id = ? and dow = ?");

                        pstmt.setString(1, request.getParameter("meeting_id"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("dow")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                        response.sendRedirect("class.jsp");
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the course_categories  attributes FROM the course_categories  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM meeting_dow order by meeting_id");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <h4 >Meeting DOW</h4>
                
                        <th>meeting_id</th>
                        <th> dow</th>
                       
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="meeting_dow.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="meeting_id" size="10"></th>
                            <th><input value="" name="dow" size="10"></th>
                            
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="meeting_dow.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the degree_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("meeting_id") %>" 
                                    name="sec" size="10" readonly="true">
                            </td>
    
                            <%-- Get the course_category --%>
                            <td>
                                <input value="<%= rs.getInt("dow") %>" 
                                    name="lim" size="15">
                            </td>
    
                            
                               
                           
                        </form>
                        <form action="meeting_dow.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("meeting_id") %>" name="meeting_id">
                                <input type="hidden" 
                                value="<%= rs.getString("dow") %>" name="dow">
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

