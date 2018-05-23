



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

                    connection.commit();
                    connection.setAutoCommit(true);


                    %>

                    
                    <%
                }
            %>

            

            <%
                Statement statement = connection.createStatement();
                
                result = statement.executeQuery("select distinct cc.course_id, cc.course_number  from classes_taken_in_the_past as ctp, course as cc where ctp.course_id = cc.course_id order by cc.course_id");
            %>
            <hr>
            <form action="query3a_decision.jsp" method="POST">
            <input type="hidden" name="course" value="course"/>

            <select name="course_id_selected">
            
            <%
                while (result.next()) {
                
                %>
                <option value='<%=result.getString("faculty_id")%>'>
                        <%=result.getString("fname")%>, <%=result.getString("title")%>
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
