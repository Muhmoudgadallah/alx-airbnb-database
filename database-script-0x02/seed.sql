-- Sample Data for Airbnb-like Platform

-- PropertyTypes (Lookup Table)
INSERT INTO PropertyTypes (name) VALUES
("Apartment"),
("House"),
("Room"),
("Villa"),
("Cottage");

-- Amenities (Lookup Table)
INSERT INTO Amenities (name, description) VALUES
("WiFi", "Wireless Internet Access"),
("Kitchen", "Fully equipped kitchen"),
("TV", "Television with cable/streaming"),
("Heating", "Central heating or space heaters"),
("Washer", "In-unit or shared washing machine"),
("Dryer", "In-unit or shared dryer"),
("Air Conditioning", "Air conditioning unit(s)"),
("Pool", "Access to a swimming pool"),
("Gym", "Access to fitness equipment"),
("Fireplace", "Indoor fireplace");

-- Users
INSERT INTO Users (user_id, first_name, last_name, email, password_hash, phone_number, profile_picture_url, registration_date, last_login_date, is_verified, user_status) VALUES
(1, "John", "Doe", "john.doe@example.com", "hashed_password_1", "123-456-7890", "/images/user1.jpg", "2023-01-15 09:00:00", "2023-01-15 09:00:00", TRUE, "active"),
(2, "Jane", "Smith", "jane.smith@example.com", "hashed_password_2", "234-567-8901", "/images/user2.jpg", "2023-02-20 10:30:00", "2023-02-20 10:30:00", TRUE, "active"),
(3, "Alice", "Wonder", "alice.wonder@example.com", "hashed_password_3", "345-678-9012", "/images/user3.jpg", "2023-03-25 11:45:00", "2023-03-25 11:45:00", FALSE, "active");

-- Properties
-- Assuming PropertyTypeIDs: Apartment=1, House=2, Room=3, Villa=4, Cottage=5
INSERT INTO Properties (property_id, host_id, title, description, address_street, address_city, address_state, address_zip_code, address_country, latitude, longitude, property_type_id, num_rooms, num_bathrooms, max_guests, price_per_night, status, created_at, updated_at) VALUES
(1, 1, "Cozy Downtown Apartment", "A lovely apartment in the heart of the city.", "123 Main St", "San Francisco", "CA", "94107", "USA", 37.7749, -122.4194, 1, 2, 1, 4, 150.00, "available", "2023-01-15 09:00:00", "2023-01-15 09:00:00"),
(2, 2, "Spacious Villa with Ocean View", "A beautiful villa with stunning ocean views.", "456 Ocean Dr", "Malibu", "CA", "90265", "USA", 34.0300, -118.7789, 4, 5, 4, 10, 500.00, "available", "2023-02-20 10:30:00", "2023-02-20 10:30:00"),
(3, 1, "Charming Cottage in the Woods", "A quiet and peaceful cottage surrounded by nature.", "789 Forest Ln", "Asheville", "NC", "28801", "USA", 35.5951, -82.5515, 5, 3, 2, 6, 250.00, "available", "2023-03-10 14:00:00", "2023-03-10 14:00:00");

-- PropertyAmenities (Linking Table)
-- Assuming AmenityIDs: WiFi=1, Kitchen=2, TV=3, Heating=4, Washer=5, Dryer=6, AC=7, Pool=8, Gym=9, Fireplace=10
INSERT INTO PropertyAmenities (property_id, amenity_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), -- Cozy Downtown Apartment: WiFi, Kitchen, TV, Heating
(2, 1), (2, 2), (2, 3), (2, 7), (2, 8), -- Spacious Villa: WiFi, Kitchen, TV, AC, Pool
(3, 1), (3, 2), (3, 4), (3, 10); -- Charming Cottage: WiFi, Kitchen, Heating, Fireplace

-- Bookings
INSERT INTO Bookings (booking_id, user_id, property_id, check_in_date, check_out_date, num_guests, total_price, status, created_at) VALUES
(1, 2, 1, "2024-06-01", "2024-06-05", 2, 600.00, "confirmed", "2024-05-15 10:00:00"),
(2, 1, 2, "2024-07-10", "2024-07-15", 4, 2500.00, "confirmed", "2024-06-01 11:00:00"),
(3, 3, 3, "2024-08-01", "2024-08-03", 2, 500.00, "pending", "2024-07-20 12:00:00"),
(4, 2, 3, "2024-09-01", "2024-09-07", 3, 1750.00, "confirmed", "2024-08-10 14:00:00");

-- Reviews
INSERT INTO Reviews (review_id, booking_id, user_id, property_id, rating, comment, review_date) VALUES
(1, 1, 2, 1, 5, "Great place, very clean and cozy. Host was very responsive.", "2024-06-06 09:00:00"),
(2, 2, 1, 2, 4, "Enjoyed the stay, beautiful view. A bit pricey but worth it for a special occasion.", "2024-07-16 15:00:00"),
(3, 4, 2, 3, 5, "Absolutely loved the cottage! So peaceful and charming. Will definitely come back.", "2024-09-08 10:00:00");

-- Payments
INSERT INTO Payments (payment_id, booking_id, payment_date, payment_amount, payment_method, transaction_id, status) VALUES
(1, 1, "2024-05-15 10:05:00", 600.00, "Credit Card", "txn_12345abcdef", "successful"),
(2, 2, "2024-06-01 11:05:00", 2500.00, "PayPal", "txn_67890ghijkl", "successful"),
(3, 4, "2024-08-10 14:05:00", 1750.00, "Credit Card", "txn_mnopq45678", "successful");


