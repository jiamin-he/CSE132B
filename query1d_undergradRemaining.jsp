

<html>
<body>
<h2>1d: assist an undergraduate student X in figuring out remaining degree requirements for a bachelors in Y </h2>
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

                    pstmt = connection.prepareStatement("with tmp as (select *  from (select s.ssn, s.firstname, s.middlename, s.lastname , ccc.name, sum(ce.units) as sum_major_category_units from student as s ,undergraduate as u ,classes_taken_in_the_past as ce ,course as co ,degree_requirements as d ,department as dp ,course_category_conversion as ccc  where s.student_id = u.student_id     and s.ssn  = ?     and s.student_id = ce.student_id     and dp.department_name = ?     and  (d.cur_degree = 'B.S.' or d.cur_degree = 'B.A.')     and d.department_id = dp.department_id     and ce.course_id = ccc.course_id     and co.department_id = d.department_id     and co.course_id = ce.course_id group by s.ssn, s.firstname, s.middlename, s.lastname , ccc.name  ) as sub right outer join (select * from course_categories as cc  ,department as dpp ,degree_requirements as dd  where dpp.department_name = ? and (dd.cur_degree = 'B.S.' or dd.cur_degree = 'B.A.') and dpp.department_id = dd.department_id and cc.degree_id = dd.degree_id) as cc1 on sub.name = cc1.course_category) select ssn,firstname,middlename,lastname,course_category, min_units,coalesce(sum_major_category_units,0) as sum_major_category_units, units_required from (select distinct(ssn), firstname, middlename, lastname from tmp where ssn is not null) as t1, ((select course_category, min_units, sum_major_category_units, (min_units-sum_major_category_units) as units_required  from tmp  where name = course_category) union (select course_category, min_units, sum_major_category_units, min_units as units_required from tmp  where name is null)) as t2 ");

                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    pstmt.setString(2, request.getParameter("showTheDept"));
                    pstmt.setString(3, request.getParameter("showTheDept"));

                    result_2 = pstmt.executeQuery();

                    pstmt = connection.prepareStatement(" select sub.ssn, sub.firstname, sub.middlename, sub.lastname, dd.unit as total_credits, sub.sum_total_units as already_taken, dd.unit-sub.sum_total_units as credits_needed  from degree_requirements as dd,  (     select  s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree, sum(ce.units) as sum_total_units from student as s , undergraduate as u , classes_taken_in_the_past as ce  , course as co  , degree_requirements as d , department as dp  where      s.student_id = u.student_id     and s.ssn  = ?     and d.department_id = dp.department_id     and dp.department_name = ?     and (d.cur_degree = 'B.S.' or d.cur_degree = 'B.A.' )     and s.student_id = ce.student_id     and co.course_id = ce.course_id group by s.ssn, s.firstname, s.middlename, s.lastname, dp.department_id, d.cur_degree ) as sub  where dd.department_id = sub.department_id and dd.cur_degree = sub.cur_degree ");

                    pstmt.setInt( 1, Integer.parseInt(request.getParameter("showTheSSN")));
                    pstmt.setString(2, request.getParameter("showTheDept"));
                    result_3 = pstmt.executeQuery();

                    
                    connection.commit();
                    connection.setAutoCommit(true);
                    
                    %>

                    <h4>the minimum number of units the student has to take from each category</h4>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    <th>course category</th>
                    
                    <th>min units</th>
                    <th>taken units</th>
                    <th>required units</th>
                    
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
                            <%=result_2.getString("course_category")%>
                        </td>
                        <td>
                            <%=result_2.getString("min_units")%>
                        </td>
                        <td>
                            <%=result_2.getString("sum_major_category_units")%>
                        </td>
                        <td>
                            <%=result_2.getInt("units_required")%>
                        </td>
                        
                        
                    </tr>
                    <%
                        }
                    %>
                    </table>

                    <h4>how many units the student has to take in order to graduate with degree Y</h4>
                    <table border="1">
                    <tr>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>middle name </th>
                    <th>last name </th>
                    <th>total credits</th>
                    <th>already taken</th>
                    <th>credits needed</th>
                    
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
                            <%=result_3.getString("total_credits")%>
                        </td>
                        <td>
                            <%=result_3.getInt("already_taken")%>
                        </td>
                        <td>
                            <%=result_3.getString("credits_needed")%>
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
                result = statement.executeQuery("select s.ssn, s.firstname, s.middlename, s.lastname from student as s, undergraduate as u where s.student_id = u.student_id");
                
                Statement statement2 = connection.createStatement();
                result_2 = statement2.executeQuery(" select d.cur_degree, dp.department_name from degree_requirements as d, department as dp where d.department_id = dp.department_id and (d.cur_degree = 'B.S.' or d.cur_degree = 'B.A.') ");
            
            %>
            <hr>

            <form action="query1d_undergradRemaining.jsp" method="POST">
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
            // catch (SQLException e) {
            //     throw new RuntimeException(e);
            // }
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
