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
                        // INSERT the meeting  attributes INTO the meeting  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO meeting VALUES (?, ?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("section_id"));
                        pstmt.setString(2, (request.getParameter("category")));
                        pstmt.setBoolean(3,   Boolean.parseBoolean(request.getParameter("isweekly")));
                        pstmt.setString(4, request.getParameter("mtime"));
                        pstmt.setString(5, request.getParameter("mdate"));


                        pstmt.setString(6, request.getParameter("mlocation"));




                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);

                        response.sendRedirect("class.jsp");
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the meeting  attributes in the meeting  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE meeting SET category = ?, isweekly = ?, " + 
                            "mtime = ?, mdate = ?, mlocation = ? WHERE section_id = ?");

                        pstmt.setString(1, request.getParameter("category"));
                        pstmt.setBoolean(2,  Boolean.parseBoolean(request.getParameter("isweekly")));
                        pstmt.setString(3, request.getParameter("mtime"));
                        pstmt.setString(4, request.getParameter("mdate"));
                        pstmt.setString(5, request.getParameter("mlocation"));
                        pstmt.setString(6, request.getParameter("section_id"));

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
                        // DELETE the meeting  FROM the meeting  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM meeting  WHERE section_id = ?");

                        pstmt.setString(1, request.getParameter("section_id"));
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
                    // the meeting  attributes FROM the meeting  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM meeting ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <h4> Lectures, Discussions, etc. for Sections</h4>
                        <th>section_id</th>
                        <th>category</th>
                       <th> isweekly</th>
                       <th>mtime</th>
                       <th>mdate</th>
                       <th>mlocation</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="meeting.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="section_id" size="10"></th>
                            <th><input value="" name="category" size="10"></th>
                            <th><input value="" name="isweekly" size="15"></th>
						    <th><input value="" name="mtime" size="15"></th>
						    <th><input value="" name="mdate" size="15"></th>
						    <th><input value="" name="mlocation" size="15"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        <form action="meeting.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the section_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("section_id") %>" 
                                    name="section_id" size="10" readonly="true">
                            </td>
    
                            <%-- Get the category --%>
                            <td>
                                <input value="<%= rs.getString("category") %>" 
                                    name="category" size="15">
                            </td>
    
                            <%-- Get the isweekly --%>
                            <td>
                                <input value="<%= rs.getString("isweekly") %>"
                                    name="isweekly" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("mtime") %>" 
                                    name="mtime" size="15">
                            </td>
    


							<%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("mdate") %>" 
                                    name="mdate" size="15">
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("mlocation") %>" 
                                    name="mlocation" size="15">
                            </td>                           

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="meeting.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("section_id") %>" name="section_id">
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