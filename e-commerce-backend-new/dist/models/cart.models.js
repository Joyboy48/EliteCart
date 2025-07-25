import mongoose, { Schema } from "mongoose";
const cartSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    items: [{
            productId: {
                type: Schema.Types.ObjectId,
                ref: "Product",
                required: true
            },
            quantity: {
                type: Number,
                required: true,
                min: 1
            },
            price: {
                type: Number,
                required: true
            }
        }]
}, { timestamps: true });
cartSchema.virtual('totalAmount').get(function () {
    return this.items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
});
const Cart = mongoose.model("Cart", cartSchema);
export default Cart;
