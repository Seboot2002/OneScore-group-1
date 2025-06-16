-- Insert sample genres
INSERT INTO Genre (name) VALUES 
('Rock'),
('Pop'),
('Hip Hop'),
('Electronic'),
('Jazz'),
('Classical');

-- Insert sample users
INSERT INTO User (name, last_name, nickname, mail, password) VALUES 
('John', 'Doe', 'johndoe', 'john@email.com', '$2a$10$example_hashed_password'),
('Jane', 'Smith', 'janesmith', 'jane@email.com', '$2a$10$example_hashed_password'),
('Mike', 'Johnson', 'mikej', 'mike@email.com', '$2a$10$example_hashed_password');

-- Insert sample artists
INSERT INTO Artist (name, genre_id, picture_url, debut_year) VALUES 
('The Beatles', 1, 'https://example.com/beatles.jpg', 1960),
('Michael Jackson', 2, 'https://example.com/mj.jpg', 1971),
('Eminem', 3, 'https://example.com/eminem.jpg', 1996),
('Daft Punk', 4, 'https://example.com/daftpunk.jpg', 1993);

-- Insert sample albums
INSERT INTO Album (title, release_year, genre_id, cover_url, artist_id) VALUES 
('Abbey Road', 1969, 1, 'https://example.com/abbeyroad.jpg', 1),
('Thriller', 1982, 2, 'https://example.com/thriller.jpg', 2),
('The Marshall Mathers LP', 2000, 3, 'https://example.com/mmlp.jpg', 3),
('Random Access Memories', 2013, 4, 'https://example.com/ram.jpg', 4);

-- Insert sample songs
INSERT INTO Song (title, n_track, album_id) VALUES 
('Come Together', 1, 1),
('Something', 2, 1),
('Billie Jean', 1, 2),
('Beat It', 2, 2),
('The Real Slim Shady', 1, 3),
('Stan', 2, 3),
('Get Lucky', 1, 4),
('Instant Crush', 2, 4);