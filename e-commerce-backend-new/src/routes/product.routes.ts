import { Router } from "express";
import {
    createProduct,
    getProducts,
    getProductById,
    updateProduct,
    deleteProduct,
    searchProducts,
    getProductsByCategory
} from "../controllers/product.controllers.js";
import { upload } from "../middlewares/multer.middlewares.js";

const router: Router = Router();

// Use multer for file upload parsing
router.post("/product", upload.array("images", 10), createProduct);
router.get("/products", getProducts);
router.get("/product/:id", getProductById);
router.put("/product/:id", updateProduct);
router.delete("/product/:id", deleteProduct);
router.get("/products/search", searchProducts);
router.get("/category/:categoryId", getProductsByCategory);

export default router; 