import mongoose, { Schema } from 'mongoose';
const wishlistItemSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    productId: {
        type: Schema.Types.ObjectId,
        ref: "Product",
        required: true,
    },
}, { timestamps: true });
const WishlistItem = mongoose.model("WishlistItem", wishlistItemSchema);
export default WishlistItem;
