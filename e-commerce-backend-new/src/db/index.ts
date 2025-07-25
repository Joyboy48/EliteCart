import mongoose from "mongoose";
import { DB_NAME } from "../constants.js";

const connectDB = async (): Promise<void> => {
    try {
        const connectionInstance = await mongoose.connect(
            `${process.env.MONGODB_URL}/${DB_NAME}`
        );
        console.log(`\n MongoDB connected !! DB host: ${connectionInstance.connection.host}`);
    } catch (error) {
        console.log("MONGODB connection Failed", error);
        process.exit(1);
    }
};

export default connectDB; 