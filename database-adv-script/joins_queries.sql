SELECT b.*, u.*
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id;


SELECT p.*, r.*
FROM properties p
LEFT JOIN reviews r ON p.property_id = r.property_id;


SELECT u.*, b.*
FROM users u
FULL OUTER JOIN bookings b ON u.user_id = b.user_id;
