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
                        // INSERT the Class  attributes INTO the Class  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Class VALUES (?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("class_id"));
                        pstmt.setString(2, (request.getParameter("title")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
                        pstmt.setString(4, request.getParameter("quarter"));
                        pstmt.setString(5, request.getParameter("course_id"));



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
                        // UPDATE the Class  attributes in the Class  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Class SET title = ?, year = ?, " +
                            "quarter = ?, course_id = ? WHERE class_id = ?");


                        pstmt.setString(1, request.getParameter("title"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("year")));
                        pstmt.setString(3, request.getParameter("quarter"));

                        pstmt.setString(4, request.getParameter("course_id"));

                        pstmt.setString(5, request.getParameter("class_id"));

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
                        // DELETE the Class  FROM the Class  table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM class  WHERE class_id = ?");

                        pstmt.setString(1, request.getParameter("class_id"));
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
                    // the Class  attributes FROM the Class  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Class ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>class_id</th>
                        <th>title</th>
                       <th> year</th>
                       <th>quarter</th>

                       <th>course_id</th>

                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="class.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="class_id" size="10"></th>
                            <th><input value="" name="title" size="10"></th>
                            <th><input value="" name="year" size="15"></th>
						    <th><input value="" name="quarter" size="15"></th>
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
                        <form action="class.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the class_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("class_id") %>" 
                                    name="class_id" size="10" readonly="true">
                            </td>
    
                            <%-- Get the title --%>
                            <td>
                                <input value="<%= rs.getString("title") %>" 
                                    name="title" size="50">
                            </td>
    
                            <%-- Get the year --%>
                            <td>
                                <input value="<%= rs.getString("year") %>"
                                    name="year" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("quarter") %>" 
                                    name="quarter" size="15">
                            </td>
    


<%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("course_id") %>" 
                                    name="course_id" size="15">
                            </td>
    
			   			       
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="class.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("class_id") %>" name="class_id">
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