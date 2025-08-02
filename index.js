import sequelize from './shared/database/database.js';
import { usersRouter } from './users/router.js';
import express from 'express';
import * as dotenv from 'dotenv';

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
const syncOptions = shouldForceSync ? { force: true } : { alter: true };

console.log(`${logPrefix} Initializing database...`);
console.log(`${logPrefix} FORCE_SYNC: ${shouldForceSync}`);

sequelize.sync(syncOptions)
    .then(() => {
        console.log(`${logPrefix} Database is ready`);
        if (shouldForceSync) {
            console.log(`${logPrefix} ⚠️  Database tables were recreated (FORCE_SYNC=true)`);
        } else {
            console.log(`${logPrefix} 📊 Database tables synchronized (FORCE_SYNC=false)`);
        }
    })
    .catch(err => console.error(`${logPrefix} Database connection error:`, err));

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

const server = app.listen(PORT, () => {
    console.log(`${logPrefix} 🚀 Server running on port ${PORT}`);
    console.log(`${logPrefix} 📍 Health check: http://localhost:${PORT}/health`);
    console.log(`${logPrefix} 📍 API endpoints: http://localhost:${PORT}/api/users`);
});

export { app, server };
