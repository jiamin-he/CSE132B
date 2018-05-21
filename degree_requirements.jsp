<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td colspan="2">

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
                        // INSERT the degree_requirements  attributes INTO the degree_requirements  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO degree_requirements VALUES (?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("degree_id"));
                        pstmt.setInt(2, Integer.parseInt((request.getParameter("unit"))));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("department_id")));
                        pstmt.setString(4, request.getParameter("cur_degree"));


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
                        // UPDATE the degree_requirements  attributes in the degree_requirements  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE degree_requirements SET unit = ?, department_id = ?, " +
                            "cur_degree = ? WHERE degree_id = ?");


                        pstmt.setInt( 1, Integer.parseInt(request.getParameter("unit")));
                        pstmt.setString(2, request.getParameter("department_id"));
                        pstmt.setString(3, request.getParameter("cur_degree"));

                        pstmt.setString(4, request.getParameter("degree_id"));

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
                        // DELETE the degree_requirements  FROM the degree_requirements  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM degree_requirements  WHERE degree_id = ?");

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
                    // the degree_requirements  attributes FROM the degree_requirements  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM degree_requirements ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <h4>graduation degree requirements</h4>

                        <th>degree_id</th>
                        <th>unit</th>
                       <th> department_id</th>
                       <th>cur_degree</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="degree_requirements.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="degree_id" size="10"></th>
                            <th><input value="" name="unit" size="10"></th>
                            <th><input value="" name="department_id" size="15"></th>
						    <th><input value="" name="cur_degree" size="15"></th>

                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>


                    <tr>
                        <form action="degree_requirements.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the degree_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("degree_id") %>" 
                                    name="degree_id" size="10" readonly="true">
                            </td>
    
                            <%-- Get the unit --%>
                            <td>
                                <input value="<%= rs.getString("unit") %>" 
                                    name="unit" size="10">
                            </td>
    
                            <%-- Get the department_id --%>
                            <td>
                                <input value="<%= rs.getString("department_id") %>"
                                    name="department_id" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("cur_degree") %>" 
                                    name="cur_degree" size="15">
                            </td>
    
    
			   			       
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="degree_requirements.jsp" method="get">
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
        <tr>
            <td> </td>
            <td>
                <jsp:include page="course_categories.jsp" />
            </td>
            
        </tr>
        <tr>
            <td> </td>
            <td>
                <jsp:include page="concentration.jsp" />
                

            </td>
            <td>
                <jsp:include page="ms_concentrate.jsp" />
            </td>
        </tr>
    </table>
</body>

</html>