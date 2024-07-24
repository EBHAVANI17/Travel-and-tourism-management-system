<%@ page import="java.sql.*, java.util.Map, java.util.HashMap" %>
<%@ include file="db.jsp" %>
<%
    String message = "";
    int bookingId = Integer.parseInt(request.getParameter("booking_id"));
    Map<String, String> packageData = new HashMap<>();

    // Retrieve booking details
    try (Connection con = getConnection()) {
        String sql = "SELECT * FROM bookings b JOIN packages p ON b.package_id = p.package_id WHERE b.booking_id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            packageData.put("name", rs.getString("package_name"));
            packageData.put("description", rs.getString("description"));
            packageData.put("price", rs.getString("price"));
            packageData.put("duration", rs.getString("duration"));
            packageData.put("dates", rs.getString("available_dates"));
            packageData.put("image", "images/" + rs.getString("package_name").toLowerCase() + ".jpeg");
        } else {
            message = "Booking not found!";
        }
    } catch (SQLException e) {
        e.printStackTrace();
        message = "SQL Error: " + e.getMessage();
    } catch (Exception e) {
        e.printStackTrace();
        message = "Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Booking Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            max-width: 600px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            animation: fadein 1s ease-out; /* Animation for fade-in effect */
        }
        .container img {
            max-width: 100%;
            border-radius: 8px;
            margin-top: 10px;
        }
        .container h2 {
            margin-bottom: 10px;
            color: #333;
        }
        .container p {
            color: #666;
            line-height: 1.6;
        }
        .container a {
            display: block;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }
        @keyframes fadein {
            from { opacity: 0; }
            to { opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Booking Confirmed!</h2>
        <img src="<%= packageData.get("image") %>" alt="Booked Package Image">
        <h3><%= packageData.get("name") %></h3>
        <p><%= packageData.get("description") %></p>
        <p>Price: $<%= packageData.get("price") %></p>
        <p>Duration: <%= packageData.get("duration") %> days</p>
        <p>Available Dates: <%= packageData.get("dates") %></p>
        <p>Booking ID: <%= bookingId %></p>
        <a href="home.jsp">Back to Home</a>
    </div>
</body>
</html>
