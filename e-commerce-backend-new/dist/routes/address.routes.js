import express from "express";
import { addAddress, getUserAddresses, updateAddress, deleteAddress } from '../controllers/address.controller.js';
import { verifyJWT } from "../middlewares/auth.middlewares.js";
const router = express.Router();
const wrapHandler = (handler) => {
    return (req, res) => handler(req, res);
};
router.route("/address")
    .post(verifyJWT, wrapHandler(addAddress));
router.route("/addresses")
    .get(verifyJWT, wrapHandler(getUserAddresses));
router.route("/address/:id")
    .put(verifyJWT, wrapHandler(updateAddress))
    .delete(verifyJWT, wrapHandler(deleteAddress));
export default router;
