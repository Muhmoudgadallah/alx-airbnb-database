-- 1. Create partitioned table structure
CREATE TABLE bookings_partitioned (
    booking_id BIGSERIAL,
    user_id BIGINT NOT NULL,
    property_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    -- other columns as needed
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

-- 2. Create monthly partitions for current and future data
CREATE TABLE bookings_y2023m01 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');

CREATE TABLE bookings_y2023m02 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-02-01') TO ('2023-03-01');
    
-- Add more partitions as needed...

-- 3. Create default partition for future dates
CREATE TABLE bookings_future PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO (MAXVALUE);

-- 4. Migrate data from original table (run during maintenance window)
INSERT INTO bookings_partitioned
SELECT * FROM bookings;

-- 5. Replace original table (after verifying data integrity)
BEGIN;
ALTER TABLE bookings RENAME TO bookings_old;
ALTER TABLE bookings_partitioned RENAME TO bookings;
COMMIT;

-- 6. Create indexes on each partition
CREATE INDEX idx_bookings_partitioned_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_partitioned_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_partitioned_status ON bookings(status);

-- Test query on partitioned table (will scan only relevant partitions)
EXPLAIN ANALYZE
SELECT * FROM bookings
WHERE start_date BETWEEN '2023-01-15' AND '2023-02-15'
AND status = 'confirmed';

-- Compare with query on original table
EXPLAIN ANALYZE
SELECT * FROM bookings_old
WHERE start_date BETWEEN '2023-01-15' AND '2023-02-15'
AND status = 'confirmed';
