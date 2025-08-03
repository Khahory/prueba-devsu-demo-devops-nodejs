#!/usr/bin/env node

import mysql from 'mysql2/promise';
import * as dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const {
    DATABASE_HOST = 'mariadb-dev',
    DATABASE_PORT = 3306,
    DATABASE_USER,
    DATABASE_PASSWORD,
    DATABASE_NAME
} = process.env;

async function waitForDatabase() {
    const maxRetries = 30;
    const retryDelay = 2000;

    console.log('🔄 Waiting for database to be ready...');
    console.log(`📍 Database host: ${DATABASE_HOST}:${DATABASE_PORT}`);

    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            console.log(`🔄 Attempt ${attempt}/${maxRetries}: Connecting to database...`);
            
            const connection = await mysql.createConnection({
                host: DATABASE_HOST,
                port: DATABASE_PORT,
                user: DATABASE_USER,
                password: DATABASE_PASSWORD,
                database: DATABASE_NAME,
                connectTimeout: 10000
            });

            await connection.ping();
            await connection.end();
            
            console.log('✅ Database is ready!');
            return true;
        } catch (error) {
            console.log(`❌ Attempt ${attempt} failed: ${error.message}`);
            
            if (attempt === maxRetries) {
                console.error('❌ Max retries reached. Database is not ready.');
                process.exit(1);
            }
            
            console.log(`⏳ Waiting ${retryDelay}ms before next attempt...`);
            await new Promise(resolve => setTimeout(resolve, retryDelay));
        }
    }
}

// Run the wait function
waitForDatabase().catch(error => {
    console.error('❌ Error waiting for database:', error);
    process.exit(1);
}); 