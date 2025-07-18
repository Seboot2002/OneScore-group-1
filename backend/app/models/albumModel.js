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

    getSongsByAlbumId: (id, callback) => {
        const query = `
            SELECT id, title, n_track, album_id
            FROM Song
            WHERE album_id = ?
            ORDER BY n_track ASC
        `;
        db.all(query, [id], callback);
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
    },

    addToUser: (userId, albumId, callback) => {
    db.serialize(() => {
        db.run('BEGIN TRANSACTION');
        
        // 1. Obtener artist_id del album
        db.get('SELECT artist_id FROM Album WHERE id = ?', [albumId], (err, album) => {
            if (err) {
                db.run('ROLLBACK');
                callback(err);
                return;
            }
            if (!album) {
                db.run('ROLLBACK');
                callback(new Error('Album not found'));
                return;
            }
            
            // 2. Verificar si existe la relación Artist_User, si no existe la crea
            db.get('SELECT * FROM Artist_User WHERE user_id = ? AND artist_id = ?', 
                [userId, album.artist_id], (err, artistUser) => {
                if (err) {
                    db.run('ROLLBACK');
                    callback(err);
                    return;
                }
                
                const insertArtistUser = () => {
                    // 3. Agregar album al usuario
                    db.run('INSERT OR IGNORE INTO Album_User (user_id, album_id, rank_state) VALUES (?, ?, "Por valorar")', 
                        [userId, albumId], (err) => {
                        if (err) {
                            db.run('ROLLBACK');
                            callback(err);
                            return;
                        }
                        
                        // 4. Obtener todas las canciones del album
                        db.all('SELECT id FROM Song WHERE album_id = ?', [albumId], (err, songs) => {
                            if (err) {
                                db.run('ROLLBACK');
                                callback(err);
                                return;
                            }
                            
                            // 5. Agregar todas las canciones del album al usuario (sin score)
                            if (songs.length > 0) {
                                const insertSongPromises = songs.map(song => {
                                    return new Promise((resolve, reject) => {
                                        db.run('INSERT OR IGNORE INTO Song_User (user_id, song_id) VALUES (?, ?)',
                                            [userId, song.id], (err) => {
                                            if (err) reject(err);
                                            else resolve();
                                        });
                                    });
                                });
                                
                                Promise.all(insertSongPromises).then(() => {
                                    db.run('COMMIT');
                                    callback(null, { 
                                        message: 'Album and songs added to user profile',
                                        albumId: albumId,
                                        artistId: album.artist_id,
                                        songsAdded: songs.length
                                    });
                                }).catch(err => {
                                    db.run('ROLLBACK');
                                    callback(err);
                                });
                            } else {
                                db.run('COMMIT');
                                callback(null, { 
                                    message: 'Album added to user profile (no songs found)',
                                    albumId: albumId,
                                    artistId: album.artist_id,
                                    songsAdded: 0
                                });
                            }
                        });
                    });
                };
                
                // Si no existe la relación Artist_User, la creamos
                if (!artistUser) {
                    db.run('INSERT INTO Artist_User (user_id, artist_id, rank_state) VALUES (?, ?, "Por valorar")', 
                        [userId, album.artist_id], (err) => {
                        if (err) {
                            db.run('ROLLBACK');
                            callback(err);
                            return;
                        }
                        insertArtistUser();
                    });
                } else {
                    // Si ya existe, continuamos con el proceso
                    insertArtistUser();
                }
            });
        });
    });
    },

    removeFromUser: (userId, albumId, callback) => {
        db.serialize(() => {
            db.run('BEGIN TRANSACTION');

            // Paso 1: obtener el artista del álbum
            db.get('SELECT artist_id FROM Album WHERE id = ?', [albumId], (err, row) => {
                if (err || !row) {
                    db.run('ROLLBACK');
                    callback(err || new Error('Album not found'));
                    return;
                }

                const artistId = row.artist_id;

                // Paso 2: eliminar relación Album_User
                db.run('DELETE FROM Album_User WHERE user_id = ? AND album_id = ?', [userId, albumId], function(err) {
                    if (err) {
                        db.run('ROLLBACK');
                        callback(err);
                        return;
                    }

                    // Paso 3: eliminar canciones del usuario que son de ese álbum
                    db.run('DELETE FROM Song_User WHERE user_id = ? AND song_id IN (SELECT id FROM Song WHERE album_id = ?)', 
                        [userId, albumId], function(err) {
                        if (err) {
                            db.run('ROLLBACK');
                            callback(err);
                            return;
                        }

                        // Paso 4: verificar si quedan otros álbumes del mismo artista para el usuario
                        db.get(
                            `SELECT COUNT(*) as count FROM Album_User 
                            JOIN Album ON Album.id = Album_User.album_id 
                            WHERE Album_User.user_id = ? AND Album.artist_id = ?`,
                            [userId, artistId],
                            (err, countRow) => {
                                if (err) {
                                    db.run('ROLLBACK');
                                    callback(err);
                                    return;
                                }

                                const albumCount = countRow.count;

                                if (albumCount === 0) {
                                    // Paso 5: eliminar relación Artist_User si ya no tiene álbumes del artista
                                    db.run(
                                        'DELETE FROM Artist_User WHERE user_id = ? AND artist_id = ?',
                                        [userId, artistId],
                                        (err) => {
                                            if (err) {
                                                db.run('ROLLBACK');
                                                callback(err);
                                                return;
                                            }

                                            db.run('COMMIT');
                                            callback(null, {
                                                message: 'Album, songs, and artist (if no other albums) removed from user profile'
                                            });
                                        }
                                    );
                                } else {
                                    db.run('COMMIT');
                                    callback(null, {
                                        message: 'Album and songs removed from user profile (artist kept)'
                                    });
                                }
                            }
                        );
                    });
                });
            });
        });
    },

    rateAlbum: (albumId, userId, songRatings, callback) => {
        db.serialize(() => {
            db.run('BEGIN TRANSACTION');
            
            // 1. Obtener todas las canciones del album
            db.all('SELECT id FROM Song WHERE album_id = ? ORDER BY n_track', [albumId], (err, albumSongs) => {
                if (err) {
                    db.run('ROLLBACK');
                    callback(err);
                    return;
                }
                
                if (albumSongs.length === 0) {
                    db.run('ROLLBACK');
                    callback(new Error('Album not found or has no songs'));
                    return;
                }
                
                // 2. Verificar que todas las canciones estén siendo valoradas
                const albumSongIds = albumSongs.map(song => song.id);
                const ratedSongIds = songRatings.map(rating => rating.songId);
                
                const missingRatings = albumSongIds.filter(id => !ratedSongIds.includes(id));
                if (missingRatings.length > 0) {
                    db.run('ROLLBACK');
                    callback(new Error('No has valorado todas las canciones'));
                    return;
                }
                
                // 3. Verificar que todas las puntuaciones sean válidas
                const invalidRatings = songRatings.filter(rating => 
                    !rating.score || rating.score < 1 || rating.score > 100
                );
                if (invalidRatings.length > 0) {
                    db.run('ROLLBACK');
                    callback(new Error('Invalid score values. Scores must be between 1 and 100'));
                    return;
                }
                
                // 4. Calcular promedio
                const totalScore = songRatings.reduce((sum, rating) => sum + rating.score, 0);
                const averageScore = Math.round((totalScore / songRatings.length) * 100) / 100;
                
                // 5. Obtener fecha actual si es primera valoración
                db.get('SELECT rank_date FROM Album_User WHERE user_id = ? AND album_id = ?', 
                    [userId, albumId], (err, existingRating) => {
                    if (err) {
                        db.run('ROLLBACK');
                        callback(err);
                        return;
                    }
                    
                    const currentDate = existingRating && existingRating.rank_date ? 
                        existingRating.rank_date : new Date().toISOString().split('T')[0];
                    
                    // 6. Eliminar valoraciones previas de canciones
                    db.run('DELETE FROM Song_User WHERE user_id = ? AND song_id IN (' + 
                        albumSongIds.map(() => '?').join(',') + ')', 
                        [userId, ...albumSongIds], (err) => {
                        if (err) {
                            db.run('ROLLBACK');
                            callback(err);
                            return;
                        }
                        
                        // 7. Insertar nuevas valoraciones de canciones
                        const insertSongPromises = songRatings.map(rating => {
                            return new Promise((resolve, reject) => {
                                db.run('INSERT INTO Song_User (user_id, song_id, score) VALUES (?, ?, ?)',
                                    [userId, rating.songId, rating.score], (err) => {
                                    if (err) reject(err);
                                    else resolve();
                                });
                            });
                        });
                        
                        Promise.all(insertSongPromises).then(() => {
                            // 8. Actualizar Album_User
                            db.run(`UPDATE Album_User SET rank_date = ?, rank_state = 'Valorado' 
                                WHERE user_id = ? AND album_id = ?`, 
                                [currentDate, userId, albumId], (err) => {
                                if (err) {
                                    db.run('ROLLBACK');
                                    callback(err);
                                    return;
                                }
                                
                                // 9. Verificar si todos los albums del artista están valorados
                                db.get('SELECT artist_id FROM Album WHERE id = ?', [albumId], (err, album) => {
                                    if (err) {
                                        db.run('ROLLBACK');
                                        callback(err);
                                        return;
                                    }
                                    
                                    db.get(`SELECT COUNT(*) as total_albums,
                                        SUM(CASE WHEN au.rank_state = 'Valorado' THEN 1 ELSE 0 END) as rated_albums
                                        FROM Album_User au 
                                        JOIN Album a ON au.album_id = a.id
                                        WHERE au.user_id = ? AND a.artist_id = ?`,
                                        [userId, album.artist_id], (err, counts) => {
                                        
                                        if (err) {
                                            db.run('ROLLBACK');
                                            callback(err);
                                            return;
                                        }
                                        
                                        // 10. Actualizar Artist_User si todos los albums están valorados
                                        if (counts.total_albums === counts.rated_albums) {
                                            db.run(`UPDATE Artist_User SET rank_state = 'Valorado' 
                                                WHERE user_id = ? AND artist_id = ?`,
                                                [userId, album.artist_id], (err) => {
                                                if (err) {
                                                    db.run('ROLLBACK');
                                                    callback(err);
                                                    return;
                                                }
                                                
                                                db.run('COMMIT');
                                                callback(null, {
                                                    user_id: userId,
                                                    album_id: albumId,
                                                    rank_date: currentDate,
                                                    rank_state: 'Valorado',
                                                    average_score: averageScore,
                                                    artist_fully_rated: true
                                                });
                                            });
                                        } else {
                                            db.run('COMMIT');
                                            callback(null, {
                                                user_id: userId,
                                                album_id: albumId,
                                                rank_date: currentDate,
                                                rank_state: 'Valorado',
                                                average_score: averageScore,
                                                artist_fully_rated: false
                                            });
                                        }
                                    });
                                });
                            });
                        }).catch(err => {
                            db.run('ROLLBACK');
                            callback(err);
                        });
                    });
                });
            });
        });
    },

    recommendAlbumsToUser: (userId, callback) => {
        const query = `
            SELECT al.id, al.title, al.cover_url
            FROM Album al
            WHERE al.id NOT IN (
                SELECT album_id FROM Album_User WHERE user_id = ?
            )
            ORDER BY RANDOM()
            LIMIT 2
        `;
        db.all(query, [userId], (err, albums) => {
            if (err) {
                callback(err);
                return;
            }

            if (!albums || albums.length === 0) {
                // El usuario ya tiene todos los álbumes
                callback(null, null);
                return;
            }

            callback(null, albums);
        });
    },

    getUserAlbumsByState: (userId, callback) => {
        const query = `
            SELECT 
                a.id AS album_id,
                a.title,
                a.cover_url,
                a.release_year,
                au.rank_state
            FROM Album_User au
            JOIN Album a ON a.id = au.album_id
            WHERE au.user_id = ?
        `;

        db.all(query, [userId], (err, rows) => {
            if (err) return callback(err);

            const valued = [];
            const pending = [];

            rows.forEach(row => {
                const album = {
                    albumId: row.album_id,
                    title: row.title,
                    coverUrl: row.cover_url,
                    releaseYear: row.release_year,
                };

                if (row.rank_state === 'Valorado') {
                    valued.push(album);
                } else if (row.rank_state === 'Por valorar') {
                    pending.push(album);
                }
            });

            callback(null, { valued, pending });
        });
    },

    getUserAlbumRankState: (userId, albumId) => {
        return new Promise((resolve, reject) => {
            const query = `
                SELECT rank_state
                FROM Album_User
                WHERE user_id = ? AND album_id = ?
            `;
            db.get(query, [userId, albumId], (err, row) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(row); // puede ser undefined si no existe
                }
            });
        });
    },

    getUserAlbumRating: (userId, albumId, callback) => {
        const query = `
            SELECT us.score
            FROM Song s
            INNER JOIN Song_User us ON s.id = us.song_id
            WHERE s.album_id = ? AND us.user_id = ?
        `;
        db.all(query, [albumId, userId], (err, rows) => {
            if (err) return callback(err);

            if (rows.length === 0) return callback(null, { average: 0 });

            const sum = rows.reduce((acc, row) => acc + row.score, 0);
            const average = parseFloat((sum / rows.length).toFixed(2));
            callback(null, { average });
        });
    },

    getSongRatingsByUserAndAlbum: (userId, albumId, callback) => {
        const query = `
            SELECT s.id as song_id, s.title as song_title, su.score
            FROM Song s
            LEFT JOIN Song_User su ON s.id = su.song_id AND su.user_id = ?
            WHERE s.album_id = ?
        `;
        db.all(query, [userId, albumId], callback);
    },
};

module.exports = Album;