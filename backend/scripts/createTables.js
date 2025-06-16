const fs = require('fs');
const path = require('path');
const database = require('../config/database');

async function createTables() {
    try {
        console.log('🔌 Connecting to database...');
        await database.connect();

        console.log('📄 Reading schema file...');
        const schemaPath = path.join(__dirname, '..', 'db', 'schema.sql');
        const schema = fs.readFileSync(schemaPath, 'utf8');

        // Split by semicolon and filter empty statements
        const statements = schema.split(';').filter(statement => statement.trim().length > 0);

        console.log('🏗️  Creating tables...');
        for (const statement of statements) {
            await database.run(statement.trim());
            console.log('✅ Executed:', statement.trim().split('\n')[0]);
        }

        console.log('🎉 All tables created successfully!');
        
    } catch (error) {
        console.error('❌ Error creating tables:', error.message);
    } finally {
        await database.close();
    }
}

createTables();