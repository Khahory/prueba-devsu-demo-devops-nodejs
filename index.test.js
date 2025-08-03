import request from 'supertest';
import express from 'express';

// Mock the User model completely
const mockUser = {
    findAll: jest.fn(),
    findByPk: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn()
};

jest.mock('./users/model.js', () => mockUser);

// Mock validation middleware to pass through
jest.mock('./shared/middleware/validateSchema.js', () => ({
    validateSchema: () => (req, res, next) => next()
}));

// Mock database initialization
jest.mock('./shared/database/init.js', () => ({
    initializeDatabase: jest.fn().mockResolvedValue(true)
}));

describe('User API', () => {
    let app;
    let testData;

    beforeAll(async () => {
        // Create Express app
        app = express();
        app.use(express.json());

        // Import and setup router after mocking
        const { usersRouter } = await import('./users/router.js');
        app.use('/api/users', usersRouter);
    });

    beforeEach(() => {
        // Clear all mocks before each test
        jest.clearAllMocks();

        // Suppress console logs during tests
        jest.spyOn(console, 'log').mockImplementation(() => {});
        jest.spyOn(console, 'error').mockImplementation(() => {});

        testData = {
            id: 1,
            dni: '1234567890',
            name: 'Test User'
        };
    });

    afterEach(() => {
        // Restore console methods
        jest.restoreAllMocks();
    });

    describe('GET /api/users', () => {
        test('should return all users', async () => {
            mockUser.findAll.mockResolvedValue([testData]);

            const response = await request(app).get('/api/users');

            expect(response.status).toBe(200);
            expect(response.body).toEqual([testData]);
            expect(mockUser.findAll).toHaveBeenCalledWith();
        });

        test('should return empty array when no users exist', async () => {
            mockUser.findAll.mockResolvedValue([]);

            const response = await request(app).get('/api/users');

            expect(response.status).toBe(200);
            expect(response.body).toEqual([]);
        });

        test('should handle database errors', async () => {
            mockUser.findAll.mockRejectedValue(new Error('Database error'));

            const response = await request(app).get('/api/users');

            expect(response.status).toBe(500);
            expect(response.body).toEqual({ error: 'Internal Server Error' });
        });
    });

    describe('GET /api/users/:id', () => {
        test('should return user by id', async () => {
            mockUser.findByPk.mockResolvedValue(testData);

            const response = await request(app).get('/api/users/1');

            expect(response.status).toBe(200);
            expect(response.body).toEqual(testData);
            expect(mockUser.findByPk).toHaveBeenCalledWith('1');
        });

        test('should return 404 when user not found', async () => {
            mockUser.findByPk.mockResolvedValue(null);

            const response = await request(app).get('/api/users/999');

            expect(response.status).toBe(404);
            expect(response.body).toEqual({ error: 'User not found: 999' });
        });

        test('should handle database errors', async () => {
            mockUser.findByPk.mockRejectedValue(new Error('Database error'));

            const response = await request(app).get('/api/users/1');

            expect(response.status).toBe(500);
            expect(response.body).toEqual({ error: 'Internal Server Error' });
        });
    });

    describe('POST /api/users', () => {
        test('should create new user', async () => {
            const newUserData = { dni: '1234567890', name: 'Test User' };
            const createdUser = { ...newUserData, id: 1 };

            mockUser.findOne.mockResolvedValue(null); // User doesn't exist
            mockUser.create.mockResolvedValue(createdUser);

            const response = await request(app)
                .post('/api/users')
                .send(newUserData);

            expect(response.status).toBe(201);
            expect(response.body).toEqual(createdUser);
            expect(mockUser.findOne).toHaveBeenCalledWith({ where: { dni: newUserData.dni } });
            expect(mockUser.create).toHaveBeenCalledWith(newUserData);
        });

        test('should return 400 for duplicate DNI', async () => {
            const newUserData = { dni: '1234567890', name: 'Test User' };

            mockUser.findOne.mockResolvedValue(testData); // User already exists

            const response = await request(app)
                .post('/api/users')
                .send(newUserData);

            expect(response.status).toBe(400);
            expect(response.body).toEqual({ error: 'User already exists: 1234567890' });
            expect(mockUser.create).not.toHaveBeenCalled();
        });

        test('should handle database errors during creation', async () => {
            const newUserData = { dni: '1234567890', name: 'Test User' };

            mockUser.findOne.mockResolvedValue(null);
            mockUser.create.mockRejectedValue(new Error('Database error'));

            const response = await request(app)
                .post('/api/users')
                .send(newUserData);

            expect(response.status).toBe(500);
            expect(response.body).toEqual({ error: 'Internal Server Error' });
        });

        test('should handle database errors during duplicate check', async () => {
            const newUserData = { dni: '1234567890', name: 'Test User' };

            mockUser.findOne.mockRejectedValue(new Error('Database error'));

            const response = await request(app)
                .post('/api/users')
                .send(newUserData);

            expect(response.status).toBe(500);
            expect(response.body).toEqual({ error: 'Internal Server Error' });
        });
    });
});
