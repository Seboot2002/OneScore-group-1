const Album = require('../models/albumModel');

const albumController = {
    getAllAlbums: (req, res) => {
        Album.getAll((err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json(rows);
        });
    },

    getAlbumById: (req, res) => {
        const { id } = req.params;
        Album.getById(id, (err, row) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (!row) {
                res.status(404).json({ error: 'Album not found' });
                return;
            }
            res.json(row);
        });
    },

    getSongsByAlbumId: (req, res) => {
        const { id } = req.params;
        Album.getSongsByAlbumId(id, (err, songs) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (!songs) {
                res.status(404).json({ error: 'AlbumData not found' });
                return;
            }
            res.json(songs);
        });
    },

    createAlbum: (req, res) => {
        const { title, release_year, genre_id, cover_url, artist_id } = req.body;
        
        // Validación básica
        if (!title || !release_year || !genre_id || !artist_id) {
            res.status(400).json({ 
                error: 'Missing required fields: title, release_year, genre_id, artist_id' 
            });
            return;
        }

        const albumData = { title, release_year, genre_id, cover_url, artist_id };
        
        Album.create(albumData, (err, album) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.status(201).json({ 
                message: 'Album created successfully',
                album: album 
            });
        });
    },

    updateAlbum: (req, res) => {
        const { id } = req.params;
        const { title, release_year, genre_id, cover_url, artist_id } = req.body;
        
        // Validación básica
        if (!title || !release_year || !genre_id || !artist_id) {
            res.status(400).json({ 
                error: 'Missing required fields: title, release_year, genre_id, artist_id' 
            });
            return;
        }

        const albumData = { title, release_year, genre_id, cover_url, artist_id };
        
        Album.update(id, albumData, (err, album) => {
            if (err) {
                if (err.message === 'Album not found') {
                    res.status(404).json({ error: 'Album not found' });
                } else {
                    res.status(500).json({ error: err.message });
                }
                return;
            }
            res.json({ 
                message: 'Album updated successfully',
                album: album 
            });
        });
    },

    deleteAlbum: (req, res) => {
        const { id } = req.params;
        
        Album.delete(id, (err, result) => {
            if (err) {
                if (err.message === 'Album not found') {
                    res.status(404).json({ error: 'Album not found' });
                } else {
                    res.status(500).json({ error: err.message });
                }
                return;
            }
            res.json(result);
        });
    },

    getAlbumsByArtist: (req, res) => {
        const { artistId } = req.params;
        Album.getByArtistId(artistId, (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json(rows);
        });
    },

    getAlbumsByGenre: (req, res) => {
        const { genreId } = req.params;
        Album.getByGenreId(genreId, (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json(rows);
        });
    },

    searchAlbums: (req, res) => {
        const { keyword } = req.params;
        
        if (!keyword) {
            res.status(400).json({ error: 'Keyword is required' });
            return;
        }

        Album.searchByKeyword(keyword, (err, albums) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json(albums);
        });
    },

    addAlbumToUser: (req, res) => {
        const { userId, albumId } = req.params;
        
        if (!userId || !albumId) {
            res.status(400).json({ error: 'User ID and Album ID are required' });
            return;
        }

        Album.addToUser(userId, albumId, (err, result) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({
                message: 'Album added to user profile successfully',
                result: result
            });
        });
    },

    removeAlbumFromUser: (req, res) => {
        const { userId, albumId } = req.params;
        
        if (!userId || !albumId) {
            res.status(400).json({ error: 'User ID and Album ID are required' });
            return;
        }

        Album.removeFromUser(userId, albumId, (err, result) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({
                message: 'Album removed from user profile successfully',
                result: result
            });
        });
    },

    rateAlbum: (req, res) => {
        const { albumId, userId, songRatings } = req.body;
        
        if (!albumId || !userId || !songRatings || !Array.isArray(songRatings)) {
            res.status(400).json({ 
                error: 'Missing required fields: albumId, userId, and songRatings array are required' 
            });
            return;
        }

        Album.rateAlbum(albumId, userId, songRatings, (err, result) => {
            if (err) {
                res.status(400).json({ error: err.message });
                return;
            }
            res.json({
                message: 'Album rated successfully',
                result: result
            });
        });
    },

    recommendAlbumsToUser: (req, res) => {
        const { userId } = req.params;

        if (!userId) {
            return res.status(400).json({ error: "User ID is required" });
        }

        Album.recommendAlbumsToUser(userId, (err, albums) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }

            if (!albums || albums.length === 0) {
                return res.json({ message: "No podemos recomendarte nada" });
            }

            // Solo devolvemos id, title y cover_url
            res.json(albums.map(album => ({
                id: album.id,
                title: album.title,
                cover_url: album.cover_url
            })));
        });
    }
};

module.exports = albumController;