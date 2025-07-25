import mongoose, { Schema } from "mongoose";
const productSchema = new Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    description: {
        type: String,
        required: true,
        trim: true,
    },
    price: {
        type: Number,
        required: true,
    },
    discount: {
        type: Number,
        default: 0.0,
    },
    brandId: {
        type: Schema.Types.ObjectId,
        ref: "Brand",
        required: true,
    },
    images: [{
            type: String,
            required: true,
        }],
    categories: [{
            type: String,
            required: true,
        }],
    stock: {
        type: Number,
        required: true,
    },
    rating: {
        type: Number,
        default: 0.0,
    },
    reviews: [{
            type: Schema.Types.ObjectId,
            ref: "Review",
        }],
    colors: {
        type: [String],
        default: []
    },
    sizes: {
        type: [String],
        default: []
    },
}, { timestamps: true });
const Product = mongoose.model("Product", productSchema);
export default Product;
