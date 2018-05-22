

<html>
<body>
<h2>1b: display the roster of class </h2>
<table>
    <tr>
        <td valign="top">
            <jsp:include page="/menu.html" />
        </td>
        <td>
            <%@ page import="java.sql.*"%>
            <%

            Connection connection = null;
            PreparedStatement pstmt = null;
            ResultSet result = null;
            ResultSet result_2 = null;
            try {
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse132?" +
                    "user=postgres&password=admin");
            %>
            <%
                String action = request.getParameter("action");
                if ( action != null && action.equals("showAllClasses")) {
                    connection.setAutoCommit(false);

                    pstmt = connection.prepareStatement("select co.course_number, cl.title, cl.currently_offered, ce.section_id, ce.units, ce.grading_option,s.* from student as s, course_enrollment as ce, course as co, class as cl where cl.title = ? and cl.currently_offered = 'yes' and s.student_id = ce.student_id and ce.course_id = co.course_id and co.course_id = cl.course_id");
                    pstmt.setString( 1, request.getParameter("showTheTitle"));
                    result_2 = pstmt.executeQuery();
                    connection.commit();
                    connection.setAutoCommit(true);
                    
                    %>
                    <table border="1">
                    <tr>
                    <th>course number</th>
                    <th>title </th>
                    <th>quarter</th>
                    <th>year</th>
                    <th>section id</th>
                    <th>units</th>
                    <th>grading option</th>
                    
                    <th>ssn</th>
                    <th>student_id</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    
                    </tr>
                    <%
                        while (result_2.next()) {
                    %>
                    <tr>
                        
                        <td>
                            <%=result_2.getString("course_number")%>
                        </td>
                        <td>
                            <%=result_2.getString("title")%>
                        </td>
                        <td>
                            spring
                        </td>
                        <td>
                            2018
                        </td>
                        <td>
                            <%=result_2.getString("section_id")%>
                        </td>
                        <td>
                            <%=result_2.getInt("units")%>
                        </td>
                        <td>
                            <%=result_2.getString("grading_option")%>
                        </td>
                        <td>
                            <%=result_2.getString("ssn")%>
                        </td>
                        <td>
                            <%=result_2.getString("student_id")

                            %>
                        </td>
                        <td>
                            <%=result_2.getString("firstname")

                            %>
                        </td>
                        <td>
                            <%=result_2.getString("middlename")%>
                        </td>
                        <td>
                            <%=result_2.getString("lastname")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </table>
                    <%
                }
            %>

            <%
                Statement statement = connection.createStatement();
                result = statement.executeQuery("select cl.title from class as cl where cl.currently_offered = 'yes' ");
            
            %>
            <hr>

            <form action="query1b_rosterClass.jsp" method="POST">
            <input type="hidden" name="action" value="showAllClasses"/>
                <select name="showTheTitle">
                <%
                    while (result.next()) {
                    %>
                    <option value='<%=result.getString("title")%>'>
                            <%=result.getString("title")%>, spring, 2018
                    </option>
                    <%
                    }
                %>
                </select>
            <input type="submit" value="Submit"/>
            </form>

            <%
                result.close();
                statement.close();
                connection.close();
            } 
            catch (SQLException e) {
                throw new RuntimeException(e);
            }
            finally {
                if (result != null) {
                    try {
                        result.close();
                    } catch (SQLException e) { }
                    result = null;
                }

                if (result_2 != null) {
                    try {
                        result_2.close();
                    } catch (SQLException e) { }
                    result_2 = null;
                }

                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { }
                    pstmt = null;
                }

                if (connection != null) {
                    try {
                        connection.close();
                    } catch (SQLException e) { } 
                    connection = null;
                }
            }
            %>
        </td>
    </tr>
</table>
</body>
</html>



































