

<html>
<body>
<h2>Class schedule taken by the student with specific ssn</h2>
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

                    pstmt = connection.prepareStatement("SELECT class1.title AS noClassTitle, class1.course_id AS noCourseId, meeting_1.mDate AS noDay, meeting_1.startTime AS noStart, meeting_1.endTime AS noEnd, class_2.title AS conflictingClassTitles, class_2.course_id AS conflictingCourseId, meeting_2.startTime AS conflictingStart, meeting_2.endTime AS conflictingEnd FROM student stu, section section1, class class1, meeting meeting_1, section section_2, class class_2, meeting meeting_2, studentSection stu_sec_2 WHERE stu.ssn = ? AND stu.student_id = stu_sec_2.student_id AND stu_sec_2.section_id = section_2.section_id AND section_2.class_id = class_2.class_id AND meeting_2.section_id = section_2.section_id AND class_2.year = 2018 AND class_2.quarter = 'SPRING' AND section1.class_id = class1.class_id AND meeting_1.section_id = section1.section_id AND class1.year = 2018 AND class1.quarter = 'SPRING' AND CAST( meeting_2.startTime AS Time) < CAST(meeting_1.endTime AS Time) AND CAST(meeting_2.endTime AS Time) > CAST(meeting_1.startTime AS Time) AND meeting_2.mDate = meeting_1.mDate AND meeting_2.section_id <> meeting_1.section_id");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    result_2 = pstmt.executeQuery();
                    connection.commit();
                    connection.setAutoCommit(true);
                    
                    %>
                    <table border="1">
                    <tr>
                    <th>No Class Title </th>
                    <th>No Course Id </th>
                    <th>No Start Time </th>
                    <th>No End Time </th>
                    <th>No mDate </th>
                    
                    <th>Conflicting Class Title </th>
                    <th>Conflicting Course Id </th>
                    <th>Conflicting Start Time </th>
                    <th>Conflicting End Time </th>
                    </tr>
                    <%
                        while (result_2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=result_2.getString("noClassTitle")%>
                        </td>
                        <td>
                            <%=result_2.getInt("noCourseId")

                            %>
                        </td>
                        <td>
                            <%=result_2.getString("noStart")%>
                        </td>
                        <td>
                            <%=result_2.getString("noEnd")%>
                        </td>
                        <td>
                            <%=result_2.getInt("noDay")%>
                        </td>
                        <td>
                            <%=result_2.getString("conflictingClassTitles")%>
                        </td>
                        <td>
                            <%=result_2.getInt("conflictingCourseId")%>
                        </td>
                        <td>
                            <%=result_2.getString("conflictingStart")%>
                        </td>
                        <td>
                            <%=result_2.getString("conflictingEnd")%>
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
                result = statement.executeQuery("SELECT stu.first_name AS first, stu.middle_name AS middle, stu.last_name AS last, stu.ssn AS ssn FROM student stu, studentEnrollment stu_enrollment WHERE stu.student_id = stu_enrollment.student_id AND stu_enrollment.year = 2018 AND stu_enrollment.quarter = 'SPRING'");
            
            %>
            <hr>
            <form action="classSchedule.jsp" method="POST">
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


































