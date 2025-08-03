import sequelize from './database.js';
import User from '../../users/model.js';

/**
 * Wait for a specified amount of time
 * @param {number} ms - milliseconds to wait
 * @returns {Promise}
 */
function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Retry database connection with exponential backoff
 * @param {number} maxRetries - maximum number of retries
 * @param {number} baseDelay - base delay in milliseconds
 * @returns {Promise<boolean>}
 */
export async function retryDatabaseConnection(maxRetries = 10, baseDelay = 1000) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            console.log(`🔄 Attempting database connection (attempt ${attempt}/${maxRetries})...`);
            await sequelize.authenticate();
            console.log('✅ Database connection established successfully');
            return true;
        } catch (error) {
            console.log(`❌ Connection attempt ${attempt} failed: ${error.message}`);
            
            if (attempt === maxRetries) {
                console.error('❌ Max retries reached. Unable to connect to database.');
                throw error;
            }
            
            const delay = baseDelay * Math.pow(2, attempt - 1);
            console.log(`⏳ Waiting ${delay}ms before next attempt...`);
            await wait(delay);
        }
    }
}

/**
 * Initialize database tables
 * This function will create all necessary tables if they don't exist
 */
export async function initializeDatabase() {
    try {
        console.log('🔄 Initializing database tables...');

        // Import all models to ensure they are registered with Sequelize
        // This ensures that all tables are created during sync

        // Sync all models with the database
        await sequelize.sync({ alter: true });

        console.log('✅ Database tables initialized successfully');
        console.log('📊 Available tables:');

        // List all tables in the database
        const tables = await sequelize.showAllSchemas();
        console.log('   - users (User model)');

        return true;
    } catch (error) {
        console.error('❌ Error initializing database:', error);
        throw error;
    }
}

/**
 * Force recreate all tables (use with caution in production)
 */
export async function forceSyncDatabase() {
    try {
        console.log('⚠️  Force recreating all database tables...');

        await sequelize.sync({ force: true });

        console.log('✅ Database tables recreated successfully');
        return true;
    } catch (error) {
        console.error('❌ Error force syncing database:', error);
        throw error;
    }
}

/**
 * Check database connection
 */
export async function checkDatabaseConnection() {
    try {
        await sequelize.authenticate();
        console.log('✅ Database connection established successfully');
        return true;
    } catch (error) {
        console.error('❌ Unable to connect to the database:', error);
        throw error;
    }
}
