<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.time.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Find Free Time Slots</title>
</head>
<body>
<%!
    class TimeSlot {
        private LocalTime startTime;
        private LocalTime endTime;
        private LocalDate date;

        public TimeSlot(LocalTime startTime, LocalTime endTime, LocalDate date) {
            this.startTime = startTime;
            this.endTime = endTime;
            this.date = date;
        }

        @Override
        public String toString() {
            return date.toString() + " from " + startTime.toString() + " to " + endTime.toString();
        }
    }
%>
<%!
     // Method to calculate free slots
    public Set<TimeSlot> calculateFreeTimeSlots(List<TimeSlot> occupied, LocalDate start, LocalDate end) {
        Set<TimeSlot> freeSlots = new HashSet<>();
        LocalTime startTime = LocalTime.of(8, 0); // 8:00 AM
        LocalTime endTime = LocalTime.of(20, 0); // 8:00 PM

        for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
            LocalTime time = startTime;
            while (time.plusHours(1).isBefore(endTime.plusSeconds(1))) {
                TimeSlot slot = new TimeSlot(time, time.plusHours(1), date);
                if (!isOccupied(slot, occupied)) {
                    freeSlots.add(slot);
                }
                time = time.plusHours(1);
            }
        }

        return freeSlots;
    }

    private boolean isOccupied(TimeSlot slot, List<TimeSlot> occupied) {
        for (TimeSlot busy : occupied) {
            if (busy.getDate().equals(slot.getDate()) &&
                !busy.getEndTime().isBefore(slot.getStartTime()) &&
                !busy.getStartTime().isAfter(slot.getEndTime())) {
                return true;
            }
        }
        return false;
    }
%>
<%

    String sid = request.getParameter("sid");
    String[] args = sid.split(" ");
    String section_id = args[0];
    int class_id = Integer.parseInt(args[1]);
    String start_date = request.getParameter("start_date");
    String end_date = request.getParameter("end_date");

    // Database credentials should ideally be stored in a secure configuration file or environment variable
    String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
    String user = "postgres";
    String password = "James2085";

    try {
        // Load the database driver
        Class.forName("org.postgresql.Driver");
        // Establish connection
        Connection conn = DriverManager.getConnection(url, user, password);

        String sql = "SELECT DISTINCT m.time_start, m.time_end, m.date_start, m.date_end " +
                        "FROM Enrollment e " +
                        "JOIN Meeting m ON e.class_id = m.class_id AND e.section_id = m.section_id " +
                        "WHERE e.class_id = ? AND e.section_id = ? AND m.date_start BETWEEN ? AND ?";

        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, class_id);
        pstmt.setString(2, section_id);
        pstmt.setDate(3, java.sql.Date.valueOf(start_date));
        pstmt.setDate(4, java.sql.Date.valueOf(end_date));
        ResultSet rs = pstmt.executeQuery();

        // Logic to find free time slots
        List<TimeSlot> occupiedSlots = new ArrayList<>();
        while (rs.next()) {
            TimeSlot slot = new TimeSlot(rs.getTime("time_start").toLocalTime(), rs.getTime("time_end").toLocalTime(), rs.getDate("date_start").toLocalDate());
            occupiedSlots.add(slot);
        }

        Set<TimeSlot> freeSlots = calculateFreeTimeSlots(occupiedSlots, LocalDate.parse(start_date), LocalDate.parse(end_date));

        out.println("<h2>Free Time Slots</h2>");
        for (TimeSlot slot : freeSlots) {
            out.println("<p>" + slot + "</p>");
        }

    } catch (ClassNotFoundException e) {
        out.println("<p>Error loading driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p>Error in SQL: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>
