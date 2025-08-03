export default {
    testEnvironment: 'node',
    setupFilesAfterEnv: ['<rootDir>/test-setup.js'],
    collectCoverageFrom: [
        '**/*.js',
        '!**/node_modules/**',
        '!**/coverage/**',
        '!**/*.test.js',
        '!**/jest.config.js',
        '!**/index.test.js',
        '!**/test-setup.js',
        '!**/shared/database/*.test.js',
        '!**/shared/database/*.test.config.js'
    ],
    coverageThreshold: {
        global: {
            branches: 17,
            functions: 15,
            lines: 20,
            statements: 20
        }
    },
    coverageReporters: ['text', 'lcov', 'html'],
    testMatch: [
        '**/__tests__/**/*.js',
        '**/?(*.)+(spec|test).js'
    ],
    transform: {
        '^.+\\.js$': 'babel-jest'
    }
};
