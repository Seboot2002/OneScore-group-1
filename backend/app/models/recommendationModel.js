const db = require('../../config/database');

const RecommendationModel = {
  getRandomArtist: (userId, callback) => {
    const sql = `
      SELECT id, picture_url, name FROM Artist
      WHERE id NOT IN (
        SELECT artist_id FROM Artist_User WHERE user_id = ?
      )
      ORDER BY RANDOM()
      LIMIT 1
    `;
    db.all(sql, [userId], (err, rows) => callback(err, rows));
  },

  getRandomAlbums: (userId, callback) => {
    const sql = `
      SELECT id, cover_url, title FROM Album
      WHERE id NOT IN (
        SELECT album_id FROM Album_User WHERE user_id = ?
      )
      ORDER BY RANDOM()
      LIMIT 2
    `;
    db.all(sql, [userId], (err, rows) => callback(err, rows));
  }
};

module.exports = RecommendationModel;
