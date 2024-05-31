<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal, java.util.ArrayList, java.util.HashSet, java.util.Set" %>
<!DOCTYPE html>
<html>
<head>
    <title>Process SSN input</title>
</head>
<body>
<%!
    public boolean compareDays(String days1, String days2){
        for (int i = 0; i < days1.length(); i++){
            if (days2.contains(String.valueOf(days1.charAt(i)))){
                return true;
            }
        }
        return false;
    }

    public boolean compareTimes(String timeStart1, String timeEnd1, String timeStart2, String timeEnd2){
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss");
        java.time.LocalTime start1 = java.time.LocalTime.parse(timeStart1, formatter);
        java.time.LocalTime end1 = java.time.LocalTime.parse(timeEnd1, formatter);
        java.time.LocalTime start2 = java.time.LocalTime.parse(timeStart2, formatter);
        java.time.LocalTime end2 = java.time.LocalTime.parse(timeEnd2, formatter);

        // Check if the time periods overlap
        if ((start1.isBefore(end2) && end1.isAfter(start2)) || (start2.isBefore(end1) && end2.isAfter(start1))) {
            return true;
        }
        return false;
    }

    public ArrayList<ArrayList<String>> clearResult(ArrayList<ArrayList<String>> classesCannotTake, ArrayList<ArrayList<String>> classesCanTake){
        ArrayList<ArrayList<String>> classesCannotTakeFinal = new ArrayList<ArrayList<String>>();
        Set set = new HashSet();
        for (ArrayList<String> classCannotTake : classesCannotTake){
            boolean canTake = false;
            for (ArrayList<String> classCanTake : classesCanTake){
                if (classCannotTake.get(0).equals(classCanTake.get(0)) && classCannotTake.get(1).equals(classCanTake.get(1))){
                    canTake = true;
                    break;
                }
            }
            if (!canTake && !set.contains(classCannotTake.get(0)+classCannotTake.get(1))){
                classesCannotTakeFinal.add(classCannotTake);
                set.add(classCannotTake.get(0)+classCannotTake.get(1));
            }
        }
        return classesCannotTakeFinal;
    }
