import mongoose, { Schema } from "mongoose";
const categorySchema = new Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    icon: {
        type: String,
        required: true,
    },
    products: [{
            type: Schema.Types.ObjectId,
            ref: "Product",
        }],
}, { timestamps: true });
const Category = mongoose.model("Category", categorySchema);
export default Category;
