<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.*, java.sql.*, java.math.BigDecimal, java.util.*, java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Process SID input</title>
</head>
<body>
<%!
    public static ArrayList<String> convertDaysOfWeek(String daysOfWeek) {
        Map<Character, String> dayMap = new HashMap<>();
        dayMap.put('1', "MONDAY");
        dayMap.put('2', "TUESDAY");
        dayMap.put('3', "WEDNESDAY");
        dayMap.put('4', "THURSDAY");
        dayMap.put('5', "FRIDAY");
        dayMap.put('6', "SATURDAY");
        dayMap.put('7', "SUNDAY");

        ArrayList<String> days = new ArrayList<>();
        for (char c : daysOfWeek.toCharArray()) {
            String day = dayMap.get(c);
            if (day != null) {
                days.add(day);
            }
        }
        return days;
    }
    public Set<ZonedDateTime> updateFreeHours(Set<ZonedDateTime> hours, ArrayList<String> studentClass) {
        // Parse the date and time from the studentClass
        String dateStart = studentClass.get(0);
        String dateEnd = studentClass.get(1);
        String timeStart = studentClass.get(2);
        String timeEnd = studentClass.get(3);
        String daysOfWeek = studentClass.get(4);
        ZonedDateTime startDateTime = ZonedDateTime.parse(dateStart + "T" + timeStart + "-07:00[America/Los_Angeles]");
        ZonedDateTime endDateTime = ZonedDateTime.parse(dateEnd + "T" + timeEnd + "-07:00[America/Los_Angeles]");
        ArrayList<String> days = convertDaysOfWeek(daysOfWeek);
        Set<ZonedDateTime> updatedFreeHours = hours;
        for (ZonedDateTime dt = startDateTime; !dt.isAfter(endDateTime); dt = dt.plusDays(1)) {
            if (!days.contains(dt.getDayOfWeek().toString())) {
                continue; // Skip days that are not in the class schedule
            }
            int startHour = Integer.parseInt(timeStart.split(":")[0]);
            int endHour = Integer.parseInt(timeEnd.split(":")[0]);
            for (int i = startHour; i < endHour; i++) {
                ZonedDateTime classHour = dt.withHour(i);
                updatedFreeHours.remove(classHour);
            }
            if (!timeEnd.split(":")[1].equals("00")) {
                ZonedDateTime classHour = dt.withHour(Integer.parseInt(timeEnd.split(":")[0]));
                updatedFreeHours.remove(classHour);
            }
        }

        return updatedFreeHours;
    }
    public Set<ZonedDateTime> updateReviewSessions(Set<ZonedDateTime> hours, ArrayList<String> reviewSession){
        // Parse the date and time from the reviewSession
        String date = reviewSession.get(0);
        String timeStart = reviewSession.get(1);
        String timeEnd = reviewSession.get(2);
        ZonedDateTime reviewStart = ZonedDateTime.parse(date + "T" + timeStart + "-07:00[America/Los_Angeles]");
        ZonedDateTime reviewEnd = ZonedDateTime.parse(date + "T" + timeEnd + "-07:00[America/Los_Angeles]");
        Set<ZonedDateTime> updatedFreeHours = hours;
        for (ZonedDateTime dt = reviewStart; !dt.isAfter(reviewEnd); dt = dt.plusHours(1)) {
            updatedFreeHours.remove(dt);
        }
        return updatedFreeHours;
    }
 %>
