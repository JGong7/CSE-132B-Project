package src;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
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
            
            // Create all the tables by init_db.sql
            String filePath = "../sql/init_db.sql";
            String sql = null;
            try {
                sql = new String(Files.readAllBytes(Paths.get(filePath)));
            } catch (IOException e) {
                System.out.println("Failed to read SQL file: " + e.getMessage());
                e.printStackTrace();
            }
            stmt.executeUpdate(sql);
            System.out.println("Tables created successfully!");
        
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
