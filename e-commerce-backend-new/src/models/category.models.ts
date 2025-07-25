import mongoose, { Document, Schema } from "mongoose";

export interface ICategory extends Document {
    name: string;
    icon: string;
    products: mongoose.Types.ObjectId[];
}

const categorySchema = new Schema<ICategory>({
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

const Category = mongoose.model<ICategory>("Category", categorySchema);
export default Category; 