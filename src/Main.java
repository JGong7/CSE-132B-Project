package src;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.*;

public class Main {
    public static void main(String[] args) {
        // Connection URL
        String url = "jdbc:postgresql://cse132b.cxa6600i8ci8.us-east-2.rds.amazonaws.com:5432/postgres";
        String user = "postgres";
        String password = "James2085";
        String port = "5432";

        try {
            // Load the PostgreSQL JDBC driver
            Class.forName("org.postgresql.Driver");

            // Establish the connection
            Connection conn = DriverManager.getConnection(url, user, password);
            // If connection is successfully established, print a message
            if (conn != null) {
                System.out.println("Connected to the database!");
            } else {
                System.out.println("Failed to make connection!");
            }

            Statement stmt = conn.createStatement();
            String sql = "CREATE TABLE Faculty (" +
             "ID INT PRIMARY KEY     NOT NULL," +
             "NAME           TEXT    NOT NULL," +
             "AGE            INT     NOT NULL," +
             "ADDRESS        CHAR(50)," +
             "SALARY         REAL )";
            stmt.executeUpdate(sql);

            // After creating the table
            String checkTableExists = "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'faculty')";
            ResultSet rs = stmt.executeQuery(checkTableExists);
            if (rs.next()) {
                boolean exists = rs.getBoolean(1);
                if (exists) {
                    System.out.println("Table created successfully");
                } else {
                    System.out.println("Table creation failed");
                }
            }
        
            // Close the connection
            conn.close();
        } catch (ClassNotFoundException ex) {
            System.out.println("PostgreSQL JDBC Driver is not found. Include it in your library path.");
            ex.printStackTrace();
        } catch (SQLException ex) {
            System.out.println("Connection Failed! Check output console.");
            ex.printStackTrace();
        }
    }
}
