-- Users table indexes
CREATE INDEX idx_users_user_id ON users(user_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Bookings table indexes
CREATE INDEX idx_bookings_booking_id ON bookings(booking_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_booking_date ON bookings(booking_date);
CREATE INDEX idx_bookings_status ON bookings(status);

-- Properties table indexes
CREATE INDEX idx_properties_property_id ON properties(property_id);
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_location ON properties(location);
CREATE INDEX idx_properties_price ON properties(price);
CREATE INDEX idx_properties_rating ON properties(rating);

-- Composite indexes
CREATE INDEX idx_bookings_user_property ON bookings(user_id, property_id);
CREATE INDEX idx_properties_location_price ON properties(location, price);


EXPLAIN ANALYZE
SELECT u.username, COUNT(b.booking_id) AS booking_count
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY u.user_id
ORDER BY booking_count DESC
LIMIT 10;
