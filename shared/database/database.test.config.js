import { Sequelize } from 'sequelize';

// Database configuration for tests - using SQLite in memory
const testSequelize = new Sequelize({
    dialect: 'sqlite',
    storage: ':memory:', // In-memory database for tests
    logging: false, // Disable logging during tests
    pool: {
        max: 1,
        min: 0,
        acquire: 30000,
        idle: 10000
    }
});

export default testSequelize;
