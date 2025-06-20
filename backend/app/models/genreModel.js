const db = require('../../config/database');

const Genre = {
    // Servicio Básico: Obtener todos los géneros
    getAll: (callback) => {
        const query = `SELECT * FROM Genre`;
        db.all(query, callback);
    },

    // Servcicio Básico: Obtener un género por ID
    getById: (id, callback) => {
        const query = `SELECT * FROM Genre WHERE id = ?`;
        db.get(query, [id], callback);
    },

    // Servicio Básico: Crear un nuevo género
    create: (genreData, callback) => {
        const query = `
        INSERT INTO Genre (name)
        VALUES (?)
        `;
        const { name } = genreData;
        db.run(query, [name], callback);
    },

    // Servicio Básico: Actualizar un género existente
    update: (id, genreData, callback) => {
        const query = `
        UPDATE Genre 
        SET name = ?
        WHERE id = ?
        `;
        const { name } = genreData;
        db.run(query, [name, id], callback);
    },

    // Servicio Básico: Eliminar un género
    delete: (id, callback) => {
        const query = `DELETE FROM Genre WHERE id = ?`;
        db.run(query, [id], callback);
    },
};

module.exports = Genre;