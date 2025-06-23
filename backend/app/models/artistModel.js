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

    getStatsByArtistId: (artistId, callback) => {
        const query = `
            SELECT 
                a.id AS artist_id,
                a.name AS artist_name,
                a.picture_url,
                a.debut_year,
                COUNT(DISTINCT al.id) AS album_count,
                COUNT(s.id) AS song_count
            FROM Artist a
            LEFT JOIN Album al ON al.artist_id = a.id
            LEFT JOIN Song s ON s.album_id = al.id
            WHERE a.id = ?
            GROUP BY a.id
        `;
        db.get(query, [artistId], callback);
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

    addToUser: (artistId, userId, callback) => {
        const query = `
            INSERT OR IGNORE INTO Artist_User (user_id, artist_id, rank_state)
            VALUES (?, ?, 'Por valorar')
        `;
        db.run(query, [userId, artistId], function(err) {
            if (err) {
                callback(err);
                return;
            }

            if (this.changes === 0) {
                callback(null, { message: 'Artist already associated with user' });
            } else {
                callback(null, { message: 'Artist added to user successfully' });
            }
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
    },

    removeFromUser: (userId, artistId, callback) => {
        db.serialize(() => {
            db.run('BEGIN TRANSACTION');
            
            // 1. Eliminar relación Artist_User
            db.run('DELETE FROM Artist_User WHERE user_id = ? AND artist_id = ?', [userId, artistId], function(err) {
                if (err) {
                    db.run('ROLLBACK');
                    callback(err);
                    return;
                }
                
                // 2. Obtener albums del artista que tiene el usuario
                db.all('SELECT album_id FROM Album_User au JOIN Album a ON au.album_id = a.id WHERE au.user_id = ? AND a.artist_id = ?', 
                    [userId, artistId], (err, albums) => {
                    if (err) {
                        db.run('ROLLBACK');
                        callback(err);
                        return;
                    }
                    
                    if (albums.length === 0) {
                        db.run('COMMIT');
                        callback(null, { message: 'Artist relationship removed' });
                        return;
                    }
                    
                    const albumIds = albums.map(album => album.album_id);
                    const placeholders = albumIds.map(() => '?').join(',');
                    
                    // 3. Eliminar canciones de esos albums
                    db.run(`DELETE FROM Song_User WHERE user_id = ? AND song_id IN (
                        SELECT s.id FROM Song s WHERE s.album_id IN (${placeholders})
                    )`, [userId, ...albumIds], (err) => {
                        if (err) {
                            db.run('ROLLBACK');
                            callback(err);
                            return;
                        }
                        
                        // 4. Eliminar albums del usuario
                        db.run(`DELETE FROM Album_User WHERE user_id = ? AND album_id IN (${placeholders})`, 
                            [userId, ...albumIds], (err) => {
                            if (err) {
                                db.run('ROLLBACK');
                                callback(err);
                                return;
                            }
                            
                            db.run('COMMIT');
                            callback(null, { 
                                message: 'Artist and all related albums and songs removed',
                                removedAlbums: albums.length
                            });
                        });
                    });
                });
            });
        });
    }
};

module.exports = Artist;