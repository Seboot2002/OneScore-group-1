const app = require('./app');
const db = require('./config/database');

const PORT = process.env.PORT || 3000;

// Test database connection
db.get("SELECT 1", (err) => {
    if (err) {
        console.error('Database connection failed:', err.message);
        process.exit(1);
    } else {
        console.log('Connected to SQLite database');
    }
});

// Start server
const server = app.listen(PORT, () => {
    console.log(`Server running on http://0.0.0.0:${PORT}`);
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\nShutting down server...');
    server.close(() => {
        db.close((err) => {
            if (err) {
                console.error(err.message);
            } else {
                console.log('Database connection closed');
            }
            process.exit(0);
        });
    });
});