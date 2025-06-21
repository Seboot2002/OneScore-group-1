const db = require('../../config/database');

const Album = {
    // Servicio Básico: Obtener todos los álbumes con información de artista y género
    getAll: (callback) => {
        const query = `
        SELECT alb.*, a.name as artist_name, g.name as genre_name
        FROM Album alb
        LEFT JOIN Artist a ON alb.artist_id = a.id
        LEFT JOIN Genre g ON alb.genre_id = g.id
        `;
        db.all(query, callback);
    },

    // Servicio Básico: Obtener un álbum por ID con información de artista y género
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

    // Servicio Básico: Crear un nuevo álbum
    create: (albumData, callback) => {
        const { title, release_year, genre_id, cover_url, artist_id } = albumData;
        const query = `
        INSERT INTO Album (title, release_year, genre_id, cover_url, artist_id)
        VALUES (?, ?, ?, ?, ?)
        `;
        db.run(query, [title, release_year, genre_id, cover_url, artist_id], function(err) {
            if (err) {
                callback(err, null);
                return;
            }
            // Obtener el álbum recién creado con información de artista y género
            Album.getById(this.lastID, callback);
        });
    },

    // Servicio Básico: Actualizar un álbum existente
    update: (id, albumData, callback) => {
        const { title, release_year, genre_id, cover_url, artist_id } = albumData;
        const query = `
        UPDATE Album 
        SET title = ?, release_year = ?, genre_id = ?, cover_url = ?, artist_id = ?
        WHERE id = ?
        `;
        db.run(query, [title, release_year, genre_id, cover_url, artist_id, id], function(err) {
            if (err) {
                callback(err, null);
                return;
            }
            if (this.changes === 0) {
                callback(new Error('Album not found'), null);
                return;
            }
            // Obtener el álbum actualizado con información de artista y género
            Album.getById(id, callback);
        });
    },

    // Servicio Básico: Eliminar un álbum
    delete: (id, callback) => {
        const query = `DELETE FROM Album WHERE id = ?`;
        db.run(query, [id], function(err) {
            if (err) {
                callback(err, null);
                return;
            }
            if (this.changes === 0) {
                callback(new Error('Album not found'), null);
                return;
            }
            callback(null, { message: 'Album deleted successfully', deletedId: id });
        });
    },

    // Servicio Básico: Obtener álbumes por artista
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

    // Servicio Básico: Obtener álbumes por género
    getByGenreId: (genreId, callback) => {
        const query = `
        SELECT alb.*, a.name as artist_name, g.name as genre_name
        FROM Album alb
        LEFT JOIN Artist a ON alb.artist_id = a.id
        LEFT JOIN Genre g ON alb.genre_id = g.id
        WHERE alb.genre_id = ?
        `;
        db.all(query, [genreId], callback);
    },

    searchByKeyword: (keyword, callback) => {
        const query = `
        SELECT id, title, cover_url
        FROM Album 
        WHERE title LIKE ?
        `;
        const searchTerm = `%${keyword}%`;
        db.all(query, [searchTerm], callback);
    }
};

module.exports = Album;