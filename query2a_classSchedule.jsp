

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

                    pstmt = connection.prepareStatement("SELECT distinct stu.ssn, stu.firstname, stu.lastname, class1.title AS noClassTitle,      class1.course_id AS noCourseId,      meeting_1.mDate AS noDay,      meeting_1.starttime AS noStart,      meeting_1.endTime AS noEnd,      class_2.title AS conflictingClassTitles,      class_2.course_id AS conflictingCourseId,      meeting_2.startTime AS conflictingStart,      meeting_2.endTime AS conflictingEnd,     c1.course_number as noCourse,     c2.course_number as nowCourse FROM student stu, section section1, class class1, meeting meeting_1,      section section_2, class class_2, meeting meeting_2, course_enrollment stu_sec_2, course as c1, course as c2     ,meeting_dow as md, meeting_dow as md2 WHERE stu.ssn = ? AND stu.student_id = stu_sec_2.student_id      AND stu_sec_2.section_id = section_2.section_id AND section_2.class_id = class_2.class_id      AND meeting_2.section_id = section_2.section_id AND class_2.currently_offered = 'yes'      AND section1.class_id = class1.class_id      AND meeting_1.section_id = section1.section_id AND class1.currently_offered = 'yes'     AND CAST( meeting_2.startTime AS Time) < CAST(meeting_1.endTime AS Time)      AND CAST(meeting_2.endTime AS Time) > CAST(meeting_1.startTime AS Time)     and meeting_2.meeting_id = md2.meeting_id     and meeting_1.meeting_id = md.meeting_id     and md.dow = md2.dow     AND meeting_2.section_id <> meeting_1.section_id     and class1.course_id = c1.course_id     and class_2.course_id = c2.course_id ");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    result_2 = pstmt.executeQuery();
                    connection.commit();
                    connection.setAutoCommit(true);
                    
                    %>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>last name</th>
                    <th>Should not take this class</th>
                    <th>course number</th>
                    <th>its start time </th>
                    <th>its end time </th>
                    <th>its mDate </th>
                    
                    <th>Currently taking this class </th>
                    <th>course number</th>
                    <th>Conflicting Start Time </th>
                    <th>Conflicting End Time </th>
                    </tr>
                    <%
                        while (result_2.next()) {
                    %>
                    <tr>

                        <td>
                            <%=result_2.getInt("ssn")%>
                        </td>
                        <td>
                            <%=result_2.getString("firstname")%>
                        </td>
                        <td>
                            <%=result_2.getString("lastname")%>
                        </td>
                        <td>
                            <%=result_2.getString("noClassTitle")%>
                        </td>
                        <td>
                            <%=result_2.getString("noCourse")%>
                        </td>
                        
                        <td>
                            <%=result_2.getString("noStart")%>
                        </td>
                        <td>
                            <%=result_2.getString("noEnd")%>
                        </td>
                        <td>
                            <%=result_2.getString("noDay")%>
                        </td>
                        <td>
                            <%=result_2.getString("conflictingClassTitles")%>
                        </td>
                        <td>
                            <%=result_2.getString("nowCourse")%>
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
                result = statement.executeQuery("SELECT distinct stu.firstname AS first, stu.middlename AS middle, stu.lastname AS last, stu.ssn AS ssn FROM student stu, course_enrollment se WHERE stu.student_id = se.student_id order by stu.ssn");
            
            %>
            <hr>
            <form action="query2a_classSchedule.jsp" method="POST">
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



































