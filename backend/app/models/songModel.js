const db = require('../../config/database');

const Song = {
    // Obtener todas las canciones con información de álbum y artista
    getAll: (callback) => {
        const query = `
        SELECT s.*, alb.title as album_title, a.name as artist_name
        FROM Song s
        LEFT JOIN Album alb ON s.album_id = alb.id
        LEFT JOIN Artist a ON alb.artist_id = a.id
        `;
        db.all(query, callback);
    },

    // Obtener una canción por ID con información de álbum y artista
    getById: (id, callback) => {
        const query = `
        SELECT s.*, alb.title as album_title, a.name as artist_name
        FROM Song s
        LEFT JOIN Album alb ON s.album_id = alb.id
        LEFT JOIN Artist a ON alb.artist_id = a.id
        WHERE s.id = ?
        `;
        db.get(query, [id], callback);
    },

    // Crear una nueva canción
    create: (songData, callback) => {
        const query = `
        INSERT INTO Song (title, album_id, duration, track_number, audio_file)
        VALUES (?, ?, ?, ?, ?)
        `;
        const { title, album_id, duration, track_number, audio_file } = songData;
        db.run(query, [title, album_id, duration, track_number, audio_file], callback);
    },

    // Actualizar una canción existente
    update: (id, songData, callback) => {
        const query = `
        UPDATE Song 
        SET title = ?, album_id = ?, duration = ?, track_number = ?, audio_file = ?
        WHERE id = ?
        `;
        const { title, album_id, duration, track_number, audio_file } = songData;
        db.run(query, [title, album_id, duration, track_number, audio_file, id], callback);
    },

    // Eliminar una canción
    delete: (id, callback) => {
        const query = `DELETE FROM Song WHERE id = ?`;
        db.run(query, [id], callback);
    },

    // Obtener canciones por álbum
    getByAlbumId: (albumId, callback) => {
        const query = `
        SELECT s.*, alb.title as album_title, a.name as artist_name
        FROM Song s
        LEFT JOIN Album alb ON s.album_id = alb.id
        LEFT JOIN Artist a ON alb.artist_id = a.id
        WHERE s.album_id = ?
        ORDER BY s.track_number
        `;
        db.all(query, [albumId], callback);
    },

    // Buscar canciones por título
    searchByTitle: (searchTerm, callback) => {
        const query = `
        SELECT s.*, alb.title as album_title, a.name as artist_name
        FROM Song s
        LEFT JOIN Album alb ON s.album_id = alb.id
        LEFT JOIN Artist a ON alb.artist_id = a.id
        WHERE s.title LIKE ?
        `;
        db.all(query, [`%${searchTerm}%`], callback);
    }
};

module.exports = Song;