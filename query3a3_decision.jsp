



<html>
<body>
<h2>3a ii: given X, Y, count of grades</h2>
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
            ResultSet result_4 = null;
            ResultSet result_5 = null;
            ResultSet result_6 = null;

            try {
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection("jdbc:postgresql://localhost/cse132?" +
                    "user=postgres&password=admin");
            %>

            <%
                String action = request.getParameter("course");
                if (action != null && action.equals("course")) {
                    connection.setAutoCommit(false);

                    // prepare statement
                    prepare_statement = connection.prepareStatement("select distinct cc.course_id, cc.course_number, f.fname, f.faculty_id  from classes_taken_in_the_past as ctp, course as cc, faculty_teach as ft, faculty as f where ctp.course_id = cc.course_id     and ft.faculty_id = f.faculty_id     and cc.course_id = ?     and ft.course_id = cc.course_id order by cc.course_id");

                    prepare_statement.setString(1, request.getParameter("course_id_selected"));
                    result_2 = prepare_statement.executeQuery();

                    // prepare statement
                    prepare_statement = connection.prepareStatement("with ac as (select distinct c.course_id, c.course_number, ctp.grade , count(ctp.student_id) as num from course as c, classes_taken_in_the_past as ctp where c.course_id = ?     and ctp.course_id = c.course_id     and ctp.grading_option = 'Letter Grade' group by c.course_id, c.course_number, ctp.grade )  , la as (select ac.course_id, ac.grade, ac.num from ac where substring(ac.grade from 1 for 2) = 'A' ) , lb as (select ac.course_id, ac.grade, ac.num from ac where substring(ac.grade from 1 for 2) = 'B' ) , lc as (select ac.course_id, ac.grade, ac.num from ac where substring(ac.grade from 1 for 2) = 'C' ) , ld as (select ac.course_id, ac.grade, ac.num from ac where substring(ac.grade from 1 for 2) = 'D' )   , other as (     select ac.course_id, sum(ac.num) as num from ac where substring(ac.grade from 1 for 2) != 'C' and substring(ac.grade from 1 for 2) != 'A' and substring(ac.grade from 1 for 2) != 'B' and substring(ac.grade from 1 for 2) != 'D' group by ac.course_id  )  select distinct ac.course_id, ac.course_number  , coalesce(la.num,0) as a  , coalesce(lb.num,0) as b  , coalesce(lc.num,0) as c , coalesce(ld.num,0) as d , coalesce(other.num,0) as Other from  ac   left join lc on ac.course_id = lc.course_id  left join la on ac.course_id = la.course_id   left join lb on ac.course_id = lb.course_id    left join ld on ac.course_id = ld.course_id    left join other on ac.course_id = other.course_id");

                    prepare_statement.setString(1, request.getParameter("course_id_selected"));
                    result_4 = prepare_statement.executeQuery();


                    prepare_statement = connection.prepareStatement("select distinct c.course_id, c.course_number, ft.teach_time, f.fname, ctp.grade ,ctp.student_id from course as c, faculty_teach as ft, faculty as f, classes_taken_in_the_past as ctp where c.course_id = ft.course_id     and f.faculty_id = ft.faculty_id     and c.course_id = ?     and ctp.course_id = c.course_id     and ctp.quarter = ft.teach_time     and ctp.grading_option = 'Letter Grade' order by course_id");

                    prepare_statement.setString(1, request.getParameter("course_id_selected"));
                    result_5 = prepare_statement.executeQuery();

                    prepare_statement = connection.prepareStatement("select distinct c.course_id, c.course_number, ft.teach_time, f.fname, ctp.grade , count(ctp.student_id) from course as c, faculty_teach as ft, faculty as f, classes_taken_in_the_past as ctp where c.course_id = ft.course_id     and f.faculty_id = ft.faculty_id     and c.course_id = ?     and ctp.course_id = c.course_id     and ctp.quarter = ft.teach_time     and ctp.grading_option = 'Letter Grade' group by c.course_id, c.course_number, ft.teach_time, f.fname, ctp.grade  order by course_id");

                    prepare_statement.setString(1, request.getParameter("course_id_selected"));
                    result_6 = prepare_statement.executeQuery();


                    connection.commit();
                    connection.setAutoCommit(true);


                    %>


                    <h4> Count of grades </h4>
                    <table border="1">
                    <tr>
                    <th>course number </th>
                    <th># of A </th>
                    <th># of B</th>
                    <th># of C</th>
                    <th># of D</th>
                    <th># of others</th>
                    </tr>
                    <%
                        while (result_4.next()) {
                    %>
                    <tr>
                        
                        <td>
                            <%=result_4.getString("course_number")%>
                        </td>
                        <td>
                            <%=result_4.getString("a")%>
                        </td>
                        <td>
                            <%=result_4.getString("b")%>
                      </td>
                      <td>
                            <%=result_4.getString("c")%>
                      </td>
                      <td>
                            <%=result_4.getString("d")%>
                      </td>
                      <td>
                            <%=result_4.getString("other")%>
                      </td>
                   </tr> 

                   <%   
                    }
                    %>
                    </table>



                    

                    <h4> Reference: Students' grades </h4>
                    <table border="1">
                    <tr>
                    <th>course number </th>
                    <th>teach time </th>
                    <th>faculty name </th>
                    <th>grade </th>
                    <th>student id</th>
                    </tr>
                    <%
                        while (result_5.next()) {
                    %>
                    <tr>
                        
                        <td>
                            <%=result_5.getString("course_number")%>
                        </td>
                        <td>
                            <%=result_5.getString("teach_time")%>
                        </td>
                        <td>
                            <%=result_5.getString("fname")%>
                      </td>
                      <td>
                            <%=result_5.getString("grade")%>
                      </td>
                      <td>
                            <%=result_5.getString("student_id")%>
                      </td>
                      
                   </tr> 

                   <%   
                    }
                    %>
                    </table>


                    <h4> Reference: count of students' grades </h4>
                    <table border="1">
                    <tr>
                    <th>course number </th>
                    <th>teach time </th>
                    <th>faculty name </th>
                    <th>grade </th>
                    <th>count</th>
                    </tr>
                    <%
                        while (result_6.next()) {
                    %>
                    <tr>
                        
                        <td>
                            <%=result_6.getString("course_number")%>
                        </td>
                        <td>
                            <%=result_6.getString("teach_time")%>
                        </td>
                        <td>
                            <%=result_6.getString("fname")%>
                      </td>
                      <td>
                            <%=result_6.getString("grade")%>
                      </td>
                      <td>
                            <%=result_6.getString("count")%>
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
                
                result = statement.executeQuery("select distinct cc.course_id, cc.course_number  from classes_taken_in_the_past as ctp, course as cc where ctp.course_id = cc.course_id order by cc.course_id");
            %>
            <hr>
            <form action="query3a3_decision.jsp" method="POST">
            <input type="hidden" name="course" value="course"/>

            <select name="course_id_selected">
            
            <%
                while (result.next()) {
                
                %>
                <option value='<%=result.getString("course_id")%>'>
                        <%=result.getString("course_number")%>
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
