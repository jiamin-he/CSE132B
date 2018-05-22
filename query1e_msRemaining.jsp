

<html>
<body>
<h2>1e: Assist a MS student in figuring out remaining degree requirements for a MS in Y </h2>
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
            ResultSet result_5 = null;
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

                    pstmt = connection.prepareStatement("select sub.ssn, sub.firstname, sub.middlename, sub.lastname, sub.cur_degree, sub.concentration, sub.sum_concentration_units as already_taken, sub.gpa_concentration as already_gpa, con.min_units as needed_units, con.min_gpa as needed_gpa from (select sub1.ssn, sub1.firstname, sub1.middlename, sub1.lastname, sub1.cur_degree, sub1.concentration, sub1.sum_concentration_units, sub2.gpa_concentration from (select s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree, c.concentration, sum(ce.units) as sum_concentration_units from student as s natural join graduate as g natural join classes_taken_in_the_past as ce  natural join degree_requirements as d natural join department as dp  natural join concentration as c natural join ms_concentrate as mc where s.ssn  = ? and dp.department_name = ? and d.cur_degree = 'M.S.' and mc.course_id = ce.course_id and mc.concentration_id = c.concentrate_id group by s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree, c.concentration ) as sub1  join ( select s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree, c.concentration , ROUND(AVG(gc.number_grade)::numeric,2) as gpa_concentration from student as s, grade_conversion as gc natural join graduate as g  natural join classes_taken_in_the_past as ce natural join degree_requirements as d natural join department as dp  natural join concentration as c natural join ms_concentrate as mc where  s.student_id = g.student_id and s.ssn  = ?  and dp.department_name = ? and d.cur_degree = 'M.S.'  and mc.course_id = ce.course_id and mc.concentration_id = c.concentrate_id and gc.letter_grade = ce.grade and ce.grading_option = 'Letter Grade' group by s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree, c.concentration ) as sub2 on sub1.ssn = sub2.ssn) as sub , concentration as con where sub.concentration = con.concentration and sub.sum_concentration_units >= cast(con.min_units as integer) and sub.gpa_concentration >= cast(con.min_gpa as float)");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    pstmt.setString( 2, request.getParameter("showTheDept"));
                    pstmt.setInt( 3, Integer.parseInt(request.getParameter("showTheSSN")));
                    pstmt.setString( 4, request.getParameter("showTheDept"));


                    result_2 = pstmt.executeQuery();

                    pstmt = connection.prepareStatement("select s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree, c.concentration, c.min_units, sum(ce.units) as sum_concentration_units from student as s natural join graduate as g natural join classes_taken_in_the_past as ce natural join degree_requirements as d natural join department as dp  natural join concentration as c natural join ms_concentrate as mc where      s.ssn  = ?    and dp.department_name = ?     and d.cur_degree = 'M.S.'      and mc.course_id = ce.course_id     and mc.concentration_id = c.concentrate_id group by s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree, c.concentration, c.min_units ");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    pstmt.setString( 2, request.getParameter("showTheDept"));

                    result_3 = pstmt.executeQuery();

                    pstmt = connection.prepareStatement("select s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree, c.concentration ,c.min_gpa, ROUND(AVG(gc.number_grade)::numeric,2) as gpa_concentration from student as s, grade_conversion as gc natural join graduate as g  natural join classes_taken_in_the_past as ce natural join degree_requirements as d natural join department as dp  natural join concentration as c natural join ms_concentrate as mc where      s.student_id = g.student_id     and s.ssn  = ?      and dp.department_name = ?     and d.cur_degree = 'M.S.'      and mc.course_id = ce.course_id     and mc.concentration_id = c.concentrate_id     and gc.letter_grade = ce.grade     and ce.grading_option = 'Letter Grade'  group by s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree, c.concentration, c.min_gpa");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    pstmt.setString( 2, request.getParameter("showTheDept"));
                    result_4 = pstmt.executeQuery();

                    pstmt = connection.prepareStatement("select  s.ssn, s.firstname, s.middlename, s.lastname, c.concentration, cc.course_number, ccc.next_offered from student as s natural join graduate as g  natural join department as dp, concentration as c,  ms_concentrate as mc,course as cc, class as ccc where      s.ssn  = ?     and dp.department_name = ?     and mc.course_id not in (         select ce.course_id          from classes_taken_in_the_past as ce         where ce.student_id = s.student_id     )     and mc.concentration_id = c.concentrate_id     and cc.course_id = mc.course_id     and cc.course_id = ccc.course_id");
                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    pstmt.setString( 2, request.getParameter("showTheDept"));
                    result_5 = pstmt.executeQuery();

                    connection.commit();
                    connection.setAutoCommit(true);
                    
                    %>


                    <h4>current units on concentration</h4>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    <th>current degree</th>
                    <th>concentration</th>
                    <th>current units on concentration</th>
                    <th>required units on concentration</th>
                    
                    
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
                            <%=result_3.getString("cur_degree")%>
                        </td>
                        <td>
                            <%=result_3.getString("concentration")%>
                        </td>
                        <td>
                            <%=result_3.getString("sum_concentration_units")%>
                        </td>
                         <td>
                            <%=result_3.getString("min_units")%>
                        </td>
                        
                        
                    </tr>
                    <%
                        }
                    %>
                    </table>

                    <h4>current gpa on concentration</h4>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    <th>current degree</th>
                    <th>concentration</th>
                    <th>current gpa on concentration</th>
                    <th>required gpa on concentration</th>
                    
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
                            <%=result_4.getString("cur_degree")%>
                        </td>
                        <td>
                            <%=result_4.getString("concentration")%>
                        </td>
                        <td>
                            <%=result_4.getString("gpa_concentration")%>
                        </td>
                        <td>
                            <%=result_4.getString("min_gpa")%>
                        </td>
                        
                    </tr>
                    <%
                        }
                    %>
                    </table>

                    <h4>already completed concentrations</h4>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    <th>current degree</th>
                    
                    <th>concentration</th>
                    <th>student's credits</th>
                    <th>student's current gpa</th>
                    <th>required units</th>
                    <th>required gpa</th>
                    
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
                            <%=result_2.getString("cur_degree")%>
                        </td>
                        <td>
                            <%=result_2.getString("concentration")%>
                        </td>
                        <td>
                            <%=result_2.getString("already_taken")%>
                        </td>
                        <td>
                            <%=result_2.getString("already_gpa")%>
                        </td>
                        <td>
                            <%=result_2.getString("needed_units")%>
                        </td>
                        <td>
                            <%=result_2.getString("needed_gpa")%>
                        </td>
                        
                    </tr>
                    <%
                        }
                    %>
                    </table>

                    <h4>the set of courses that the student has not yet taken from every concentration</h4>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    
                    <th>concentration</th>
                    <th>course number </th>
                    <th>next offered</th>
                    
                    </tr>
                    <%
                        while (result_5.next()) {
                    %>
                    <tr>
                        <td>
                            <%=result_5.getString("ssn")%>
                        </td>
                        <td>
                            <%=result_5.getString("firstname")

                            %>
                        </td>
                        <td>
                            <%=result_5.getString("middlename")%>
                        </td>
                        <td>
                            <%=result_5.getString("lastname")%>
                        </td>
                        
                        <td>
                            <%=result_5.getString("concentration")%>
                        </td>
                        <td>
                            <%=result_5.getString("course_number")%>
                        </td>
                        <td>
                            <%=result_5.getString("next_offered")%>
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
                result = statement.executeQuery("select s.ssn, s.firstname, s.middlename, s.lastname from student as s, graduate as g where s.student_id = g.student_id");

                Statement statement2 = connection.createStatement();
                result_2 = statement2.executeQuery("select d.cur_degree, dp.department_name from degree_requirements as d, department as dp where d.department_id = dp.department_id and d.cur_degree = 'M.S.'  ");
            
            %>
            <hr>

            <form action="query1e_msRemaining.jsp" method="POST">
            <input type="hidden" name="action" value="showAllClasses"/>
                <select name="showTheSSN">
                <%
                    while (result.next()) {
                    %>
                    <option value='<%=result.getInt("ssn")%>'>
                            <%=result.getInt("ssn")%>, <%=result.getString("lastname")%>, <%=result.getString("middlename")%>, <%=result.getString("firstname")%>
                    </option>
                    <%
                    }
                %>
                </select>

                <select name="showTheDept">
                <%
                    while (result_2.next()) {
                    %>
                    <option value='<%=result_2.getString("department_name")%>'>
                            <%=result_2.getString("department_name")%>, <%=result_2.getString("cur_degree")%>
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
