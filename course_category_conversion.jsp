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

            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the course_number  attributes FROM the course_number  table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM course_category_conversion ");
            %>


            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <h4>course category conversion</h4>
                        
                        <th>category_id</th>
                        <th>name</th>
                        <th>course_id</th>
                       
                        
                    </tr>
                    <tr>
                        
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {

            %>

                    <tr>
                        
                            

                            <%-- Get the course_id, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("category_id") %>" 
                                    name="course_id" size="10" readonly="true">
                            </td>
    
                            <%-- Get the course_number --%>
                            <td>
                                <input value="<%= rs.getString("name") %>" 
                                    name="course_number" size="20" readonly="true">
                            </td>
    
                            <%-- Get the valid_until --%>
                            <td>
                                <input value="<%= rs.getString("course_id") %>"
                                    name="valid_until" size="15" readonly="true">
                            </td>    
			   			    
                        
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

