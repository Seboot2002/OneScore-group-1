
const RecommendationModel = require('../models/recommendationModel');

const RecommendationController = {
  getRandomArtist: (req, res) => {
    const userId = req.params.userId;
    RecommendationModel.getRandomArtist(userId, (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      if (result.length === 0) return res.json({ message: "No podemos recomendarte nada" });
      res.json(result[0]);
    });
  },

  getRandomAlbums: (req, res) => {
    const userId = req.params.userId;
    RecommendationModel.getRandomAlbums(userId, (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      if (result.length === 0) return res.json({ message: "No podemos recomendarte nada" });
      res.json(result);
    });
  }
};

module.exports = RecommendationController;
