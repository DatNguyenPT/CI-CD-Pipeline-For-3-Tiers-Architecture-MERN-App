const mongoose = require("mongoose");

module.exports = async () => {
    try {
        const connectionParams = {};
        
        // Check if authentication is required
        const useDBAuth = process.env.USE_DB_AUTH === 'true';
        if (useDBAuth) {
            connectionParams.auth = {
                username: process.env.MONGO_USERNAME,
                password: process.env.MONGO_PASSWORD
            };
        }
        
        await mongoose.connect(process.env.MONGO_CONN_STR, connectionParams);
        console.log("Connected to database successfully.");
        return mongoose.connection; // Return the connection for further use if needed
    } catch (error) {
        console.error("Could not connect to database:", error);
        throw error; // Re-throw the error so calling code can handle it
    }
};