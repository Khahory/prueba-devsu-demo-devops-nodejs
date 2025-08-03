// Test environment setup
process.env.NODE_ENV = 'test';

// Mock environment variables for tests
process.env.DATABASE_NAME = 'test_db';
process.env.DATABASE_USER = 'test';
process.env.DATABASE_PASSWORD = 'test';
process.env.DATABASE_HOST = 'localhost';
process.env.DATABASE_PORT = '3306';
process.env.PORT = '8001';
process.env.LOG_LEVEL = 'silent';
process.env.JWT_SECRET = 'test_jwt_secret';
process.env.SESSION_SECRET = 'test_session_secret';
