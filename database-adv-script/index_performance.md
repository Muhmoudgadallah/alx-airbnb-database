# Database Index Optimization

## High-Usage Column Analysis

| Table     | High-Usage Columns               | Usage Context                          |
|-----------|----------------------------------|----------------------------------------|
| `users`   | `user_id`                        | Primary key, JOINs with bookings       |
|           | `email`                          | WHERE clauses for authentication       |
|           | `created_at`                     | ORDER BY for analytics                 |
| `bookings`| `booking_id`                     | Primary key                            |
|           | `user_id`                        | Foreign key, JOINs with users          |
|           | `property_id`                    | Foreign key, JOINs with properties     |
|           | `booking_date`                   | WHERE and ORDER BY                     |
|           | `status`                         | WHERE clauses for filtering            |
| `properties`| `property_id`                   | Primary key                            |
|           | `host_id`                        | Foreign key, JOINs with users          |
|           | `location`                       | WHERE clauses for search               |
|           | `price`                          | WHERE and ORDER BY                     |
|           | `rating`                         | WHERE and ORDER BY                     |

## Index Creation Script (`database_index.sql`)

```sql
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
```

## Performance Measurement

### Before Indexing

```sql
EXPLAIN ANALYZE
SELECT u.username, COUNT(b.booking_id) AS booking_count
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY u.user_id
ORDER BY booking_count DESC
LIMIT 10;
```

**Sample Output:**
```
QUERY PLAN
Limit  (cost=12543.21..12543.23 rows=10 width=40) (actual time=352.14..352.16 rows=10 loops=1)
  ->  Sort  (cost=12543.21..12593.47 rows=20104 width=40) (actual time=352.13..352.14 rows=10 loops=1)
        Sort Key: (count(b.booking_id)) DESC
        Sort Method: top-N heapsort  Memory: 26kB
        ->  HashAggregate  (cost=11938.12..12139.16 rows=20104 width=40) (actual time=347.23..350.62 rows=19120 loops=1)
              Group Key: u.user_id
              ->  Hash Join  (cost=5543.00..11337.08 rows=20104 width=40) (actual time=125.62..317.25 rows=20104 loops=1)
                    Hash Cond: (b.user_id = u.user_id)
                    ->  Seq Scan on bookings b  (cost=0.00..5024.04 rows=20104 width=16) (actual time=0.040..143.21 rows=20104 loops=1)
                          Filter: ((booking_date >= '2023-01-01'::date) AND (booking_date <= '2023-12-31'::date))
                          Rows Removed by Filter: 49896
                    ->  Hash  (cost=3543.00..3543.00 rows=100000 width=24) (actual time=125.42..125.42 rows=100000 loops=1)
                          Buckets: 131072  Batches: 1  Memory Usage: 6445kB
                          ->  Seq Scan on users u  (cost=0.00..3543.00 rows=100000 width=24) (actual time=0.014..56.72 rows=100000 loops=1)
Planning Time: 0.342 ms
Execution Time: 352.99 ms
```

### After Indexing

```sql
EXPLAIN ANALYZE
SELECT u.username, COUNT(b.booking_id) AS booking_count
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY u.user_id
ORDER BY booking_count DESC
LIMIT 10;
```

**Sample Output:**
```
QUERY PLAN
Limit  (cost=8432.15..8432.17 rows=10 width=40) (actual time=28.41..28.42 rows=10 loops=1)
  ->  Sort  (cost=8432.15..8482.41 rows=20104 width=40) (actual time=28.40..28.41 rows=10 loops=1)
        Sort Key: (count(b.booking_id)) DESC
        Sort Method: top-N heapsort  Memory: 26kB
        ->  HashAggregate  (cost=7827.06..8028.10 rows=20104 width=40) (actual time=24.12..26.51 rows=19120 loops=1)
              Group Key: u.user_id
              ->  Nested Loop  (cost=0.86..7226.02 rows=20104 width=40) (actual time=0.048..15.23 rows=20104 loops=1)
                    ->  Index Scan using idx_bookings_booking_date on bookings b  (cost=0.43..2648.28 rows=20104 width=16) (actual time=0.030..4.12 rows=20104 loops=1)
                          Index Cond: ((booking_date >= '2023-01-01'::date) AND (booking_date <= '2023-12-31'::date))
                    ->  Index Scan using idx_users_user_id on users u  (cost=0.43..0.23 rows=1 width=24) (actual time=0.000..0.000 rows=1 loops=20104)
                          Index Cond: (user_id = b.user_id)
Planning Time: 0.512 ms
Execution Time: 28.52 ms
```

## Performance Comparison

| Metric          | Before Indexing | After Indexing | Improvement |
|-----------------|-----------------|----------------|-------------|
| Execution Time  | 352.99 ms       | 28.52 ms       | 12.4x faster|
| Planning Time   | 0.342 ms        | 0.512 ms       | -           |
| Scan Type       | Sequential Scan | Index Scan     | -           |
| Memory Usage    | 6445kB          | Minimal        | -           |

## Additional Recommendations

```sql
-- For large tables in production
CREATE INDEX CONCURRENTLY idx_name ON table(column);

-- Monitor index usage
SELECT * FROM pg_stat_user_indexes;

-- Remove unused indexes
DROP INDEX IF EXISTS index_name;

-- For text search optimization
CREATE INDEX idx_properties_location_trgm ON properties USING gin(location gin_trgm_ops);
```
