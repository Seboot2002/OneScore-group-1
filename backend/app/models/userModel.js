const db = require('../../config/database');

const User = {
    // Servicio Básico: Obtener todos los usuarios
    getAll: (callback) => {
        const query = `
        SELECT user_id, name, last_name, nickname, mail, password, photo_url 
        FROM User
        `;
        db.all(query, callback);
    },

    // Servicio Básico: Obtener un usuario por ID
    getById: (id, callback) => {
        const query = `
        SELECT user_id, name, last_name, nickname, mail, password, photo_url 
        FROM User 
        WHERE user_id = ?
        `;
        db.get(query, [id], callback);
    },

    getBasicInfoById: (id, callback) => {
        const query = `
        SELECT photo_url, nickname, (name || ' ' || last_name) AS full_name
        FROM User
        WHERE user_id = ?
        `;
        db.get(query, [id], callback);
    },

    getUserStats: (id, callback) => {
        const query = `
        SELECT 
            (SELECT COUNT(*) FROM Album_User WHERE user_id = ?) AS album_count,
            (SELECT COUNT(*) FROM Artist_User WHERE user_id = ?) AS artist_count,
            (SELECT COUNT(*) FROM Song_User WHERE user_id = ?) AS song_count
        `;
        db.get(query, [id, id, id], callback);
    },

    getAlbumsByUserId: (id, callback) => {
        const query = `
            SELECT 
                a.id AS album_id,
                a.title AS album_title,
                a.cover_url,
                a.release_year,
                au.rank_state,
                ar.id AS artist_id,
                ar.name AS artist_name,
                ar.picture_url AS artist_picture_url
            FROM Album_User au
            JOIN Album a ON a.id = au.album_id
            JOIN Artist ar ON ar.id = a.artist_id
            WHERE au.user_id = ?
        `;
        db.all(query, [id], callback);
    },

    getArtistsByUserId: (id, callback) => {
        const query = `
            SELECT 
                ar.id AS artist_id,
                ar.name AS artist_name,
                ar.picture_url,
                ar.genre_id,
                ar.debut_year,
                au.rank_state
            FROM Artist_User au
            JOIN Artist ar ON ar.id = au.artist_id
            WHERE au.user_id = ?
        `;
        db.all(query, [id], callback);
    },

    getSongsByUserId: (userId, callback) => {
        const query = `
            SELECT 
                s.id AS song_id,
                s.title,
                s.n_track,
                s.album_id,
                su.score
            FROM Song_User su
            JOIN Song s ON s.id = su.song_id
            WHERE su.user_id = ?
        `;
        db.all(query, [userId], callback);
    },

    existsByEmailOrNickname: (mail, nickname, callback) => {
        const query = `
            SELECT 1 FROM User 
            WHERE mail = ? OR nickname = ?
            LIMIT 1
        `;
        db.get(query, [mail, nickname], (err, row) => {
            if (err) return callback(err);
            callback(null, !!row);
        });
    },

    create: (userData, callback) => {
        const query = `
        INSERT INTO User (name, last_name, nickname, mail, password, photo_url)
        VALUES (?, ?, ?, ?, ?, ?)
        `;
        const { name, last_name, nickname, mail, password, photo_url } = userData;
        db.run(query, [name, last_name, nickname, mail, password, photo_url], callback);
    },

    // Actualizar un usuario existente
    update: (id, userData, callback) => {
        const query = `
        UPDATE User 
        SET name = ?, last_name = ?, nickname = ?, mail = ?, photo_url = ?
        WHERE user_id = ?
        `;
        const { name, last_name, nickname, mail, photo_url } = userData;
        db.run(query, [name, last_name, nickname, mail, photo_url, id], callback);
    },

    // Servicio Básico: Eliminar un usuario por ID
    delete: (id, callback) => {
        const query = `DELETE FROM User WHERE user_id = ?`;
        db.run(query, [id], callback);
    },

    login: (login, password, callback) => {
        const query = `
        SELECT user_id, name, last_name, nickname, mail, photo_url 
        FROM User 
        WHERE (mail = ? OR nickname = ?) AND password = ?
        `;
        db.get(query, [login, login, password], callback);
    },

    searchByKeyword: (keyword, callback) => {
        const query = `
        SELECT user_id, photo_url, (name || ' ' || last_name) as full_name
        FROM User 
        WHERE name LIKE ? OR nickname LIKE ?
        `;
        const searchTerm = `%${keyword}%`;
        db.all(query, [searchTerm, searchTerm], callback);
    },

    registerNewUser: (userData, callback) =>{
        const query = `
        INSERT INTO User (name, last_name, nickname, mail, password)
        VALUES (?, ?, ?, ?, ?)
        `;
        const { name, last_name, nickname, mail, password, } = userData;
        db.run(query, [name, last_name, nickname, mail, password], callback);
    },

    updateUserProfile: (id, userData, callback) => {
        const fields = [];
        const values = [];

        for (const key of ['name', 'last_name', 'mail', 'photo_url']) {
            if (userData[key] !== undefined) {
                fields.push(`${key} = ?`);
                values.push(userData[key]);
            }
        }

        if (fields.length === 0) {
            return callback(new Error("No fields to update"));
        }

        const query = `UPDATE User SET ${fields.join(', ')} WHERE user_id = ?`;
        values.push(id);

        db.run(query, values, callback);
    },
    
    updateUserPassword: (id, password, callback) => {
        const query = `UPDATE User SET password = ? WHERE user_id = ?`;
        db.run(query, [password, id], callback);
    }
};

module.exports = User;
