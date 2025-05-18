EXPLAIN ANALYZE
SELECT u.username, COUNT(b.booking_id) AS booking_count
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY u.user_id
ORDER BY booking_count DESC
LIMIT 10;
