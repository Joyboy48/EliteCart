import asyncHandler from "../utils/asyncHandler.js";
import apiError from "../utils/apiError.js";
import User from "../models/user.models.js";
import apiResponse from "../utils/apiResponse.js";
import sendEmail from "../utils/sendEmail.js";
import jwt from "jsonwebtoken";
import crypto from 'crypto';
import { uploadOnCloudinary } from "../utils/cloudinary.js";
import fs from 'fs';
const refreshAccessToken = asyncHandler(async (req, res) => {
    const { refreshToken } = req.body;
    if (!refreshToken) {
        throw new apiError(400, "Refresh token is required");
    }
    try {
        const decoded = jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);
        if (decoded.exp * 1000 < Date.now()) {
            throw new apiError(401, "Refresh token has expired");
        }
        const user = await User.findById(decoded._id);
        if (!user || user.refreshToken !== refreshToken) {
            throw new apiError(401, "Invalid refresh token");
        }
        const accessToken = user.generateAccessToken();
        return res.status(200).json(new apiResponse(200, { accessToken }, "Access token refreshed successfully"));
    }
    catch (error) {
        throw new apiError(401, "Invalid or expired refresh token");
    }
});
const generateAccessAndRefreshTokens = async (userId) => {
    try {
        const user = await User.findById(userId);
        if (!user) {
            throw new apiError(404, "User not found");
        }
        const accessToken = user.generateAccessToken();
        const refreshToken = user.generateRefreshToken();
        user.refreshToken = refreshToken;
        await user.save({ validateBeforeSave: false });
        return { accessToken, refreshToken };
    }
    catch (error) {
        throw new apiError(500, "Something went wrong while generating refresh and access tokens");
    }
};
const registerUser = asyncHandler(async (req, res) => {
    const { firstName, lastName, username, phoneNumber, email, password } = req.body;
    if ([firstName, lastName, username, phoneNumber, email, password].some((field) => field?.trim() === "")) {
        throw new apiError(400, "All fields are required");
    }
    const existingUser = await User.findOne({
        $or: [{ username }, { email }]
    });
    if (existingUser) {
        throw new apiError(400, "User already exists");
    }
    const verificationToken = crypto.randomBytes(32).toString('hex');
    const user = await User.create({
        firstName,
        lastName,
        email,
        phoneNumber,
        username,
        password,
        emailVerificationToken: verificationToken,
        emailVerificationTokenExpires: Date.now() + 3600000,
    });
    const createdUser = await User.findById(user._id).select("-password -refreshToken");
    if (!createdUser) {
        throw new apiError(500, "Something went wrong while registering user");
    }
    const verificationUrl = `${process.env.FRONTEND_URL}/verify-email?token=${verificationToken}&email=${email}`;
    const message = `Click on this link to verify your email: ${verificationUrl}`;
    await sendEmail({
        email,
        subject: "Email Verification",
        message
    });
    return res.status(200).json(new apiResponse(200, {
        user: createdUser,
        emailVerificationToken: verificationToken
    }, "User registered successfully"));
});
export const verifyEmail = asyncHandler(async (req, res) => {
    const { token, email } = req.query;
    const user = await User.findOne({
        email,
        emailVerificationToken: token,
        emailVerificationTokenExpires: { $gt: Date.now() }
    });
    if (!user) {
        throw new apiError(400, "Invalid or expired token");
    }
    user.isVerified = true;
    user.emailVerificationToken = undefined;
    user.emailVerificationTokenExpires = undefined;
    await user.save();
    return res.status(200).json(new apiResponse(200, null, "Email verified successfully"));
});
const loginUser = asyncHandler(async (req, res) => {
    const { email, password } = req.body;
    if (!(email || password)) {
        throw new apiError(400, "email password required");
    }
    const user = await User.findOne({ email });
    if (!user) {
        throw new apiError(400, "invalid email");
    }
    const isPasswordCorrect = await user.isPasswordCorrect(password);
    if (!isPasswordCorrect) {
        throw new apiError(400, "invalid password");
    }
    const { accessToken, refreshToken } = await generateAccessAndRefreshTokens(user._id);
    const loggedInUser = await User.findById(user._id).select("-password -refreshToken");
    console.log(user);
    const options = {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "strict"
    };
    return res
        .status(200)
        .cookie("accessToken", accessToken, options)
        .cookie("refreshToken", refreshToken, options)
        .json(new apiResponse(200, { user: loggedInUser, accessToken, refreshToken }, "user logged in successfully"));
});
const logoutUser = asyncHandler(async (req, res) => {
    const userId = req.user._id;
    await User.findByIdAndUpdate(userId, {
        $set: {
            refreshToken: undefined
        }
    }, { new: true });
    const options = {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "strict"
    };
    return res
        .status(200)
        .clearCookie("accessToken", options)
        .clearCookie("refreshToken", options)
        .json(new apiResponse(200, {}, "User logged out successfully"));
});
const forgotPassword = asyncHandler(async (req, res) => {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
        throw new apiError(400, "User does not exist");
    }
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const otpToken = jwt.sign({ otp, id: user._id }, process.env.JWT_RESET_PASSWORD_SECRET, { expiresIn: "15m" });
    const message = `Your OTP for password reset is: ${otp}. It is valid for 15 minutes.`;
    try {
        await sendEmail({
            email: user.email,
            subject: "Password Reset OTP",
            message,
        });
        return res
            .status(200)
            .json(new apiResponse(200, { otpToken }, "OTP sent successfully"));
    }
    catch (error) {
        throw new apiError(500, "Failed to send OTP email");
    }
});
const resetPassword = asyncHandler(async (req, res) => {
    const { otpToken, newPassword } = req.body;
    try {
        const decoded = jwt.verify(otpToken, process.env.JWT_RESET_PASSWORD_SECRET);
        const user = await User.findById(decoded.id);
        if (!user) {
            throw new apiError(400, "User not found");
        }
        user.password = newPassword;
        await user.save();
        return res.status(200).json(new apiResponse(200, null, "Password reset successful"));
    }
    catch (error) {
        throw new apiError(400, "Invalid or expired OTP");
    }
});
const getUserProfile = asyncHandler(async (req, res) => {
    const userId = req.user._id;
    const user = await User.findById(userId).select("-password -refreshToken");
    if (!user) {
        throw new apiError(404, "User not found");
    }
    return res.status(200).json(new apiResponse(200, { user }, "User profile retrieved successfully"));
});
const updateUserProfile = asyncHandler(async (req, res) => {
    const userId = req.user._id;
    const { firstName, lastName, phoneNumber } = req.body;
    const user = await User.findById(userId);
    if (!user) {
        throw new apiError(404, "User not found");
    }
    if (firstName)
        user.firstName = firstName;
    if (lastName)
        user.lastName = lastName;
    if (phoneNumber)
        user.phoneNumber = phoneNumber;
    await user.save();
    return res.status(200).json(new apiResponse(200, { user }, "Profile updated successfully"));
});
const uploadProfileImage = asyncHandler(async (req, res) => {
    const userId = req.user._id;
    const avatarLocalPath = req.file?.path;
    if (!avatarLocalPath) {
        throw new apiError(400, "Avatar file is required");
    }
    // Check if file exists
    if (!fs.existsSync(avatarLocalPath)) {
        throw new apiError(400, "Uploaded file not found");
    }
    const avatar = await uploadOnCloudinary(avatarLocalPath, "avatar");
    if (!avatar?.url) {
        throw new apiError(400, "Error while uploading avatar to Cloudinary. Please check your Cloudinary configuration.");
    }
    const user = await User.findByIdAndUpdate(userId, { $set: { avatar: avatar.url } }, { new: true }).select("-password -refreshToken");
    if (!user) {
        throw new apiError(404, "User not found");
    }
    return res.status(200).json(new apiResponse(200, { user }, "Avatar updated successfully"));
});
export { refreshAccessToken, registerUser, loginUser, logoutUser, forgotPassword, resetPassword, getUserProfile, updateUserProfile, uploadProfileImage };
