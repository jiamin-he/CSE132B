



<html>
<body>
<h2>Assist a professor X in scheduling a review session for a section Y offered in the current quarter during the time period from B to E (start date: 03/01, end date: 06/01)</h2>
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
            ResultSet result_3 = null;

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
                    prepare_statement = connection.prepareStatement(" select distinct md.dow, dc.day, me.starttime, me.endtime, me.category, me.section_id, cc.course_number, s.ssn, s.firstname, s.lastname     from course_enrollment as ce, course_enrollment as ce2, meeting as me,          meeting_dow as md, dow_conversion as dc, course as cc, student as s     where ce.section_id = ?             and ce.student_id = ce2.student_id             and ce2.section_id = me.section_id             and me.meeting_id = md.meeting_id             and cc.course_id = ce2.course_id             and md.dow = dc.id             and s.student_id = ce.student_id     order by md.dow, me.starttime, me.endtime");

                    prepare_statement.setString(1, request.getParameter("showAllsections"));

                    prepare_statement = connection.prepareStatement(" with avail as (     SELECT ava::date as cdate,      ava.time AS stime,      (ava.time + interval '1 hour') AS etime FROM      generate_series(?::timestamp, ?::timestamp, '1 hour') ava )      , covered as (     select distinct md.dow, me.starttime, me.endtime     from course_enrollment as ce, course_enrollment as ce2, meeting as me, meeting_dow as md     where ce.section_id = ?             and ce.student_id = ce2.student_id             and ce2.section_id = me.section_id             and me.meeting_id = md.meeting_id     order by md.dow, me.starttime, me.endtime )      select avail.cdate, avail.stime, avail.etime from avail  where not exists (     select *      from covered     where (covered.dow = extract(dow from avail.cdate)     and CAST(avail.stime AS Time) < CAST(covered.endTime AS Time)       AND CAST(avail.etime AS Time) > CAST(covered.startTime AS Time))     or extract(dow from avail.cdate) = 6      or extract(dow from avail.cdate) = 0     or (CAST(avail.stime AS Time) < '8:00:00')     or (CAST(avail.stime AS Time) > '19:00:00')     or (avail.cdate < '03-01-2018')     or (avail.cdate > '06-01-2018') ) order by avail.cdate, avail.stime, avail.etime");



                    prepare_statement.setString(1, request.getParameter("reviewStartingDate"));
                    prepare_statement.setString(2, request.getParameter("reviewEndingDate"));
                    prepare_statement.setString(3, request.getParameter("showAllSections"));
                    result_3 = prepare_statement.executeQuery();

                    connection.commit();
                    connection.setAutoCommit(true);


                    %>

                    <h4> Students' schedules for other sections (they are taking this section)</h4>
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
                            <%=result_2.getString("day")%>
                        </td>
                        <td>
                            <%=result_2.getString("starttime")%>
                        </td>
                        <td>
                            <%=result_2.getString("endtime")%>
                      </td>
                      <td>
                            <%=result_2.getString("category")%>
                      </td>
                      <td>
                            <%=result_2.getString("section_id")%>
                      </td>
                      <td>
                            <%=result_2.getString("course_number")%>
                      </td>
                      <td>
                            <%=result_2.getInt("ssn")%>
                      </td>
                      <td>
                            <%=result_2.getString("firstname")%>
                      </td>
                      <td>
                            <%=result_2.getString("lastname")%>
                      </td>

                   </tr>

                   <%   
                    }
                    %>
                    </table>

                    <h4> Available Dates</h4>
                    <table border="1">
                    <tr>
                    <th>All The Available Dates </th>
                    <th>The Starting Time </th>
                    <th>The Ending Time </th>
                    </tr>
                    <%
                        while (result_3.next()) {
                    %>
                    <tr>
                        <td>
                            <%=result_3.getString("cdate")%>
                        </td>
                        <td>
                            <%=result_3.getString("stime")%>
                        </td>
                        <td>
                            <%=result_3.getString("etime")%>
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
                
                result = statement.executeQuery("SELECT section.section_id, course.course_number FROM section  natural join class  natural join course order by section_id");
            %>
            <hr>
            <form action="query2b_reviewSchedule.jsp" method="POST">
            <input type="hidden" name="action" value="showAllClasses"/>

            <select name="showAllSections">
            
            <%
                while (result.next()) {
                
                %>
                <option value='<%=result.getString("section_id")%>'>
                        Section Id: <%=result.getString("section_id")%>, Course Id: <%=result.getString("course_number")%>
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
            //} catch (SQLException e) {
            //    throw new RuntimeException(e);
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














































