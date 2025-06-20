const db = require('../../config/database');

const Song = {
    // Servició Básico: Obtener todas las canciones con información de álbum y artista
    getAll: (callback) => {
        const query = `
        SELECT s.*, alb.title as album_title, a.name as artist_name
        FROM Song s
        LEFT JOIN Album alb ON s.album_id = alb.id
        LEFT JOIN Artist a ON alb.artist_id = a.id
        `;
        db.all(query, callback);
    },

    // Servicio Básico: Obtener una canción por ID con información de álbum y artista
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

    // Servicio Básico: Crear nueva canción
    create: (songData, callback) => {
        const { title, n_track, album_id } = songData;
        const query = `
        INSERT INTO Song (title, n_track, album_id)
        VALUES (?, ?, ?)
        `;
        db.run(query, [title, n_track, album_id], function(err) {
            if (err) {
                callback(err);
                return;
            }
            // Retornar la canción creada con su información completa
            Song.getById(this.lastID, callback);
        });
    },

    // Servicio Básico: Actualizar canción existente
    update: (id, songData, callback) => {
        const { title, n_track, album_id } = songData;
        const query = `
        UPDATE Song 
        SET title = ?, n_track = ?, album_id = ?
        WHERE id = ?
        `;
        db.run(query, [title, n_track, album_id, id], function(err) {
            if (err) {
                callback(err);
                return;
            }
            if (this.changes === 0) {
                callback(new Error('Song not found'));
                return;
            }
            // Retornar la canción actualizada con su información completa
            Song.getById(id, callback);
        });
    },

    // Servicio Básico: Eliminar canción
    delete: (id, callback) => {
        // Primero obtener la canción antes de eliminarla
        Song.getById(id, (err, song) => {
            if (err) {
                callback(err);
                return;
            }
            if (!song) {
                callback(new Error('Song not found'));
                return;
            }
            
            const query = `DELETE FROM Song WHERE id = ?`;
            db.run(query, [id], function(err) {
                if (err) {
                    callback(err);
                    return;
                }
                // Retornar la canción eliminada
                callback(null, song);
            });
        });
    },

    // Servicio Básico: Método auxiliar para validar que el album_id existe
    validateAlbumExists: (album_id, callback) => {
        const query = `SELECT id FROM Album WHERE id = ?`;
        db.get(query, [album_id], (err, row) => {
            if (err) {
                callback(err);
                return;
            }
            callback(null, !!row);
        });
    }
};

module.exports = Song;