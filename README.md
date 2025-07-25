# Studio Projects

A modern Flutter-based e-commerce mobile application frontend, designed to work with a Node.js/Express backend. This project demonstrates best practices in Flutter development, state management, API integration, and Firebase authentication.

## Features
Studio Projects is a full-stack e-commerce solution featuring a modern Flutter-based mobile frontend and a robust Node.js/Express/MongoDB backend. This project demonstrates best practices in Flutter development, state management, API integration, secure authentication, and scalable backend architecture. It is designed for learning, rapid prototyping, and real-world deployment.
- User authentication (Google Sign-In, secure storage)
- Product listing, categories, brands, and banners
- Product details with ratings and reviews
### Frontend (Flutter)

- **User Authentication**
  - Google Sign-In integration for seamless login
  - Secure storage of tokens and user data using `flutter_secure_storage`
  - Persistent login state with `get_storage` and `shared_preferences`
- **Product Catalog**
  - Browse products by category, brand, and featured banners
  - Product detail pages with images, descriptions, and price
  - Product ratings and reviews with `flutter_rating_bar` and `readmore` for expandable text
- **Cart & Wishlist**
  - Add/remove products to cart and wishlist
  - View, update, and remove items from cart
  - Wishlist management for favorite products
- **Order Management**
  - Place orders and view order history
  - Order details and status tracking
- **UI/UX Enhancements**
  - Smooth page indicators and carousel sliders for banners and product images
  - Custom icons with `iconsax` and `cupertino_icons`
  - Responsive layouts and modern design
  - Local asset and font management for a branded experience
- **API Integration**
  - Robust HTTP requests with `http` and cookie management with `cookie_jar`
  - Environment-based API URLs using `flutter_dotenv`
- **Analytics**
  - Firebase Analytics for user behavior tracking
- **Other Utilities**
  - Image picking for user profile or product uploads
  - URL launching for external links

### Backend (Node.js/Express)

- **User Management**
  - Registration, login, and authentication (JWT-based)
  - User profile management
- **Product & Category Management**
  - CRUD operations for products, categories, brands
  - Image upload and management (Cloudinary integration)
- **Cart, Wishlist, and Orders**
  - Add/remove products to cart and wishlist
  - Place and manage orders
- **Reviews**
  - Add, edit, and view product reviews
- **Admin Features**
  - Admin routes for managing products, categories, brands, and users
- **API Response Handling**
  - Consistent API responses and error handling
- **Authentication Middleware**
  - Passport.js and custom middleware for route protection
- **Database**
  - MongoDB with Mongoose models for all entities

---
- **Frontend:** Flutter (Dart)
- **State Management:** GetX
- **Backend:** Node.js, Express, MongoDB (see backend folder)
- **Authentication:** Google Sign-In, Firebase
- **API Communication:** HTTP, Cookie Jar
- **Local Storage:** Shared Preferences, Get Storage, Flutter Secure Storage
- **UI/UX:** Custom fonts, icons, image assets, smooth page indicators, carousel slider

## Getting Started


---
### Prerequisites
- Flutter SDK >= 3.4.3 < 4.0.0
- Dart
- Node.js (for backend)
- MongoDB (local or Atlas)

### Installation


---
1. **Clone the repository:**
   ```sh
   git clone https://https://github.com/Joyboy48/EliteCart.git
   cd studio_projects/FE
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Configure environment variables:**
   - Create a `.env` file in the backend and frontend as needed.
   - For backend, set `MONGODB_URL` and `PORT`.
   - For frontend, use `flutter_dotenv` for API URLs and keys.
4. **Run the app:**
   ```sh
   flutter run
   ```

### Backend Setup
See the `/src` folder in the root for the Node.js/Express backend. Configure your `.env` file with the correct MongoDB connection string and port.

#### Backend Setup

1. Go to the backend directory:
   ```sh
   cd ../src
   ```
2. Install backend dependencies:
   ```sh
   npm install
   ```
3. Create a `.env` file with:
   ```env
   MONGODB_URL=mongodb://localhost:27017/your_database_name
   PORT=8000
   ```
4. Start the backend server:
   ```sh
   npm run start
   ```

---

## Folder Structure

```
FE/                # Flutter frontend
  pubspec.yaml     # Flutter dependencies and assets
  ...
src/               # Node.js backend
  app.ts           # Main app entry
  controllers/     # Route controllers
  models/          # Mongoose models
  routes/          # API routes
  ...
```

## Assets & Fonts
- All images, icons, and fonts are managed in the `assets/` directory and configured in `pubspec.yaml`.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)

---

**Note:**
- Update API endpoints and environment variables as per your deployment.
- For any issues, please open an issue on GitHub.

- Asset folders include:
  - `assets/icons/brands/` (brand icons)
  - `assets/images/` (general images)
  - `assets/logos/` (logos)
  - `assets/images/category/`, `assets/images/banner/`, `assets/images/product/` (product and banner images)
- Custom fonts (Poppins, Coolvetica) are declared in `pubspec.yaml` for a unique look and feel.

---

## API Endpoints (Backend)

The backend exposes RESTful endpoints for all major resources:

- `/api/auth` – User authentication (register, login, Google, etc.)
- `/api/user` – User profile, wishlist, cart
- `/api/product` – Product listing, details, reviews
- `/api/category` – Category management
- `/api/brand` – Brand management
- `/api/order` – Order placement and history
- `/api/upload` – Image uploads

All endpoints are protected with authentication middleware where required. See the `routes/` and `controllers/` folders for details.

---

## Environment Variables

**Frontend:**
- Use `.env` and `flutter_dotenv` to manage API URLs and keys.

**Backend:**
- `.env` file must include:
  - `MONGODB_URL` – MongoDB connection string
  - `PORT` – Server port

---

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change. Contributions for new features, bug fixes, and documentation are appreciated.

## License
[MIT](LICENSE)

---

**Notes:**
- Update API endpoints and environment variables as per your deployment.
- For any issues, please open an issue on GitHub.
- This project is for educational and demonstration purposes. For production, review security and scalability best practices.
