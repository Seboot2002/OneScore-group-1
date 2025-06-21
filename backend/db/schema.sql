-- Create Users table
CREATE TABLE User (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    nickname TEXT UNIQUE NOT NULL,
    mail TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    photo_url TEXT
);

-- Create Genre table
CREATE TABLE Genre (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL
);

-- Create Artist table
CREATE TABLE Artist (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    genre_id INTEGER NOT NULL,
    picture_url TEXT,
    debut_year INTEGER,
    FOREIGN KEY (genre_id) REFERENCES Genre(id)
);

-- Create Album table
CREATE TABLE Album (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    release_year INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    cover_url TEXT,
    artist_id INTEGER NOT NULL,
    FOREIGN KEY (genre_id) REFERENCES Genre(id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id)
);

-- Create Song table
CREATE TABLE Song (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    n_track INTEGER NOT NULL,
    album_id INTEGER NOT NULL,
    FOREIGN KEY (album_id) REFERENCES Album(id)
);

-- Create Artist_User junction table
CREATE TABLE Artist_User (
    user_id INTEGER NOT NULL,
    artist_id INTEGER NOT NULL,
    rank_state TEXT CHECK(rank_state IN ('Valorado', 'Por valorar')),
    PRIMARY KEY (user_id, artist_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id)
);

-- Create Album_User junction table
CREATE TABLE Album_User (
    user_id INTEGER NOT NULL,
    album_id INTEGER NOT NULL,
    rank_date DATE,
    rank_state TEXT CHECK(rank_state IN ('Valorado', 'Por valorar')),
    PRIMARY KEY (user_id, album_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (album_id) REFERENCES Album(id)
);

-- Create Song_User junction table
CREATE TABLE Song_User (
    user_id INTEGER NOT NULL,
    song_id INTEGER NOT NULL,
    score INTEGER CHECK(score >= 1 AND score <= 100),
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (song_id) REFERENCES Song(id)
);