const db = require('../../config/database');

const Artist = {
    // Obtener todos los artistas con información de género
    getAll: (callback) => {
        const query = `
        SELECT a.*, g.name as genre_name
        FROM Artist a
        LEFT JOIN Genre g ON a.genre_id = g.id
        `;
        db.all(query, callback);
    },

    // Obtener un artista por ID con información de género
    getById: (id, callback) => {
        const query = `
        SELECT a.*, g.name as genre_name
        FROM Artist a
        LEFT JOIN Genre g ON a.genre_id = g.id
        WHERE a.id = ?
        `;
        db.get(query, [id], callback);
    },

    // Crear un nuevo artista
    create: (artistData, callback) => {
        const query = `
        INSERT INTO Artist (name, genre_id, bio, profile_image)
        VALUES (?, ?, ?, ?)
        `;
        const { name, genre_id, bio, profile_image } = artistData;
        db.run(query, [name, genre_id, bio, profile_image], callback);
    },

    // Actualizar un artista existente
    update: (id, artistData, callback) => {
        const query = `
        UPDATE Artist 
        SET name = ?, genre_id = ?, bio = ?, profile_image = ?
        WHERE id = ?
        `;
        const { name, genre_id, bio, profile_image } = artistData;
        db.run(query, [name, genre_id, bio, profile_image, id], callback);
    },

    // Eliminar un artista
    delete: (id, callback) => {
        const query = `DELETE FROM Artist WHERE id = ?`;
        db.run(query, [id], callback);
    },

    // Obtener artistas por género
    getByGenreId: (genreId, callback) => {
        const query = `
        SELECT a.*, g.name as genre_name
        FROM Artist a
        LEFT JOIN Genre g ON a.genre_id = g.id
        WHERE a.genre_id = ?
        `;
        db.all(query, [genreId], callback);
    }
};

module.exports = Artist;