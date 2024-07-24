<%@ page import="java.sql.*" %>
<%! 
    public Connection getConnection() throws Exception {
        String dbURL = "jdbc:mysql://localhost:3306/travel_management";
        String dbUser = "root";
        String dbPassword = "Kimbhu@143";
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(dbURL, dbUser, dbPassword);
    }
%>
