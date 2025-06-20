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
};

module.exports = User;
