# ERD for Airbnb-like Platform

## Entities and Attributes:

### Users
- user_id (PK)
- first_name
- last_name
- email (UNIQUE)
- password_hash
- phone_number
- profile_picture_url
- registration_date
- status

### Properties
- property_id (PK)
- host_id (FK references Users.user_id)
- title
- description
- address_street
- address_city
- address_state
- address_zip_code
- address_country
- latitude
- longitude
- property_type (e.g., 'Apartment', 'House', 'Room')
- num_rooms
- num_bathrooms
- max_guests
- price_per_night
- created_at
- updated_at

### Bookings
- booking_id (PK)
- user_id (FK references Users.user_id)
- property_id (FK references Properties.property_id)
- check_in_date
- check_out_date
- num_guests
- total_price
- status (e.g., 'Pending', 'Confirmed', 'Cancelled', 'Completed')
- created_at

### Reviews
- review_id (PK)
- booking_id (FK references Bookings.booking_id)
- user_id (FK references Users.user_id)  -- reviewer
- property_id (FK references Properties.property_id) -- reviewed property
- rating (e.g., 1-5 stars)
- comment
- created_at

## Relationships:

- **Users - Properties**: One-to-Many (A user can own multiple properties, but a property belongs to only one user).
  - `Users.user_id` (1) -- (M) `Properties.host_id`

- **Users - Bookings**: One-to-Many (A user can make multiple bookings, but a booking is made by only one user).
  - `Users.user_id` (1) -- (M) `Bookings.user_id`

- **Properties - Bookings**: One-to-Many (A property can have multiple bookings, but a booking is for only one property).
  - `Properties.property_id` (1) -- (M) `Bookings.property_id`

- **Bookings - Reviews**: One-to-Many (A booking can have multiple reviews, but a review is for only one booking).
  - `Bookings.booking_id` (1) -- (M) `Reviews.booking_id`

- **Users - Reviews**: One-to-Many (A user can write multiple reviews, but a review is written by only one user).
  - `Users.user_id` (1) -- (M) `Reviews.user_id`

- **Properties - Reviews**: One-to-Many (A property can have multiple reviews, but a review is for only one property).
  - `Properties.property_id` (1) -- (M) `Reviews.property_id`

