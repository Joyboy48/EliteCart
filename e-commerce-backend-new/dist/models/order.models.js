import mongoose, { Schema } from "mongoose";
const orderSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    items: [{
            type: Schema.Types.ObjectId,
            ref: "Product",
        }],
    orderDate: {
        type: Date,
        required: true,
        default: Date.now,
    },
    shippingDate: {
        type: Date,
        required: true,
    },
    status: {
        type: String,
        required: true,
        enum: ["Pending", "Shipped", "Delivered", "Cancelled"],
        default: "Pending",
    },
    totalAmount: {
        type: Number,
        required: true,
    },
}, { timestamps: true });
const Order = mongoose.model("Order", orderSchema);
export default Order;
