

<html>
<body>
<h2>1c: produce the grade report of student </h2>
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
            ResultSet result_3 = null;
            ResultSet result_4 = null;
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

                    pstmt = connection.prepareStatement("select  s.ssn, s.firstname, s.middlename, s.lastname, co.course_number, cl.title, ce.quarter, ce.units, ce.grading_option, ce.grade from student as s, classes_taken_in_the_past as ce, course as co, class as cl where s.ssn = ? and s.student_id = ce.student_id and ce.course_id = co.course_id and co.course_id = cl.course_id order by ce.quarter");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    result_2 = pstmt.executeQuery();

                    pstmt = connection.prepareStatement("select  s.ssn, s.firstname, s.middlename, s.lastname, ce.quarter,count(co.course_number), sum(gc.number_grade), (ROUND(AVG(gc.number_grade)::numeric,2) ) as gpa from student as s, classes_taken_in_the_past as ce, course as co, class as cl, grade_conversion as gc where s.ssn = ? and s.student_id = ce.student_id and ce.course_id = co.course_id and co.course_id = cl.course_id and gc.letter_grade = ce.grade group by ce.quarter, s.ssn, s.firstname, s.middlename, s.lastname");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    result_3 = pstmt.executeQuery();

                    pstmt = connection.prepareStatement("select  s.ssn, s.firstname, s.middlename, s.lastname,count(co.course_number), sum(gc.number_grade), (ROUND(AVG(gc.number_grade)::numeric,2)) as gpa from student as s, classes_taken_in_the_past as ce, course as co, class as cl, grade_conversion as gc where s.ssn = ? and s.student_id = ce.student_id and ce.course_id = co.course_id and co.course_id = cl.course_id and gc.letter_grade = ce.grade group by s.ssn, s.firstname, s.middlename, s.lastname");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    result_4 = pstmt.executeQuery();

                    connection.commit();
                    connection.setAutoCommit(true);
                    
                    %>

                    <h4>all the classes that have been taken by the student</h4>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    <th>course number</th>
                    
                    <th>title </th>
                    <th>quarter</th>
                    <th>units</th>
                    <th>grading option</th>
                    <th>grade</th>
                    
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
                            <%=result_2.getString("quarter")%>
                        </td>
                        <td>
                            <%=result_2.getInt("units")%>
                        </td>
                        <td>
                            <%=result_2.getString("grading_option")%>
                        </td>
                        <td>
                            <%=result_2.getString("grade")%>
                        </td>
                        
                    </tr>
                    <%
                        }
                    %>
                    </table>

                    <h4>gpa of each quarter</h4>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    <th>quarter</th>
                    <th>count</th>
                    <th>sum</th>
                    <th>gpa</th>
                    
                    </tr>
                    <%
                        while (result_3.next()) {
                    %>
                    <tr>
                        <td>
                            <%=result_3.getString("ssn")%>
                        </td>
                        <td>
                            <%=result_3.getString("firstname")

                            %>
                        </td>
                        <td>
                            <%=result_3.getString("middlename")%>
                        </td>
                        <td>
                            <%=result_3.getString("lastname")%>
                        </td>
                        
                        <td>
                            <%=result_3.getString("quarter")%>
                        </td>
                        <td>
                            <%=result_3.getInt("count")%>
                        </td>
                        <td>
                            <%=result_3.getString("sum")%>
                        </td>
                        <td>
                            <%=result_3.getString("gpa")%>
                        </td>
                        
                    </tr>
                    <%
                        }
                    %>
                    </table>

                    <h4>cumulative gpa</h4>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    <th>count</th>
                    <th>sum</th>
                    <th>gpa</th>
                    
                    </tr>
                    <%
                        while (result_4.next()) {
                    %>
                    <tr>
                        <td>
                            <%=result_4.getString("ssn")%>
                        </td>
                        <td>
                            <%=result_4.getString("firstname")

                            %>
                        </td>
                        <td>
                            <%=result_4.getString("middlename")%>
                        </td>
                        <td>
                            <%=result_4.getString("lastname")%>
                        </td>
                        
                        <td>
                            <%=result_4.getInt("count")%>
                        </td>
                        <td>
                            <%=result_4.getString("sum")%>
                        </td>
                        <td>
                            <%=result_4.getString("gpa")%>
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
                result = statement.executeQuery("SELECT stu.firstname AS first, stu.middlename AS middle, stu.lastname AS last, stu.ssn AS ssn FROM student stu, course_enrollment se WHERE stu.student_id = se.student_id order by stu.ssn");
            
            %>
            <hr>

            <form action="query1c_gradeReport.jsp" method="POST">
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
