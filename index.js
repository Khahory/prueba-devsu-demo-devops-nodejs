import sequelize from './shared/database/database.js';
import { usersRouter } from './users/router.js';
import express from 'express';
import * as dotenv from 'dotenv';
import User from './users/model.js';
import { initializeDatabase, checkDatabaseConnection, retryDatabaseConnection } from './shared/database/init.js';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 8000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// Environment-specific logging
const logPrefix = `[${NODE_ENV.toUpperCase()}]`;
console.log(`${logPrefix} Starting application...`);
console.log(`${logPrefix} Environment: ${NODE_ENV}`);
console.log(`${logPrefix} Port: ${PORT}`);

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// Database initialization
const shouldForceSync = process.env.FORCE_SYNC === 'true';

console.log(`${logPrefix} Initializing database...`);
console.log(`${logPrefix} FORCE_SYNC: ${shouldForceSync}`);

// Initialize database with proper error handling
async function initializeApp() {
    try {
        // Retry database connection with exponential backoff
        await retryDatabaseConnection();

        // Initialize database tables
        if (shouldForceSync) {
            console.log(`${logPrefix} ⚠️  Force recreating all tables (FORCE_SYNC=true)`);
            await sequelize.sync({ force: true });
            console.log(`${logPrefix} ✅ Database tables recreated successfully`);
        } else {
            console.log(`${logPrefix} 📊 Initializing database tables...`);
            await initializeDatabase();
        }

        console.log(`${logPrefix} Database is ready`);

        // Start the server
        const server = app.listen(PORT, () => {
            console.log(`${logPrefix} 🚀 Server running on port ${PORT}`);
            console.log(`${logPrefix} 📍 Health check: http://localhost:${PORT}/health`);
            console.log(`${logPrefix} 📍 API endpoints: http://localhost:${PORT}/api/users`);
        });

        return { app, server };
    } catch (error) {
        console.error(`${logPrefix} ❌ Failed to initialize application:`, error);
        process.exit(1);
    }
}

// Start the application
initializeApp();

app.use(express.json());

// API routes
app.use('/api/users', usersRouter);

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(`${logPrefix} Error:`, err.stack);
    res.status(500).json({ error: 'Something went wrong!' });
});

// 404 handler
app.use('*', (req, res) => {
    console.log(`${logPrefix} 404 - Route not found: ${req.originalUrl}`);
    res.status(404).json({ error: 'Route not found' });
});

export { app };
