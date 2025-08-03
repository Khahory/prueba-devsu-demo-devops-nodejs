import sequelize from './database.js';
import User from '../../users/model.js';

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
