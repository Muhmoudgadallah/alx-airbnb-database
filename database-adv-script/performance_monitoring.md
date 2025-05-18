-- Enable profiling in MySQL
SET profiling = 1;

-- Run your frequent queries here (example: recent bookings query)
SELECT u.username, p.property_name, b.start_date 
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.start_date > '2023-01-01'
ORDER BY b.start_date DESC
LIMIT 100;

-- View query profile
SHOW PROFILE;

-- For PostgreSQL, use EXPLAIN ANALYZE
EXPLAIN ANALYZE 
SELECT u.username, p.property_name, b.start_date 
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
WHERE b.start_date > '2023-01-01'
ORDER BY b.start_date DESC
LIMIT 100;
