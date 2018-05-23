



<html>
<body>
<h2>the decision support jsp</h2>

<table>
    <tr>
        <td valign="top">
            <jsp:include page="/menu.html" />
        </td>
        <td>

            <%@ page import="java.sql.*"%>

            <%
            Connection connection = null;

            PreparedStatement prepare_statement = null;
            ResultSet result = null;
            try {
                Class.forName("org.postgresql.Driver");

                connection = DriverManager.getConnection("jdbc:postgresql://localhost/cse132?" +
                    "user=postgres&password=admin");
            %>
            <%
                String action = request.getParameter("action");

                if (action != null && (action.equals("showTheDecision_1") || action.equals("showTheDecision_2") || action.equals("showTheDecision_3"))) {
                if (action.equals("showTheDecision_1")) {
                    connection.setAutoCommit(false);

                    prepare_statement = connection.prepareStatement("SELECT theResult.grade, CASE WHEN theResult.gradeCount IS NULL THEN 0 ELSE theResult.gradeCount END FROM (gradeOfABCD AS grade_of_abcd LEFT OUTER JOIN (SELECT substring( student_section.grade from 1 for 1) AS theGrading, count(*) AS gradeCount FROM class class_l, section section, student_section student_section WHERE class_l.course_id = ? AND class_l.year = ? AND class_l.quarter = ? AND class_l.class_id = section.class_id AND section.faculty_id = ? AND section.section_id = student_section.section_id AND stdent_section.grade <> 'f' AND student_section.grade <> 'na' GROUP BY substring(student_section.grade from 1 for 1)) AS result_Lists ON grade_of_abcd.grade = result_Lists.theGrading) AS theResult");

                    prepare_statement.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    prepare_statement.setInt(2, Integer.parseInt(request.getParameter("year")));
                    prepare_statement.setString(3, request.getParameter("quarter"));
                    prepare_statement.setInt(4, Integer.parseInt(request.getParameter("faculty_id")));
                    result = prepare_statement.executeQuery();
                    connection.commit();
                    connection.setAutoCommit(true);
                }

                else if (action.equals("showTheDecision_2")) {

                    connection.setAutoCommit(false);

                    prepare_statement = connection.prepareStatement("SELECT theResult.grade, CASE WHEN theResult.gradeCount IS NULL THEN 0 ELSE theResult.gradeCount END FROM (gradeOfABCD AS grade_of_abcd LEFT OUTER JOIN (SELECT substrinig(student_section.grade from 1 for 1) AS theGrading, count(*) AS gradeCount FROM class class_l, section section, student_section student_section WHERE class_l.course_id = ? AND class_l.class_id = section.class_id AND section.faculty_id = ? AND section.section_id = student_section.section_id AND student_section.grade <> 'f' AND student_section.grade <> 'na' GROUP BY substring(student_section.grade from 1 for 1)) AS result_Lists ON grade_of_abcd.grade = result_Lists.theGrading) AS theResult");
                    prepare_statement.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    prepare_statement.setInt(2, Integer.parseInt(request.getParameter("faculty_id")));

                    result = prepare_statement.executeQuery();
                    connection.commit();
                    connection.setAutoCommit(true);
                }

                else if (action.equals("showTheDecision_3")) {
                    connection.setAutoCommit(false);
                    prepare_statement = connection.prepareStatement("SELECT theResult.grade, CASE WHEN theResult.gradeCount IS NULL THEN 0 ELSE theResult.gradeCount END FROM (gradeOfABCD AS grade_of_abcd LEFT OUTER JOIN (SELECT substring(student_section.grade from 1 for 1) AS theGrading, count(*) AS gradeCount FROM class class_l, section section, student_section student_section WHERE class_l.course_id = ? AND class_l.class_id = section.class_id AND section.section_id = student_section.section_id AND student_section.grade <> 'f' AND student_section.grade <> 'na' GROUP BY substring(student_section.grade from 1 for 1)) AS result_Lists ON grade_of_abcd.grade = result_Lists.theGrading) AS theResult");

                    prepare_statement.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    result = prepare_statement.executeQuery();
                    connection.commit();
                    connection.setAutoCommit(true);
                }


                    %>
                    <table border="1">
                        <tr>
                        <th>The Grade </th>
                        <th>The Count </th>
                        </tr>
                        <%
                            while (result.next()) {
                        %>
                        <tr>
                            <td>
                                <%=result.getString("grade")%>
                            </td>
                            <td>
                                <%=result.getInt("gradeCount")%>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </table>
            <%
                }
                
                else if (action != null && action.equals("showTheDecision_4")) {
                    connection.setAutoCommit(false);

                    prepare_statement = connection.prepareStatement("SELECT SUM(student_section.unit * conversion.grade_number) / SUM(student_section.unit) AS grade FROM class class_l, section section, student_section student_section, conversion conversion WHERE class_l.course_id = ? AND class_l.class_id = section.class_id AND section.faculty_id = ? AND section.section_id = student_section.section_id AND student_section.grade <> 'f' AND student_section.grade = conversion.grade_letter");

                    prepare_statement.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    prepare_statement.setInt(2, Integer.parseInt(request.getParameter("faculty_id")));
                    result = prepare_statement.executeQuery();
                    connection.commit();
                    connection.setAutoCommit(true);
                    %>

                    <%
                        while(result.next()) {
                    %>
                    <p>The Average GPA: <%=result.getFloat("grade")%></p>
                <%
                }
                }
                %>

            <hr>
            <form action="query3_decisionSupport.jsp" method="POST">
            <table border="1">
            <tr>
            <th>The Course Id</th>
            <th>The Faculty Id</th>
            <th>The Year</th>
            <th>The Quarter</th>
            <th></th>
            </tr>
            <tr>
            <input type="hidden" name="action" value="showTheDecision_1"/>

            <td><input value="" name="course_id" size="10"/></td>
            <td><input value="" name="faculty_id" size="10"/></td>
            <td><input value="" name="year" size="10"/></td>
            <td><select name="quarter">
                <option value="WINTER">WINTER</option>
                <option value="SPRING">SPRING</option>
                <option value="SUMMER">SUMMER</option>
                <option value="FALL">FALL</option>
            </select></td>
            <td><input type="submit" value="Submit"/></td>
            </tr>
            </table>
            </form>

            <hr>
            <form action="query3_decisionSupport.jsp" method="POST">
            <table border="1">
            <tr>
            <th>Course Id</th>
            <th>Faculty Id</th>
            <th></th>
            </tr>
            <tr>
            <input type="hidden" name="action" value="showTheDecision_2"/>
            
            <td><input value="" name="course_id" size="10"/></td>
            <td><input value="" name="faculty_id" size="10"/></td>
            <td><input type="submit" value="Submit"/></td>
            </tr>
            </table>
            </form>

            <hr>
            <form action="query3_decisionSupport.jsp" method="POST">
            <table border="1">
            <tr>
            <th>Course Id</th>
            <th></th>
            </tr>
            <tr>
            <input type="hidden" name="action" value="showTheDecision_3"/>

            <td><input value="" name="course_id" size="10"/></td>
            <td><input type="submit" value="Submit"/></td>
            </tr>
            </table>
            </form>

            <hr>
            <form action="query3_decisionSupport.jsp" method="POST">
            <table border="1">
            <tr>
            <th>Course Id</th>
            <th>Faculty Id</th>
            <th></th>
            </tr>
            
            <tr>
            <input type="hidden" name="action" value="showTheDecision_4"/>

            <td><input value="" name="course_id" size="10"/></td>
            <td><input value="" name="faculty_id" size="10"/></td>
            <td><input type="submit" value="Submit"/></td>
            </tr>
            </table>
            </form>

            <%
                if (result != null) {
                    result.close();
                }

                connection.close();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

            finally {
                if (result != null) {
                    try {
                        result.close();
                    } catch (SQLException e) { }
                    result = null;
                }

                if (prepare_statement != null) {
                    try {
                        prepare_statement.close();
                    } catch (SQLException e) { }
                    prepare_statement = null;
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























































