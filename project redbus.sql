-- Create table for storing bus details
CREATE TABLE buses (
    bus_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_name VARCHAR(255),
    bus_type VARCHAR(50),
    operator_name VARCHAR(255),
    star_rating DECIMAL(3,2),
    amenities VARCHAR(255)
);

-- Create table for storing route information
CREATE TABLE routes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    origin VARCHAR(255),
    destination VARCHAR(255),
    distance_km DECIMAL(6,2),
    travel_time_hours DECIMAL(4,2)
);

-- Create table for storing schedules of each bus
CREATE TABLE schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    bus_id INT,
    route_id INT,
    departure_time TIME,
    arrival_time TIME,
    date_of_travel DATE,
    FOREIGN KEY (bus_id) REFERENCES buses(bus_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- Create table for storing prices of each bus schedule
CREATE TABLE prices (
    price_id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_id INT,
    base_price DECIMAL(10,2),
    surge_price DECIMAL(10,2),
    discounts DECIMAL(10,2),
    final_price DECIMAL(10,2) AS (base_price + surge_price - discounts) STORED,
    FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id)
);

-- Create table for storing seat availability
CREATE TABLE seat_availability (
    availability_id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_id INT,
    total_seats INT,
    available_seats INT,
    FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id)
);
-- Insert data into the buses table
INSERT INTO buses (bus_name, bus_type, operator_name, star_rating, amenities)
VALUES
('KSRTC Airavata', 'AC Sleeper', 'KSRTC', 4.5, 'Wi-Fi, Charging Ports'),
('SRS Travels', 'Non-AC Sleeper', 'SRS', 3.8, 'Charging Ports'),
('VRL Travels', 'AC Seater', 'VRL', 4.1, 'Wi-Fi, Charging Ports'),
('Private Bus 1', 'AC Seater', 'Private', 3.9, 'Wi-Fi');

-- Insert data into the routes table
INSERT INTO routes (origin, destination, distance_km, travel_time_hours)
VALUES
('Bangalore', 'Chennai', 350.50, 6.5),
('Hyderabad', 'Vijayawada', 275.75, 5.0),
('Bangalore', 'Hyderabad', 570.00, 8.5),
('Mumbai', 'Pune', 150.00, 3.5);

-- Insert data into the schedules table
INSERT INTO schedules (bus_id, route_id, departure_time, arrival_time, date_of_travel)
VALUES
(1, 1, '22:00', '04:30', '2024-10-18'),
(2, 1, '21:30', '04:00', '2024-10-18'),
(3, 3, '22:00', '06:30', '2024-10-18'),
(4, 2, '18:00', '23:00', '2024-10-18');

-- Insert data into the prices table
INSERT INTO prices (schedule_id, base_price, surge_price, discounts)
VALUES
(1, 600.00, 50.00, 30.00),
(2, 550.00, 70.00, 25.00),
(3, 850.00, 100.00, 50.00),
(4, 450.00, 0.00, 50.00);

-- Insert data into the seat_availability table
INSERT INTO seat_availability (schedule_id, total_seats, available_seats)
VALUES
(1, 40, 10),
(2, 35, 5),
(3, 50, 25),
(4, 40, 15);


SELECT 
    b.bus_name, 
    b.bus_type, 
    r.origin, 
    r.destination, 
    s.departure_time, 
    s.arrival_time, 
    p.final_price, 
    b.star_rating, 
    sa.available_seats
FROM 
    buses b
JOIN 
    schedules s ON b.bus_id = s.bus_id
JOIN 
    routes r ON s.route_id = r.route_id
JOIN 
    prices p ON s.schedule_id = p.schedule_id
JOIN 
    seat_availability sa ON s.schedule_id = sa.schedule_id
WHERE 
    b.bus_type = 'AC Sleeper'
    AND r.origin = 'Bangalore'
    AND r.destination = 'Chennai'
    AND p.final_price BETWEEN 500 AND 1000
    AND b.star_rating >= 4.0
    AND sa.available_seats > 0;
