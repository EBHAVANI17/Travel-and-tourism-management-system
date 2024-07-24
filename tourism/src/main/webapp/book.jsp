<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>
<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve travel packages
    List<Map<String, String>> packages = new ArrayList<>();
    try (Connection con = getConnection()) {
        String sql = "SELECT * FROM packages";
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
            packageData.put("image", "images/" + rs.getString("package_name").toLowerCase() + ".jpeg");
            packages.add(packageData);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // Placeholder data for ratings and comments
    List<String> ratings = new ArrayList<>();
    ratings.add("4.5");
    ratings.add("5.0");
    ratings.add("4.2");
    ratings.add("4.8");

    List<String> comments = new ArrayList<>();
    comments.add("Beautiful beaches and great nightlife!");
    comments.add("Amazing cultural experience!");
    comments.add("Rich history and architecture!");
    comments.add("Delicious food and friendly people!");

    // Handle booking form submission
    String message = "";
    String packageId = request.getParameter("package_id");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = (String) session.getAttribute("username");
        if (username != null && packageId != null) {
            try (Connection con = getConnection()) {
                String sql = "INSERT INTO bookings (user_id, package_id) VALUES (?, ?)";
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, (String) session.getAttribute("user_id"));
                ps.setString(2, packageId);
                int result = ps.executeUpdate();

                if (result > 0) {
                    // Retrieve the generated booking ID
                    ResultSet generatedKeys = ps.getGeneratedKeys();
                    int bookingId = -1;
                    if (generatedKeys.next()) {
                        bookingId = generatedKeys.getInt(1);
                    }
                    
                    // Redirect to booking confirmation page upon successful booking
                    response.sendRedirect("booking_confirmation.jsp?booking_id=" + bookingId);
                    return;
                } else {
                    message = "Booking failed!";
                }
            } catch (SQLException e) {
                e.printStackTrace();
                message = "SQL Error: " + e.getMessage();
            } catch (Exception e) {
                e.printStackTrace();
                message = "Error: " + e.getMessage();
            }
        } else {
            message = "You must be logged in to book a package!";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('path-to-your-background-image.jpeg');
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
            color: #333;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            border-radius: 10px;
            background-color: rgba(255, 255, 255, 0.9);
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .packages-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .package {
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 16px;
            background-color: #fff;
        }
        .package-image {
            width: 100%;
            height: auto;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .package-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        .package-description {
            font-size: 14px;
            color: #666;
        }
        .package-price {
            font-size: 16px;
            margin-top: 8px;
        }
        .book-form {
            margin-top: 10px;
        }
        .ratings-section {
            margin-top: 20px;
        }
        .ratings {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .comments-section {
            margin-top: 20px;
        }
        .comments {
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 5px;
            margin-bottom: 10px;
        }
        .message {
            color: red;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Welcome, <%= session.getAttribute("username") %>!</h2>
        <h3>Travel Packages</h3>
        <div class="packages-grid">
            <% for (Map<String, String> packageData : packages) { %>
                <div class="package">
                    <h4><%= packageData.get("name") %></h4>
                    <img class="package-image" src="<%= packageData.get("image") %>" alt="<%= packageData.get("name") %> Image">
                    <p class="package-description"><%= packageData.get("description") %></p>
                    <p class="package-price">Price: $<%= packageData.get("price") %></p>
                    <p>Duration: <%= packageData.get("duration") %> days</p>
                    <p>Available Dates: <%= packageData.get("dates") %></p>
                    
                    <form class="book-form" method="post">
                        <input type="hidden" name="package_id" value="<%= packageData.get("id") %>">
                        <button type="submit">Book Now</button>
                    </form>
                </div>
            <% } %>
        </div>

        <div class="ratings-section">
            <h3>Ratings</h3>
            <% for (int i = 0; i < ratings.size(); i++) { %>
                <div class="ratings">
                    <span><%= packages.get(i).get("name") %></span>
                    <span><%= ratings.get(i) %> / 5</span>
                </div>
            <% } %>
        </div>

        <div class="comments-section">
            <h3>Comments</h3>
            <% for (String comment : comments) { %>
                <div class="comments">
                    <%= comment %>
                </div>
            <% } %>
        </div>

        <a href="logout.jsp">Logout</a>
    </div>
</body>
</html>
