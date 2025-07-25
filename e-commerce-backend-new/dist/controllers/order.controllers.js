import Order from "../models/order.models.js";
import Cart from "../models/cart.models.js";
// Create an order from the user's cart
export const checkout = async (req, res) => {
    try {
        const userId = req.user._id;
        const { shippingDate, shippingAddress } = req.body;
        const cart = await Cart.findOne({ userId });
        if (!cart || cart.items.length === 0) {
            return res.status(400).json({ message: "Cart is empty" });
        }
        const order = await Order.create({
            userId,
            items: cart.items.map(item => item.productId),
            orderDate: new Date(),
            shippingDate: shippingDate ? new Date(shippingDate) : new Date(),
            status: "Pending",
            totalAmount: cart.items.reduce((sum, item) => sum + (item.price * item.quantity), 0),
            shippingAddress,
        });
        // Clear cart
        cart.items = [];
        await cart.save();
        res.status(201).json({ message: "Order placed", data: order });
    }
    catch (err) {
        res.status(500).json({ message: "Server error", error: err });
    }
};
// Get all orders for the current user
export const getUserOrders = async (req, res) => {
    try {
        const userId = req.user._id;
        const orders = await Order.find({ userId }).sort({ createdAt: -1 });
        res.status(200).json({ data: orders });
    }
    catch (err) {
        res.status(500).json({ message: "Server error", error: err });
    }
};
// Cancel an order (user)
export const cancelOrder = async (req, res) => {
    try {
        const userId = req.user._id;
        const { orderId } = req.params;
        const order = await Order.findOne({ _id: orderId, userId });
        if (!order)
            return res.status(404).json({ message: 'Order not found' });
        if (order.status !== 'Pending') {
            return res.status(400).json({ message: 'Only pending orders can be cancelled' });
        }
        await Order.deleteOne({ _id: orderId, userId });
        res.status(200).json({ message: 'Order deleted' });
    }
    catch (err) {
        res.status(500).json({ message: 'Server error', error: err });
    }
};
