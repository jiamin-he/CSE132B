



<html>
<body>
<h2>3a i: given X, Y, Z, count of grades</h2>
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
            ResultSet result_7 = null;
            ResultSet result_8 = null;

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


                    connection.commit();
                    connection.setAutoCommit(true);


                    %>

                    <%
                } 
                action = request.getParameter("prof");
                if (action != null && action.equals("prof")) {

                    connection.setAutoCommit(false);

                    // prepare statement
                    prepare_statement = connection.prepareStatement("select distinct cc.course_id, cc.course_number, f.fname, f.faculty_id, ft.teach_time from classes_taken_in_the_past as ctp, course as cc, faculty_teach as ft, faculty as f where ctp.course_id = cc.course_id     and ft.faculty_id = f.faculty_id     and cc.course_id = ?     and ft.faculty_id = ?     and ft.course_id = cc.course_id order by cc.course_id");

                    prepare_statement.setString(1, request.getParameter("course_id"));
                    prepare_statement.setString(2, request.getParameter("prof_selected"));
                    result_3 = prepare_statement.executeQuery();


                    connection.commit();
                    connection.setAutoCommit(true);


                %>
                    <form action="view3a1_decision.jsp" method="POST">
                        <input type="hidden" name="quarter" value="quarter"/>

                        <select name="quarter_selected">
                        
                        <%
                            while (result_3.next()) {
                            
                            %>
                            dasfas
                            <option value='<%=result_3.getString("teach_time")%>'>
                                    <%=result_3.getString("teach_time")%>
                            </option>
                            <%
                            }
                        %>
                        </select>

                        <input type="hidden" name="course_id" value="<%=request.getParameter("course_id")%>"/>
                        <input type="hidden" name="prof_id" value="<%=request.getParameter("prof_selected")%>"/>
                        
                        <input type="submit" value="Submit"/>
                        </form>
                <%
                }
                action = request.getParameter("quarter");
                if (action != null && action.equals("quarter")) {

                    connection.setAutoCommit(false);

                    // prepare statement
                    prepare_statement = connection.prepareStatement("with ac as (select distinct c.course_id, c.course_number, ft.teach_time, f.fname, ctp.grade , count(ctp.student_id) as num from course as c, faculty_teach as ft, faculty as f, classes_taken_in_the_past as ctp where c.course_id = ft.course_id     and f.faculty_id = ft.faculty_id     and c.course_id = ?     and f.faculty_id = ?     and ft.teach_time = ?     and ctp.course_id = c.course_id     and ctp.quarter = ft.teach_time     and ctp.grading_option = 'Letter Grade' group by c.course_id, c.course_number, ft.teach_time, f.fname, ctp.grade )  , la as (select ac.course_id, ac.grade, ac.num from ac where substring(ac.grade from 1 for 2) = 'A' ) , lb as (select ac.course_id, ac.grade, ac.num from ac where substring(ac.grade from 1 for 2) = 'B' ) , lc as (select ac.course_id, ac.grade, ac.num from ac where substring(ac.grade from 1 for 2) = 'C' ) , ld as (select ac.course_id, ac.grade, ac.num from ac where substring(ac.grade from 1 for 2) = 'D' )   , other as (     select ac.course_id, sum(ac.num) as num from ac where substring(ac.grade from 1 for 2) != 'C' and substring(ac.grade from 1 for 2) != 'A' and substring(ac.grade from 1 for 2) != 'B' and substring(ac.grade from 1 for 2) != 'D' group by ac.course_id  )  select distinct ac.course_id, ac.course_number  , coalesce(la.num,0) as a  , coalesce(lb.num,0) as b  , coalesce(lc.num,0) as c , coalesce(ld.num,0) as d , coalesce(other.num,0) as Other from  ac   left join lc on ac.course_id = lc.course_id  left join la on ac.course_id = la.course_id   left join lb on ac.course_id = lb.course_id    left join ld on ac.course_id = ld.course_id    left join other on ac.course_id = other.course_id ");

                    prepare_statement.setString(1, request.getParameter("course_id"));
                    prepare_statement.setString(2, request.getParameter("prof_id"));
                    prepare_statement.setString(3, request.getParameter("quarter_selected"));
                    result_4 = prepare_statement.executeQuery();

                    prepare_statement = connection.prepareStatement("select distinct c.course_id, c.course_number, ft.teach_time, f.fname, ctp.grade ,ctp.student_id from course as c, faculty_teach as ft, faculty as f, classes_taken_in_the_past as ctp where c.course_id = ft.course_id     and f.faculty_id = ft.faculty_id     and c.course_id = ?     and f.faculty_id = ?     and ft.teach_time = ?     and ctp.course_id = c.course_id     and ctp.quarter = ft.teach_time     and ctp.grading_option = 'Letter Grade' order by course_id");

                    prepare_statement.setString(1, request.getParameter("course_id"));
                    prepare_statement.setString(2, request.getParameter("prof_id"));
                    prepare_statement.setString(3, request.getParameter("quarter_selected"));
                    result_5 = prepare_statement.executeQuery();

                    prepare_statement = connection.prepareStatement("select distinct c.course_id, c.course_number, ft.teach_time, f.fname, ctp.grade , count(ctp.student_id) from course as c, faculty_teach as ft, faculty as f, classes_taken_in_the_past as ctp where c.course_id = ft.course_id     and f.faculty_id = ft.faculty_id     and c.course_id = ?     and f.faculty_id = ?     and ft.teach_time = ?     and ctp.course_id = c.course_id     and ctp.quarter = ft.teach_time     and ctp.grading_option = 'Letter Grade' group by c.course_id, c.course_number, ft.teach_time, f.fname, ctp.grade  order by course_id");

                    prepare_statement.setString(1, request.getParameter("course_id"));
                    prepare_statement.setString(2, request.getParameter("prof_id"));
                    prepare_statement.setString(3, request.getParameter("quarter_selected"));
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
                Statement statement1 = connection.createStatement();
                
                result_7 = statement1.executeQuery("select * from view_cpqg order by course_id");
            %>

                <h4> CPGR </h4>
                <table border="1">
                <tr>
                <th>course number </th>
                <th>professor </th>
                <th>quarter</th>
                <th># of A </th>
                <th># of B</th>
                <th># of C</th>
                <th># of D</th>
                <th># of others</th>
                </tr>
                <%
                while (result_7.next()) {
                %>
                <tr>

                <td>
                    <%=result_7.getString("course_number")%>
                </td>
                <td>
                    <%=result_7.getString("fname")%>
                </td>
                <td>
                    <%=result_7.getString("teach_time")%>
                </td>
                <td>
                    <%=result_7.getString("a")%>
                </td>
                <td>
                    <%=result_7.getString("b")%>
                </td>
                <td>
                    <%=result_7.getString("c")%>
                </td>
                <td>
                    <%=result_7.getString("d")%>
                </td>
                <td>
                    <%=result_7.getString("other")%>
                </td>

                </tr> 

                <%   
                }
                %>
                </table>


            <%
                Statement statement = connection.createStatement();
                
                result = statement.executeQuery("select distinct cc.course_id, cc.course_number  from classes_taken_in_the_past as ctp, course as cc where ctp.course_id = cc.course_id order by cc.course_id");
                // result_8 = statement.executeQuery("select * from student order by ssn");
            %>
            <hr>
            <h4> Insert </h4>
            <table border="1">
                <tr>
                    <th>course number </th>
                    <th>professor </th>
                    <th>quarter</th>
                    <th>Grade</th>
                </tr>

                <tr>
                   
                    <th>
                        <form action="view3a1_decision.jsp" method="POST">
                            <input type="hidden" name="course" value="course"/>

                            <select name="course_id_selected">
                            
                            <%
                                while (result.next()) {
                                if(request.getParameter("course_id_selected") != null && request.getParameter("course_id_selected").equals(result.getString("course_id"))) {

                                %>
                                <option value='<%=result.getString("course_id")%>' selected>
                                        <%=result.getString("course_number") %>
                                </option>
                                <%
                               } else {

                                %>
                                <option value='<%=result.getString("course_id")%>'>
                                        <%=result.getString("course_number") %>
                                </option>
                                
                                    <%
                                    }
                                }
                            %>
                            </select>
                            
                            <input type="submit" value="Submit"/>
                            </form>
                    </th>
                    <th>

                        <%
                            String cid = request.getParameter("course_id_selected");
                            if(cid != null ){
                        %>
                            <form action="query3a1_decision.jsp" method="POST">
                                <input type="hidden" name="prof" value="prof"/>

                                <select name="prof_selected">
                                
                                <%
                                    while (result_2.next()) {
                                    
                                    %>
                                    <option value='<%=result_2.getString("faculty_id")%>'>
                                            <%=result_2.getString("fname")%>
                                    </option>
                                    <%
                                    }
                                %>
                                </select>

                                <input type="hidden" name="course_id" value="<%=request.getParameter("course_id_selected")%>"/>
                                
                                <input type="submit" value="Submit"/>
                                </form>
                        <%
                        }
                        %>
                        
                    </th>
                    <th>
                        
                    </th>
                </tr>
            </table>

            

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
