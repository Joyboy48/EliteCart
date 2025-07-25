import { Router } from "express";
import { uploadData } from "../controllers/upload.controllers.js";
const router = Router();
router.post("/upload-data", uploadData);
export default router;
