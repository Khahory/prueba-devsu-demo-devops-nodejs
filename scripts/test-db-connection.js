import * as dotenv from 'dotenv';
import sequelize from '../shared/database/database.js';
import User from '../users/model.js';

// Load environment variables
dotenv.config();

async function testDatabaseConnection() {
    try {
        console.log('🔍 Testing database connection...');
        console.log('📊 Database configuration:');
        console.log(`   Host: ${process.env.DATABASE_HOST || 'localhost'}`);
        console.log(`   Port: ${process.env.DATABASE_PORT || 3306}`);
        console.log(`   Database: ${process.env.DATABASE_NAME}`);
        console.log(`   User: ${process.env.DATABASE_USER}`);
        console.log('');

        // Test connection
        await sequelize.authenticate();
        console.log('✅ Database connection successful!');
        console.log('');

        // Get all users
        console.log('📋 Retrieving users from database...');
        const users = await User.findAll();
        
        if (users.length === 0) {
            console.log('ℹ️  No users found in the database.');
            console.log('💡 You can add users through the API endpoints.');
        } else {
            console.log(`✅ Found ${users.length} user(s):`);
            console.log('');
            
            users.forEach((user, index) => {
                console.log(`   User ${index + 1}:`);
                console.log(`     ID: ${user.id}`);
                console.log(`     Name: ${user.name}`);
                console.log(`     DNI: ${user.dni}`);
                console.log('');
            });
        }

        // Test database sync (optional)
        console.log('🔄 Testing database sync...');
        await sequelize.sync({ force: false });
        console.log('✅ Database sync successful!');

    } catch (error) {
        console.error('❌ Database connection failed:');
        console.error('   Error:', error.message);
        console.error('');
        console.error('🔧 Troubleshooting tips:');
        console.error('   1. Check if the database server is running');
        console.error('   2. Verify your .env file has correct database credentials');
        console.error('   3. Ensure the database exists');
        console.error('   4. Check if the user has proper permissions');
        console.error('');
        console.error('📝 Example .env configuration:');
        console.error('   DATABASE_HOST=localhost');
        console.error('   DATABASE_PORT=3306');
        console.error('   DATABASE_NAME=devsu_demo');
        console.error('   DATABASE_USER=admin');
        console.error('   DATABASE_PASSWORD=admin');
    } finally {
        // Close the connection
        await sequelize.close();
        console.log('🔌 Database connection closed.');
    }
}

// Run the test
testDatabaseConnection(); 