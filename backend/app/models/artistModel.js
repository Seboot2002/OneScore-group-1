const db = require('../../config/database');

const Artist = {
    // Servicio Básico: Obtener todos los artistas con información de género
    getAll: (callback) => {
        const query = `
        SELECT a.*, g.name as genre_name
        FROM Artist a
        LEFT JOIN Genre g ON a.genre_id = g.id
        `;
        db.all(query, callback);
    },

    // Servicio Básico: Obtener un artista por ID con información de género
    getById: (id, callback) => {
        const query = `
        SELECT a.*, g.name as genre_name
        FROM Artist a
        LEFT JOIN Genre g ON a.genre_id = g.id
        WHERE a.id = ?
        `;
        db.get(query, [id], callback);
    },

    // Servicio Básico: Crear nuevo artista
    create: (artistData, callback) => {
        const { name, genre_id, picture_url, debut_year } = artistData;
        const query = `
        INSERT INTO Artist (name, genre_id, picture_url, debut_year)
        VALUES (?, ?, ?, ?)
        `;
        db.run(query, [name, genre_id, picture_url, debut_year], function(err) {
            if (err) {
                callback(err);
                return;
            }
            // Retornar el artista creado con su información completa
            Artist.getById(this.lastID, callback);
        });
    },

    // Servicio Básico: Actualizar artista existente
    update: (id, artistData, callback) => {
        const { name, genre_id, picture_url, debut_year } = artistData;
        const query = `
        UPDATE Artist 
        SET name = ?, genre_id = ?, picture_url = ?, debut_year = ?
        WHERE id = ?
        `;
        db.run(query, [name, genre_id, picture_url, debut_year, id], function(err) {
            if (err) {
                callback(err);
                return;
            }
            if (this.changes === 0) {
                callback(new Error('Artist not found'));
                return;
            }
            // Retornar el artista actualizado con su información completa
            Artist.getById(id, callback);
        });
    },

    // Servicio Básico: Eliminar artista
    delete: (id, callback) => {
        // Primero obtener el artista antes de eliminarlo
        Artist.getById(id, (err, artist) => {
            if (err) {
                callback(err);
                return;
            }
            if (!artist) {
                callback(new Error('Artist not found'));
                return;
            }
            
            const query = `DELETE FROM Artist WHERE id = ?`;
            db.run(query, [id], function(err) {
                if (err) {
                    callback(err);
                    return;
                }
                // Retornar el artista eliminado
                callback(null, artist);
            });
        });
    },

    // Método auxiliar para validar que el genre_id existe
    validateGenreExists: (genre_id, callback) => {
        const query = `SELECT id FROM Genre WHERE id = ?`;
        db.get(query, [genre_id], (err, row) => {
            if (err) {
                callback(err);
                return;
            }
            callback(null, !!row);
        });
    },

    searchByKeyword: (keyword, callback) => {
        const query = `
        SELECT id, picture_url, name
        FROM Artist 
        WHERE name LIKE ?
        `;
        const searchTerm = `%${keyword}%`;
        db.all(query, [searchTerm], callback);
    }
};

module.exports = Artist;