#!/usr/bin/env node

/**
 * Database Initialization Script
 * This script can be run independently to initialize the database
 * and create all necessary tables
 */

import * as dotenv from 'dotenv';
import { initializeDatabase, checkDatabaseConnection, forceSyncDatabase } from '../shared/database/init.js';

// Load environment variables
dotenv.config();

const NODE_ENV = process.env.NODE_ENV || 'development';
const logPrefix = `[${NODE_ENV.toUpperCase()}]`;

async function main() {
    try {
        console.log(`${logPrefix} 🗄️  Database Initialization Script`);
        console.log(`${logPrefix} Environment: ${NODE_ENV}`);
        console.log(`${logPrefix} Database: ${process.env.DATABASE_NAME}`);
        console.log(`${logPrefix} Host: ${process.env.DATABASE_HOST}:${process.env.DATABASE_PORT}`);
        console.log('');

        // Check if force sync is requested
        const forceSync = process.argv.includes('--force') || process.env.FORCE_SYNC === 'true';

        if (forceSync) {
            console.log(`${logPrefix} ⚠️  Force sync mode enabled`);
            await forceSyncDatabase();
        } else {
            // Check database connection
            await checkDatabaseConnection();

            // Initialize database tables
            await initializeDatabase();
        }

        console.log('');
        console.log(`${logPrefix} ✅ Database initialization completed successfully!`);
        console.log(`${logPrefix} 📊 Users table is ready for use`);

        // eslint-disable-next-line no-process-exit
        process.exit(0);
    } catch (error) {
        console.error(`${logPrefix} ❌ Database initialization failed:`, error);
    }
}

// Run the script
main();
