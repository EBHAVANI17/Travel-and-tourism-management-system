<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    List<Map<String, String>> packages = new ArrayList<>();
    try (Connection con = getConnection()) {
        String sql = "SELECT * FROM packages WHERE package_name IN ('Goa', 'Kerala', 'Gokarna', 'Rajasthan', 'Gujarat')";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> packageData = new HashMap<>();
            packageData.put("id", rs.getString("package_id"));
            packageData.put("name", rs.getString("package_name"));
            packageData.put("description", rs.getString("description"));
            packageData.put("price", rs.getString("price"));
            packageData.put("duration", rs.getString("duration"));
            packageData.put("dates", rs.getString("available_dates"));
            packages.add(packageData);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Tourist Places</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-image: url("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRg5SVaJAaES6qIKj3-6LsR4RRnu0VrF4FiMQ&s");
            background-size: 80%;
            background-repeat: no-repeat;
            background-position: center;
        }
        .package-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 5px;
            color: white;
        }
        .package {
            border: 1px solid #ccc;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            background-color: rgba(255, 255, 255, 0.3);
        }
        .package h4 {
            margin: 0 0 10px;
        }
        .package p {
            margin: 5px 0;
        }
        .buttons {
            margin-top: 10px;
        }
        .buttons form, .buttons a {
            display: inline-block;
            margin-right: 10px;
        }
        .buttons button, .buttons a {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 5px;
        }
        .buttons button:hover, .buttons a:hover {
            background-color: #000;
        }
    </style>
</head>
<body>
    <div class="package-container">
        <h1>Top Tourist Places in India</h1>
        <ul>
            <% for (Map<String, String> packageData : packages) { %>
                <li class="package">
                    <h4><%= packageData.get("name") %></h4>
                    <p><%= packageData.get("description") %></p>
                    <p><strong>Price:</strong> $<%= packageData.get("price") %></p>
                    <p><strong>Duration:</strong> <%= packageData.get("duration") %> days</p>
                    <p><strong>Available Dates:</strong> <%= packageData.get("dates") %></p>
                    <div class="buttons">
                        <form action="book.jsp" method="post">
                            <input type="hidden" name="package_id" value="<%= packageData.get("id") %>">
                            <button type="submit">Book Now</button>
                        </form>
                        <a href="rate.jsp?package_id=<%= packageData.get("id") %>">Rate and Comment</a>
                        <a href="view_comments.jsp?package_id=<%= packageData.get("id") %>">View Comments</a>
                    </div>
                </li>
            <% } %>
        </ul>
        <a href="home.jsp">Back to Home</a>
    </div>
</body>
</html>