%>
<%

    String ssn = request.getParameter("ssn");

    // Optional: Connect to your database and insert the data
    String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
    String user = "postgres";
    String password = "James2085";

    try {
        // Load the database driver
        Class.forName("org.postgresql.Driver");

        // Establish connection
        Connection conn = DriverManager.getConnection(url, user, password);

        String sql = "SELECT * FROM Student WHERE ssn = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, ssn);
        ResultSet rs = pstmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>SSN</th><th>First Name</th><th>Middle Name</th><th>Last Name</th></tr>");
        String student_id = "";
        while (rs.next()) {
            student_id = rs.getString("student_id");
            out.println("<tr>");
            out.println("<td>" + rs.getString("ssn") + "</td>"); 
            out.println("<td>" + rs.getString("first_name") + "</td>");
            out.println("<td>" + rs.getString("middle_name") + "</td>");
            out.println("<td>" + rs.getString("last_name") + "</td>");
            out.println("</tr>");
        }
        sql =  "SELECT m.*, stc.*, c.* " +
                "FROM student_take_class stc " +
                "JOIN meeting m ON stc.class_id = m.class_id AND stc.section_id = m.section_id " +
                "JOIN class c ON stc.class_id = c.class_id " +
                "WHERE stc.student_id = ? AND c.quarter = 'Spring' AND c.year = 2018";
        // First find all the meetings of the classes the student is taking
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, student_id);
        rs = pstmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>class_id</th><th>course_id</th><th>year</th><th>quarter</th><th>title</th><th>section</th><th>units</th><th>meeting type</th><th>days_of_week</th><th>start time</th><th>end time</th></tr>");
        ArrayList<ArrayList<String>> classesTaking = new ArrayList<ArrayList<String>>();
        while (rs.next()) {
            ArrayList<String> classInfo = new ArrayList<String>();
            classInfo.add(rs.getString("class_id"));
            classInfo.add(rs.getString("title"));
            classInfo.add(rs.getString("section_id"));
            classInfo.add(rs.getString("days_of_week"));
            classInfo.add(rs.getString("time_start"));
            classInfo.add(rs.getString("time_end"));
            out.println("<tr>");
            out.println("<td>" + rs.getString("class_id") + "</td>"); 
            out.println("<td>" + rs.getString("course_id") + "</td>");
            out.println("<td>" + rs.getString("year") + "</td>");
            out.println("<td>" + rs.getString("quarter") + "</td>");
            out.println("<td>" + rs.getString("title") + "</td>");
            out.println("<td>" + rs.getString("section_id") + "</td>");
            out.println("<td>" + rs.getString("units") + "</td>");
            out.println("<td>" + rs.getString("type") + "</td>");
            out.println("<td>" + rs.getString("days_of_week") + "</td>");
            out.println("<td>" + rs.getString("time_start") + "</td>");
            out.println("<td>" + rs.getString("time_end") + "</td>");
            out.println("</tr>");
            classesTaking.add(classInfo);
        }

        // Then find all the classes currently offered in the Spring 2018 quarter
        sql =  "SELECT c.*, m.* " +
                "FROM class c " +
                "JOIN meeting m ON c.class_id = m.class_id " +
                "WHERE c.quarter = 'Spring' AND c.year = 2018";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>class_id</th><th>course_id</th><th>year</th><th>quarter</th><th>title</th><th>section</th><th>meeting type</th><th>days_of_week</th><th>start time</th><th>end time</th></tr>");
        ArrayList<ArrayList<String>> classesOffered = new ArrayList<ArrayList<String>>();
        while (rs.next()) {
            ArrayList<String> classInfo = new ArrayList<String>();
            classInfo.add(rs.getString("class_id"));
            classInfo.add(rs.getString("title"));
            classInfo.add(rs.getString("section_id"));
            classInfo.add(rs.getString("days_of_week"));
            classInfo.add(rs.getString("time_start"));
            classInfo.add(rs.getString("time_end"));
            out.println("<tr>");
            out.println("<td>" + rs.getString("class_id") + "</td>"); 
            out.println("<td>" + rs.getString("course_id") + "</td>");
            out.println("<td>" + rs.getString("year") + "</td>");
            out.println("<td>" + rs.getString("quarter") + "</td>");
            out.println("<td>" + rs.getString("title") + "</td>");
            out.println("<td>" + rs.getString("section_id") + "</td>");
            //out.println("<td>" + rs.getString("units") + "</td>");
            out.println("<td>" + rs.getString("type") + "</td>");
            out.println("<td>" + rs.getString("days_of_week") + "</td>");
            out.println("<td>" + rs.getString("time_start") + "</td>");
            out.println("<td>" + rs.getString("time_end") + "</td>");
            out.println("</tr>");
            classesOffered.add(classInfo);
        }
        out.println(classesOffered.size() + " classes are offered in Spring 2018.");
        out.println(classesTaking.size() + " classes are taken by the student in Spring 2018.");

        // Find the classes that the student can take
        // 0 = class_id, 1 = title, 2 = section_id, 3 = days_of_week, 4 = time_start, 5 = time_end

        // 0 = classOffered id, 1 = classOffered title, 2 = classOffered section_id, 3 = classTaking id, 4 = classTaking title, 5 = classTaking section_id
        ArrayList<ArrayList<String>> classesCannotTake = new ArrayList<ArrayList<String>>();

        ArrayList<ArrayList<String>> classesCanTake = new ArrayList<ArrayList<String>>();
        for (ArrayList<String> classOffered : classesOffered){
            boolean canTake = true;
            for (ArrayList<String> classTaking : classesTaking){
                if (classOffered.get(0).equals(classTaking.get(0)) && classOffered.get(1).equals(classTaking.get(1))){
                    continue;
                }
                //out.print(classOffered.get(0) + " " + classOffered.get(1) + " " + classOffered.get(2) + " " + classTaking.get(0) + " " + classTaking.get(1) + " " + classTaking.get(2) + "<br>");
                if (compareDays(classOffered.get(3), classTaking.get(3)) && compareTimes(classOffered.get(4), classOffered.get(5), classTaking.get(4), classTaking.get(5))){
                    ArrayList<String> classCannotTake = new ArrayList<String>();
                    classCannotTake.add(classOffered.get(0));
                    classCannotTake.add(classOffered.get(1));
                    classCannotTake.add(classOffered.get(2));
                    classCannotTake.add(classTaking.get(0));
                    classCannotTake.add(classTaking.get(1));
                    classCannotTake.add(classTaking.get(2));
                    classesCannotTake.add(classCannotTake);
                    canTake = false;
                    break;
                }
            }
            out.println(canTake);
            if (canTake){
                ArrayList<String> classCanTake = new ArrayList<String>();
                classCanTake.add(classOffered.get(0));
                classCanTake.add(classOffered.get(1));
                classCanTake.add(classOffered.get(2));
                classesCanTake.add(classCanTake);
            }
        }
        ArrayList<ArrayList<String>> classesCannotTakeFinal = clearResult(classesCannotTake, classesCanTake);
        out.println("<table border='1'>");
        out.println("<tr><th>ClassCannotTake: class_id</th><th>ClassCannotTake: title</th><th>ClassOverlapped: class_id</th><th>ClassOverlapped: title</th></tr>");
        out.println(classesCannotTakeFinal.size() + " classes cannot be taken due to time conflict.");
        for (ArrayList<String> classCannotTake : classesCannotTakeFinal){
            out.println("<tr>");
            out.println("<td>" + classCannotTake.get(0) + "</td>"); 
            out.println("<td>" + classCannotTake.get(1) + "</td>");
            out.println("<td>" + classCannotTake.get(3) + "</td>");
            out.println("<td>" + classCannotTake.get(4) + "</td>");
            out.println("</tr>");
        }
        
        



    } catch (ClassNotFoundException e) {
        out.println("<p>Error loading driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p>Error in SQL: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>
