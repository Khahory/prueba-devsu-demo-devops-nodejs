import User from './model.js';

const logPrefix = `[${process.env.NODE_ENV?.toUpperCase() || 'DEV'}]`;

export const listUsers = async (req, res) => {
    try {
        console.log(`${logPrefix} 📋 GET /api/users - Listing all users`);
        const users = await User.findAll();
        console.log(`${logPrefix} ✅ Found ${users.length} users`);

        res.status(200).json(users);
    } catch (error) {
        console.error(`${logPrefix} ❌ listUsers() -> Error:`, error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

export const getUser = async (req, res) => {
    try {
        const { id } = req.params;
        console.log(`${logPrefix} 👤 GET /api/users/${id} - Getting user by ID`);

        const user = await User.findByPk(id);

        if (user == null) {
            console.log(`${logPrefix} ❌ User not found: ${id}`);
            return res.status(404).json({ error: `User not found: ${id}` });
        }

        console.log(`${logPrefix} ✅ User found: ${user.name} (ID: ${id})`);
        return res.status(200).json(user);
    } catch (error) {
        console.error(`${logPrefix} ❌ getUser() -> Error:`, error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

export const createUser = async (req, res) => {
    try {
        const userRequest = req.body;
        console.log(`${logPrefix} ➕ POST /api/users - Creating new user: ${userRequest.name} (DNI: ${userRequest.dni})`);

        const userExist = await User.findOne({ where: { dni: userRequest.dni } });

        if (userExist != null) {
            console.log(`${logPrefix} ❌ User already exists: ${userRequest.dni}`);
            return res.status(400).json({ error: `User already exists: ${userRequest.dni}` });
        }

        const user = await User.create(userRequest);
        console.log(`${logPrefix} ✅ User created successfully: ${user.name} (ID: ${user.id})`);

        return res.status(201).json(user);
    } catch (error) {
        console.error(`${logPrefix} ❌ createUser() -> Error:`, error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
