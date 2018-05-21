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
                        // INSERT the ms_concentrate  attributes INTO the ms_concentrate  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO concentration VALUES ( ?,?,?, ?)");

                        
                        pstmt.setString(1, (request.getParameter("con_id")));
                        pstmt.setString(2, (request.getParameter("con")));
                        pstmt.setString(3, (request.getParameter("gpa")));
                        pstmt.setString(4, (request.getParameter("units")));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);

                        response.sendRedirect("degree_requirements.jsp");
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
                            "UPDATE concentration SET concentration = ? , min_gpa = ?, min_units = ? WHERE concentrate_id = ? ");

                        pstmt.setString(2, request.getParameter("gpa"));
                        pstmt.setString(1, (request.getParameter("con")));
                        pstmt.setString(3, request.getParameter("units"));
                        pstmt.setString(4, request.getParameter("con_id"));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);

                        response.sendRedirect("degree_requirements.jsp");
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
                            "DELETE FROM concentration  WHERE concentrate_id = ?");

                        
                        pstmt.setString(1, request.getParameter("con_id"));
                        
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);

                        response.sendRedirect("degree_requirements.jsp");
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the ms_concentrate  attributes FROM the ms_concentrate  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM concentration ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <h4 >Concentration Requirements</h4>

                        <th>concentration_id</th>
                       	<th>concentration</th>
                        <th>min_gpa</th>
                        <th>min_units</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="concentration.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            
                            <th><input value="" name="con_id" size="15"></th>
                            <th><input value="" name="con" size="25"></th>
                            <th><input value="" name="gpa" size="10"></th>
                            <th><input value="" name="units" size="10"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
            %>
                    <tr>
                        <form action="concentration.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            
    
                            <%-- Get the concentration --%>
                            <td>
                                <input value="<%= rs.getString("concentrate_id") %>" 
                                    name="con_id" size="15" readonly="true">
                            </td>

                            <td>
                                <input value="<%= rs.getString("concentration") %>" 
                                    name="con" size="25">
                            </td>
    
                            <%-- Get the course_id --%>
                            <td>
                                <input value="<%= rs.getString("min_gpa") %>"
                                    name="gpa" size="10">
                            </td>

                            <td>
                                <input value="<%= rs.getString("min_units") %>"
                                    name="units" size="10">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="concentration.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            
                            <input type="hidden" 
                                value="<%= rs.getString("concentrate_id") %>" name="con_id">
                            
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