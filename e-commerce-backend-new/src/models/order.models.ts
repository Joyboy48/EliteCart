import mongoose, { Document, Schema } from "mongoose";

export type OrderStatus = "Pending" | "Shipped" | "Delivered" | "Cancelled";

export interface IOrder extends Document {
    userId: mongoose.Types.ObjectId;
    items: mongoose.Types.ObjectId[];
    orderDate: Date;
    shippingDate: Date;
    status: OrderStatus;
    totalAmount: number;
}

const orderSchema = new Schema<IOrder>({
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

const Order = mongoose.model<IOrder>("Order", orderSchema);
export default Order; 