<%

    String sid = request.getParameter("sid");
    String[] args = sid.split(" ");
    String section_id = args[0];
    int class_id = Integer.parseInt(args[1]);
    String start_date = request.getParameter("start_date");
    String end_date = request.getParameter("end_date");
    // Optional: Connect to your database and insert the data
    String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
    String user = "postgres";
    String password = "James2085";

    try {
        // Load the database driver
        Class.forName("org.postgresql.Driver");

        // Establish connection
        Connection conn = DriverManager.getConnection(url, user, password);
        LocalDate startDate = LocalDate.parse(start_date); // replace with your start date
        LocalDate endDate = LocalDate.parse(end_date); // replace with your end date

        ZonedDateTime startDateTime = startDate.atStartOfDay(ZoneId.of("America/Los_Angeles"));
        ZonedDateTime endDateTime = endDate.plusDays(1).atStartOfDay(ZoneId.of("America/Los_Angeles"));

        Set<ZonedDateTime> updatedFreeHours = new HashSet<>();
        for (ZonedDateTime dt = startDateTime; !dt.isAfter(endDateTime); dt = dt.plusHours(1)) {
            if (dt.getHour() < 8 || dt.getHour() >= 20) {
                continue; // Skip hours outside of 8am-6pm
            }
            //out.println("<p>" + dt + "</p>");
            updatedFreeHours.add(dt);
        }

        // First find all the classes that the students in the class are enrolled in
        String sql = "SELECT DISTINCT e2.*, m.* " +
                        "FROM Enrollment e2 " +
                        "JOIN Meeting m ON e2.class_id = m.class_id AND e2.section_id = m.section_id " +
                        "WHERE e2.student_id IN ( " +
                            "SELECT e1.student_id " +
                            "FROM Enrollment e1 " +
                            "WHERE e1.class_id = ? AND e1.section_id = ? " +
                        ") ";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, class_id);
        pstmt.setString(2, section_id);
        ResultSet rs = pstmt.executeQuery();
        //out.println("<p>"+ updatedFreeHours.size() + "</p>");
        out.println("<table border='1'>");
        out.println("<tr><th>student_id</th><th>class_id</th><th>section_id</th><th>date_start</th><th>date_end</th><th>time_start</th><th>time_end</th><th>days_of_week</th></tr>");
        // Then, for each class, put them in the arraylist, and also look if they have any review sessions
        while (rs.next()) {
            ArrayList<String> studentClass = new ArrayList<String>();
            studentClass.add(rs.getString("date_start"));
            studentClass.add(rs.getString("date_end"));
            studentClass.add(rs.getString("time_start"));
            studentClass.add(rs.getString("time_end"));
            studentClass.add(rs.getString("days_of_week"));
            //out.println("<p> line 132: " + convertDaysOfWeek(rs.getString("days_of_week")) + "</p>");
            updatedFreeHours = updateFreeHours(updatedFreeHours, studentClass);
            // List<ZonedDateTime> sortedHours = new ArrayList<>(updatedFreeHours);
            // out.println("<p> line 134: printing current hours: </p>");
            // Collections.sort(sortedHours);
            // //out.println("<p>"+ updatedFreeHours.size() + "</p>");
            // out.println("<p>" + studentClass + "</p>");

            // // print the sorted hours
            // DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            // for (ZonedDateTime hour : sortedHours) {
            //     //out.println("<p>" + hour + "</p>");
            //     out.println("<p>" + hour.format(formatter) + " " + hour.getDayOfWeek().toString() + "</p>");
            // }
            out.println("<tr>");
            out.println("<td>" + rs.getString("student_id") + "</td>");
            out.println("<td>" + rs.getString("class_id") + "</td>");
            out.println("<td>" + rs.getString("section_id") + "</td>");
            out.println("<td>" + rs.getString("date_start") + "</td>");
            out.println("<td>" + rs.getString("date_end") + "</td>");
            out.println("<td>" + rs.getString("time_start") + "</td>");
            out.println("<td>" + rs.getString("time_end") + "</td>");
            out.println("<td>" + rs.getString("days_of_week") + "</td>");
            out.println("</tr>");
            sql = "SELECT * FROM Review_session WHERE class_id = ? AND section_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, rs.getInt("class_id"));
            pstmt.setString(2, rs.getString("section_id"));
            ResultSet rs2 = pstmt.executeQuery();
            while (rs2.next()) {
                ArrayList<String> reviewSession = new ArrayList<String>();
                reviewSession.add(rs2.getString("date"));
                reviewSession.add(rs2.getString("time_start"));
                reviewSession.add(rs2.getString("time_end"));
                updatedFreeHours = updateReviewSessions(updatedFreeHours, reviewSession);
                out.println("<tr>");
                out.println("<td>" + rs.getString("student_id") + "</td>");
                out.println("<td>" + rs.getString("class_id") + "</td>");
                out.println("<td>" + rs.getString("section_id") + "</td>");
                out.println("<td>" + rs2.getString("date") + "</td>");
                out.println("<td>" + "(review session)" + "</td>");
                out.println("<td>" + rs2.getString("time_start") + "</td>");
                out.println("<td>" + rs2.getString("time_end") + "</td>");
                out.println("<td>" + "(review session)"  + "</td>");
                out.println("</tr>");
            }
        }


       // Assuming 'hours' is your Set of ZonedDateTime objects

        List<ZonedDateTime> sortedHours = new ArrayList<>(updatedFreeHours);
        Collections.sort(sortedHours);
        //out.println("<p>"+ updatedFreeHours.size() + "</p>");

        // print the sorted hours
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("HH:mm:ss");
        for (ZonedDateTime hour : sortedHours) {
            //out.println("<p>" + hour + "</p>");
            out.println("<p>" + hour.format(formatter) + "-" + hour.plusHours(1).format(formatter2) + " " + hour.getDayOfWeek().toString() + "</p>");
        }
        



    } catch (ClassNotFoundException e) {
        out.println("<p>Error loading driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p>Error in SQL: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>