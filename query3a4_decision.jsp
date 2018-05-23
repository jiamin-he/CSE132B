



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


                    connection.commit();
                    connection.setAutoCommit(true);


                    %>

                    <form action="query3a4_decision.jsp" method="POST">
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
                action = request.getParameter("prof");
                if (action != null && action.equals("prof")) {

                    connection.setAutoCommit(false);

                    prepare_statement = connection.prepareStatement("with rep as (         select c.course_id, c.course_number,f.fname, ctp.grade  from course as c, faculty_teach as ft, faculty as f, classes_taken_in_the_past as ctp where c.course_id = ft.course_id     and f.faculty_id = ft.faculty_id     and c.course_id = ?    and f.faculty_id = ?     and ctp.course_id = c.course_id     and ctp.quarter = ft.teach_time     and ctp.grading_option = 'Letter Grade' )    ,        sub as (       select *, gc.number_grade as gradePoint   from rep, grade_conversion as gc   where rep.grade = gc.letter_grade          )              select sub.course_number, sub.fname, (ROUND(AVG(sub.gradepoint)::numeric,3) ) as avgPoint    from sub    group by sub.course_number,sub.fname");

                    prepare_statement.setString(1, request.getParameter("course_id"));
                    prepare_statement.setString(2, request.getParameter("prof_selected"));
                    result_4 = prepare_statement.executeQuery();

                    prepare_statement = connection.prepareStatement("with rep as (         select c.course_id, c.course_number,f.fname, s.ssn, s.firstname, ctp.grade  from course as c, faculty_teach as ft, faculty as f, classes_taken_in_the_past as ctp, student as s where c.course_id = ft.course_id     and f.faculty_id = ft.faculty_id     and c.course_id = ?     and f.faculty_id = ?     and ctp.course_id = c.course_id     and ctp.quarter = ft.teach_time     and s.student_id = ctp.student_id     and ctp.grading_option = 'Letter Grade' )        select *, gc.number_grade as gradePoint   from rep, grade_conversion as gc   where rep.grade = gc.letter_grade  ");

                    prepare_statement.setString(1, request.getParameter("course_id"));
                    prepare_statement.setString(2, request.getParameter("prof_selected"));
                    result_5 = prepare_statement.executeQuery();


                    connection.commit();
                    connection.setAutoCommit(true);


                %>
                

                    <h4> Count of grades </h4>
                    <table border="1">
                    <tr>
                    <th>course number </th>
                    <th>faculty </th>
                    <th>avg grade point</th>
                    
                    </tr>
                    <%
                        while (result_4.next()) {
                    %>
                    <tr>
                        
                        <td>
                            <%=result_4.getString("course_number")%>
                        </td>
                        <td>
                            <%=result_4.getString("fname")%>
                        </td>
                        <td>
                            <%=result_4.getString("avgpoint")%>
                      </td>
                      
                   </tr> 

                   <%   
                    }
                    %>
                    </table>

                    <h4> Count of grades </h4>
                    <table border="1">
                    <tr>
                    <th>course number </th>
                    <th>faculty </th>
                    <th>ssn</th>
                    <th>first name</th>
                    <th>grade </th>
                    <th>number grade</th>

                    
                    </tr>
                    <%
                        while (result_5.next()) {
                    %>
                    <tr>
                        
                        <td>
                            <%=result_5.getString("course_number")%>
                        </td>
                        <td>
                            <%=result_5.getString("fname")%>
                        </td>
                        <td>
                            <%=result_5.getString("ssn")%>
                      </td>
                      <td>
                            <%=result_5.getString("firstname")%>
                      </td>
                      <td>
                            <%=result_5.getString("grade")%>
                      </td>
                      <td>
                            <%=result_5.getString("number_grade")%>
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
            <form action="query3a4_decision.jsp" method="POST">
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
            //} catch (SQLException e) {
              //  throw new RuntimeException(e);
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
