import mongoose, { Schema } from "mongoose";
const brandSchema = new Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    logo: {
        type: String,
        required: true,
    },
    productCount: {
        type: Number,
        required: true,
        default: 0,
    },
    topProducts: [{
            type: Schema.Types.ObjectId,
            ref: "Product",
        }],
}, { timestamps: true });
const Brand = mongoose.model("Brand", brandSchema);
export default Brand;
