const db = require('../../config/database');

const User = {
    // Obtener todos los usuarios (sin contraseña por seguridad)
    getAll: (callback) => {
        const query = `
        SELECT user_id, name, last_name, nickname, mail 
        FROM User
        `;
        db.all(query, callback);
    },

    // Obtener un usuario por ID (sin contraseña por seguridad)
    getById: (id, callback) => {
        const query = `
        SELECT user_id, name, last_name, nickname, mail 
        FROM User 
        WHERE user_id = ?
        `;
        db.get(query, [id], callback);
    },

    // Crear un nuevo usuario
    create: (userData, callback) => {
        const query = `
        INSERT INTO User (name, last_name, nickname, mail, password)
        VALUES (?, ?, ?, ?, ?)
        `;
        const { name, last_name, nickname, mail, password } = userData;
        db.run(query, [name, last_name, nickname, mail, password], callback);
    },

    // Actualizar un usuario existente
    update: (id, userData, callback) => {
        const query = `
        UPDATE User 
        SET name = ?, last_name = ?, nickname = ?, mail = ?
        WHERE user_id = ?
        `;
        const { name, last_name, nickname, mail } = userData;
        db.run(query, [name, last_name, nickname, mail, id], callback);
    },

    // Eliminar un usuario
    delete: (id, callback) => {
        const query = `DELETE FROM User WHERE user_id = ?`;
        db.run(query, [id], callback);
    },

    // Buscar usuario por email (para login)
    getByEmail: (email, callback) => {
        const query = `
        SELECT * FROM User 
        WHERE mail = ?
        `;
        db.get(query, [email], callback);
    },

    // Buscar usuario por nickname
    getByNickname: (nickname, callback) => {
        const query = `
        SELECT user_id, name, last_name, nickname, mail 
        FROM User 
        WHERE nickname = ?
        `;
        db.get(query, [nickname], callback);
    },

    // Actualizar contraseña
    updatePassword: (id, hashedPassword, callback) => {
        const query = `
        UPDATE User 
        SET password = ?
        WHERE user_id = ?
        `;
        db.run(query, [hashedPassword, id], callback);
    }
};

module.exports = User;