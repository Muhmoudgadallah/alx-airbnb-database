-- Initial query retrieving all booking details
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.booking_date,
    b.check_in,
    b.check_out,
    b.status,
    u.user_id,
    u.username,
    u.email,
    u.phone,
    p.property_id,
    p.property_name,
    p.location,
    p.price,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.user_id
JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pay ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_date DESC;




-- Optimized booking details query-- Optimized booking details query with AND conditions
SELECT 
    b.booking_id,
    b.booking_date,
    b.check_in,
    b.check_out,
    b.status,
    u.user_id,
    u.username,
    u.email,
    p.property_id,
    p.property_name,
    p.location,
    pay.amount,
    pay.payment_method
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
INNER JOIN 
    payments pay ON b.booking_id = pay.booking_id
WHERE 
    b.booking_date >= CURRENT_DATE - INTERVAL '6 months'
    AND b.status = 'confirmed'
    AND pay.payment_status = 'completed'
    AND p.is_active = true
ORDER BY 
    b.booking_date DESC
LIMIT 1000;
