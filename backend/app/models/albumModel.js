const db = require('../../config/database');

const Album = {
    // Obtener todos los álbumes con información de artista y género
    getAll: (callback) => {
        const query = `
        SELECT alb.*, a.name as artist_name, g.name as genre_name
        FROM Album alb
        LEFT JOIN Artist a ON alb.artist_id = a.id
        LEFT JOIN Genre g ON alb.genre_id = g.id
        `;
        db.all(query, callback);
    },

    // Obtener un álbum por ID con información de artista y género
    getById: (id, callback) => {
        const query = `
        SELECT alb.*, a.name as artist_name, g.name as genre_name
        FROM Album alb
        LEFT JOIN Artist a ON alb.artist_id = a.id
        LEFT JOIN Genre g ON alb.genre_id = g.id
        WHERE alb.id = ?
        `;
        db.get(query, [id], callback);
    },

    // Crear un nuevo álbum
    create: (albumData, callback) => {
        const query = `
        INSERT INTO Album (title, artist_id, genre_id, release_date, cover_image)
        VALUES (?, ?, ?, ?, ?)
        `;
        const { title, artist_id, genre_id, release_date, cover_image } = albumData;
        db.run(query, [title, artist_id, genre_id, release_date, cover_image], callback);
    },

    // Actualizar un álbum existente
    update: (id, albumData, callback) => {
        const query = `
        UPDATE Album 
        SET title = ?, artist_id = ?, genre_id = ?, release_date = ?, cover_image = ?
        WHERE id = ?
        `;
        const { title, artist_id, genre_id, release_date, cover_image } = albumData;
        db.run(query, [title, artist_id, genre_id, release_date, cover_image, id], callback);
    },

    // Eliminar un álbum
    delete: (id, callback) => {
        const query = `DELETE FROM Album WHERE id = ?`;
        db.run(query, [id], callback);
    },

    // Obtener álbumes por artista
    getByArtistId: (artistId, callback) => {
        const query = `
        SELECT alb.*, a.name as artist_name, g.name as genre_name
        FROM Album alb
        LEFT JOIN Artist a ON alb.artist_id = a.id
        LEFT JOIN Genre g ON alb.genre_id = g.id
        WHERE alb.artist_id = ?
        `;
        db.all(query, [artistId], callback);
    },

    // Obtener álbumes por género
    getByGenreId: (genreId, callback) => {
        const query = `
        SELECT alb.*, a.name as artist_name, g.name as genre_name
        FROM Album alb
        LEFT JOIN Artist a ON alb.artist_id = a.id
        LEFT JOIN Genre g ON alb.genre_id = g.id
        WHERE alb.genre_id = ?
        `;
        db.all(query, [genreId], callback);
    }
};

module.exports = Album;