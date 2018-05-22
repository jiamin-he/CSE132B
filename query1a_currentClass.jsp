

<html>
<body>
<h2>1a: Current class taken by the student with specific ssn</h2>
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

                    pstmt = connection.prepareStatement("select s.ssn, s.firstname, s.middlename, s.lastname, co.course_number, cl.title, ce.section_id, ce.units, ce.grading_option,m.category, m.mdate, m.starttime, m.mlocation, m.endtime from student as s, course_enrollment as ce, course as co, class as cl, meeting as m where s.ssn = ? and s.student_id = ce.student_id and ce.course_id = co.course_id and co.course_id = cl.course_id and m.section_id = ce.section_id");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    result_2 = pstmt.executeQuery();
                    connection.commit();
                    connection.setAutoCommit(true);
                    
                    %>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    <th>course number</th>
                    
                    <th>title </th>
                    <th>section id</th>
                    <th>units</th>
                    <th>grading option</th>
                    <th>category</th>
                    <th>mdate</th>
                    <th>starttime</th>
                    <th>mlocation</th>
                    <th>endtime</th>
                    </tr>
                    <%
                        while (result_2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=result_2.getString("ssn")%>
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
                        <td>
                            <%=result_2.getString("course_number")%>
                        </td>
                        <td>
                            <%=result_2.getString("title")%>
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
                            <%=result_2.getString("category")%>
                        </td>
                        <td>
                            <%=result_2.getString("mdate")%>
                        </td>
                        <td>
                            <%=result_2.getString("starttime")%>
                        </td>
                        <td>
                            <%=result_2.getString("mlocation")%>
                        </td>
                        <td>
                            <%=result_2.getString("endtime")%>
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
                result = statement.executeQuery("SELECT stu.firstname AS first, stu.middlename AS middle, stu.lastname AS last, stu.ssn AS ssn FROM student stu");
            
            %>
            <hr>

            <form action="query1a_currentClass.jsp" method="POST">
            <input type="hidden" name="action" value="showAllClasses"/>
                <select name="showTheSSN">
                <%
                    while (result.next()) {
                    %>
                    <option value='<%=result.getInt("ssn")%>'>
                            <%=result.getInt("ssn")%>, <%=result.getString("last")%>, <%=result.getString("middle")%>, <%=result.getString("first")%>
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



































