



<html>
<body>
<h2>All the Classes and Sections Taken by Student with the specific ssn</h2>
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
            ResultSet result_2 = null;

            try {
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection("jdbc:postgresql://localhost/cse132?" +
                    "user=postgres&password=admin");
            %>

            <%
                String action = request.getParameter("action");
                if (action != null && action.equals("showAllClasses")) {
                    connection.setAutoCommit(false);

                    // prepare statement
                    prepare_statement = connection.prepareStatement("SELECT allAvailableDates::date, review_period.startTime AS selectingStartTime, review_period.endTime AS selectingEndTime FROM review_period review_period, generate_series(?::date, ?::date, '1 day'::timeInterval) allAvailableDates WHERE NOT EXISTS (SELECT * FROM studentSection student_sect_1, studentSection student_section_2, section section_2, class class_2, meeting meeting_2 WHERE student_sect_1.section_id = ? AND student_sect_1.student_id = student_section_2.student_id AND student_section_2.section_id = meeting_2.section_id AND student_section_2.section_id = section_2.section_id AND section_2.class_id = class_2.class_id AND class_2.year = 2018 AND class_2.quarter = 'SPRING' AND meeting_2.mDate = extract(dow from allAvailableDates::theTimeStamp) AND (CAST(meeting_2.startTime AS Time) < CAST(review_period.endTime AS Time) AND CAST(meeting_2.endTime AS Time) > CAST(review_period.startTime AS Time))) ORDER BY allAvailableDates::date, review_period.startTime");


                    prepare_statement.setString(1, request.getParameter("reviewStartingDate"));
                    prepare_statement.setString(2, request.getParameter("reviewEndingDate"));
                    prepare_statement.setInt(3, Integer.parseInt(request.getParameter("showAllSections")));
                    result_2 = prepare_statement.executeQuery();
                    connection.commit();
                    connection.setAutoCommit(true);


                    %>
                    <table border="1">
                    <tr>
                    <th>All The Available Dates </th>
                    <th>The Starting Time </th>
                    <th>The Ending Time </th>
                    </tr>
                    <%
                        while (result_2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=result_2.getString("allAvailableDates")%>
                        </td>
                        <td>
                            <%=result_2.getString("selectingStartTime")%>
                        </td>
                        <td>
                            <%=result_2.getString("selectingEndTime")%>
                      </td>
                   </tr>>  

                   <%   
                    }
                    %>
                    </table>
                    <%
                }
            %>

            <%
                Statement statement = connection.createStatement();
                
                result = statement.executeQuery("SELECT section.section_id, class.course_id FROM section section, class class WHERE section.class_id = class.class_id AND class.year = 2018 AND class.quarter = 'SPRING'");
            %>
            <hr>
            <form action="query2b_reviewSchedule.jsp" method="POST">
            <input type="hidden" name="action" value="showAllClasses"/>

            <select name="showAllSections">
            
            <%
                while (result.next()) {
                
                %>
                <option value='<%=result.getInt("section_id")%>'>
                        Section Id: <%=result.getInt("section_id")%>, Course Id: <%=result.getInt("course_id")%>
                </option>
                <%
                }
            %>


            </select>
            Starting Date: <input type="date" value="" name="reviewStartingDate" size="15"/>
            Ending Date: <input type="date" value="" name="reviewEndingDate" size="15"/>
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














































