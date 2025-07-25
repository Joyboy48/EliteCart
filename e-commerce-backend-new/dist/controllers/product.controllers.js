import asyncHandler from "../utils/asyncHandler.js";
import apiError from "../utils/apiError.js";
import apiResponse from "../utils/apiResponse.js";
import Product from "../models/product.models.js";
import { uploadOnCloudinary } from "../utils/cloudinary.js";
import mongoose from "mongoose";
// Create a new product
export const createProduct = asyncHandler(async (req, res) => {
    let { name, description, price, discount, brandId, brandName, categories, stock } = req.body;
    let images = req.body.images;
    // Ensure categories is always an array
    if (categories && !Array.isArray(categories)) {
        if (typeof categories === 'string' && categories.includes(',')) {
            categories = categories.split(',').map(s => s.trim());
        }
        else {
            categories = [categories];
        }
    }
    // Ensure images is always an array (if not using file upload)
    if (!req.files && images && !Array.isArray(images)) {
        if (typeof images === 'string' && images.includes(',')) {
            images = images.split(',').map(s => s.trim());
        }
        else {
            images = [images];
        }
    }
    // Handle file upload for images (support multiple files)
    if (req.files && Array.isArray(req.files) && req.files.length > 0) {
        images = [];
        for (const file of req.files) {
            const uploadResult = await uploadOnCloudinary(file.path, 'ecommerce/product-images');
            if (uploadResult && uploadResult.secure_url) {
                images.push(uploadResult.secure_url);
            }
        }
    }
    // Debug log to help trace incoming values
    console.log({ name, description, price, brandId, brandName, images, categories, stock });
    if (!name || !description || !price || (!brandId && !brandName) || !images || !categories || !stock) {
        return res.status(400).json(new apiError(400, "Missing required fields"));
    }
    // Check if product with the same name already exists (case-insensitive)
    const existingProduct = await Product.findOne({ name: { $regex: `^${name}$`, $options: 'i' } });
    if (existingProduct) {
        return res.status(409).json(new apiError(409, 'Product already exists'));
    }
    // If brandId is not provided, but brandName is, look up the brandId
    let brand = null;
    if (!brandId && brandName) {
        const { default: Brand } = await import("../models/brand.models.js");
        brand = await Brand.findOne({ name: { $regex: `^${brandName}$`, $options: 'i' } });
        if (!brand) {
            return res.status(400).json(new apiError(400, `Brand not found for name: ${brandName}`));
        }
        brandId = brand._id.toString();
    }
    else if (brandId) {
        const { default: Brand } = await import("../models/brand.models.js");
        brand = await Brand.findById(new mongoose.Types.ObjectId(brandId));
    }
    // Create product
    const product = await Product.create({
        name,
        description,
        price,
        discount: discount || 0.0,
        brandId: new mongoose.Types.ObjectId(brandId),
        images,
        categories,
        stock
    });
    // Update Brand: increment productCount
    if (brand) {
        brand.productCount = (brand.productCount || 0) + 1;
        await brand.save();
    }
    // Update Category: add product to each category's products array
    if (Array.isArray(categories)) {
        const { default: Category } = await import("../models/category.models.js");
        await Promise.all(categories.map(async (catName) => {
            // Find category by name (case-insensitive)
            const category = await Category.findOne({ name: { $regex: `^${catName}$`, $options: 'i' } });
            if (category) {
                // Only add if not already present
                if (!category.products.some(pid => pid.equals(product._id))) {
                    category.products.push(product._id);
                    await category.save();
                }
            }
        }));
    }
    return res.status(201).json(new apiResponse(201, product, "Product created successfully"));
});
// Get all products
export const getProducts = asyncHandler(async (req, res) => {
    const products = await Product.find().populate('brandId');
    return res.status(200).json(new apiResponse(200, products, "Products fetched successfully"));
});
// Get a single product by ID
export const getProductById = asyncHandler(async (req, res) => {
    const product = await Product.findById(req.params.id).populate('brandId');
    if (!product)
        return res.status(404).json(new apiError(404, "Product not found"));
    return res.status(200).json(new apiResponse(200, product, "Product fetched successfully"));
});
// Update a product
export const updateProduct = asyncHandler(async (req, res) => {
    const productId = req.params.id;
    let update = req.body;
    // Find the old product
    const oldProduct = await Product.findById(productId);
    if (!oldProduct)
        return res.status(404).json(new apiError(404, "Product not found"));
    // Handle file upload for images (support multiple files)
    let images = update.images;
    if (req.files && Array.isArray(req.files) && req.files.length > 0) {
        images = [];
        for (const file of req.files) {
            const uploadResult = await uploadOnCloudinary(file.path, 'ecommerce/product-images');
            if (uploadResult && uploadResult.secure_url) {
                images.push(uploadResult.secure_url);
            }
        }
        update.images = images;
    }
    else if (typeof images === 'string') {
        // If images is a single string, convert to array
        update.images = [images];
    }
    // If categories are being updated, sync category.products arrays
    let newCategories = update.categories;
    if (newCategories) {
        const { default: Category } = await import("../models/category.models.js");
        // Remove product from categories it is no longer in
        const oldCategories = oldProduct.categories || [];
        const toRemove = oldCategories.filter((cat) => !newCategories.includes(cat));
        const toAdd = newCategories.filter((cat) => !oldCategories.includes(cat));
        // Remove productId from categories to remove
        await Promise.all(toRemove.map(async (catName) => {
            const category = await Category.findOne({ name: { $regex: `^${catName}$`, $options: 'i' } });
            if (category && category.products.some(pid => pid.equals(new mongoose.Types.ObjectId(productId)))) {
                category.products = category.products.filter(pid => !pid.equals(new mongoose.Types.ObjectId(productId)));
                await category.save();
            }
        }));
        // Add productId to categories to add
        await Promise.all(toAdd.map(async (catName) => {
            const category = await Category.findOne({ name: { $regex: `^${catName}$`, $options: 'i' } });
            if (category && !category.products.some(pid => pid.equals(new mongoose.Types.ObjectId(productId)))) {
                category.products.push(new mongoose.Types.ObjectId(productId));
                await category.save();
            }
        }));
    }
    // Update the product
    const product = await Product.findByIdAndUpdate(productId, update, { new: true });
    return res.status(200).json(new apiResponse(200, product, "Product updated successfully"));
});
// Delete a product
export const deleteProduct = asyncHandler(async (req, res) => {
    const productId = req.params.id;
    const product = await Product.findByIdAndDelete(productId);
    if (!product)
        return res.status(404).json(new apiError(404, "Product not found"));
    // Decrement productCount in Brand
    if (product.brandId) {
        const { default: Brand } = await import("../models/brand.models.js");
        const brand = await Brand.findById(product.brandId);
        if (brand && brand.productCount > 0) {
            brand.productCount -= 1;
            await brand.save();
        }
    }
    // Remove product from all categories' products arrays
    if (Array.isArray(product.categories)) {
        const { default: Category } = await import("../models/category.models.js");
        await Promise.all(product.categories.map(async (catName) => {
            const category = await Category.findOne({ name: { $regex: `^${catName}$`, $options: 'i' } });
            if (category && category.products.some(pid => pid.equals(productId))) {
                category.products = category.products.filter(pid => !pid.equals(productId));
                await category.save();
            }
        }));
    }
    return res.status(200).json(new apiResponse(200, product, "Product deleted successfully"));
});
// Add this function
export const searchProducts = asyncHandler(async (req, res) => {
    const q = req.query.q;
    if (!q) {
        return res.status(400).json(new apiError(400, "Missing search query"));
    }
    // Search by name (case-insensitive, partial match)
    const products = await Product.find({
        name: { $regex: q, $options: "i" }
    }).populate('brandId');
    return res.status(200).json(new apiResponse(200, products, "Products search results"));
});
// Get products by category ID (populated with brandId)
export const getProductsByCategory = asyncHandler(async (req, res) => {
    const categoryId = req.params.categoryId;
    // Find the category by ID to get its name
    const { default: Category } = await import("../models/category.models.js");
    const category = await Category.findById(categoryId);
    if (!category) {
        return res.status(404).json(new apiError(404, "Category not found"));
    }
    // Find products that have this category name in their categories array
    const products = await Product.find({ categories: { $in: [category.name] } }).populate('brandId');
    return res.status(200).json(new apiResponse(200, products, "Products fetched successfully by category"));
});
