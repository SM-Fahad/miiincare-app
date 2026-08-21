# MiiinCare Live Site API Documentation

This document provides a comprehensive list and technical specification for all live REST API endpoints powering **Miiincare** (`https://miiincare.com`).

---

## Base URLs & Production Configuration

- **Production API Base URL**: `https://miiincare.com/api` (or dedicated API subdomain `https://api.miiincare.com/api`)
- **Authentication**: Bearer Token in header: `Authorization: Bearer <JWT_TOKEN>`
- **Guest Sessions**: Identified via httpOnly cookie `belora_cart` with `credentials: 'include'`
- **Content Type**: `application/json`
- **Response Format**: Direct JSON or standard wrapper `{ "data": <payload> }`

---

## Complete Live API Endpoints List

| # | Method | Live API URL | Service & Description | Auth Required |
|:---|:---|:---|:---|:---:|
| 1 | `GET` | `https://miiincare.com/api/products` | List & filter catalog products | No |
| 2 | `GET` | `https://miiincare.com/api/products/{slug}` | Get product details by slug or ID | No |
| 3 | `GET` | `https://miiincare.com/api/products/{slug}/reviews` | Fetch reviews for a specific product | No |
| 4 | `POST` | `https://miiincare.com/api/products/{slug}/reviews` | Submit a customer product review | No |
| 5 | `GET` | `https://miiincare.com/api/categories` | Retrieve all product categories | No |
| 6 | `GET` | `https://miiincare.com/api/cart` | Get current shopping cart state & totals | Optional |
| 7 | `POST` | `https://miiincare.com/api/cart/items` | Add product to cart | Optional |
| 8 | `PATCH`| `https://miiincare.com/api/cart/items/{id}` | Update quantity of a line item in cart | Optional |
| 9 | `DELETE`| `https://miiincare.com/api/cart/items/{id}` | Remove a line item from cart | Optional |
| 10 | `DELETE`| `https://miiincare.com/api/cart` | Clear entire shopping cart | Optional |
| 11 | `POST` | `https://miiincare.com/api/cart/coupon` | Apply promo / coupon code | Optional |
| 12 | `DELETE`| `https://miiincare.com/api/cart/coupon` | Remove applied coupon code | Optional |
| 13 | `POST` | `https://miiincare.com/api/orders` | Place a new order / checkout | Optional |
| 14 | `GET` | `https://miiincare.com/api/orders` | List user orders | Yes |
| 15 | `GET` | `https://miiincare.com/api/orders/{id}` | Get specific order by Order ID | Optional / Yes |
| 16 | `POST` | `https://miiincare.com/api/auth/login` | Authenticate customer credentials | No |
| 17 | `POST` | `https://miiincare.com/api/auth/register` | Register new customer account | No |
| 18 | `GET` | `https://miiincare.com/api/auth/me` | Fetch authenticated user profile | Yes |
| 19 | `GET` | `https://miiincare.com/api/content/home` | Fetch homepage hero, banners & stats | No |
| 20 | `GET` | `https://miiincare.com/api/blog` | List blog posts with pagination | No |
| 21 | `GET` | `https://miiincare.com/api/blog/{slug}` | Get single blog article & related posts | No |
| 22 | `POST` | `https://miiincare.com/api/newsletter/subscribe` | Subscribe email to newsletter | No |
| 23 | `POST` | `https://miiincare.com/api/contact` | Submit contact / customer support message | No |

---

## Endpoint Specifications

### 1. Catalog & Products

#### 1.1 List Products
`GET https://miiincare.com/api/products`

**Query Parameters:**
- `category` (string, optional): e.g. `sun-care`, `serums`, `cleansers`
- `search` (string, optional): Search keyword
- `sort` (string, optional): `featured` | `price-asc` | `price-desc` | `rating` | `newest` | `name`
- `minPrice` / `maxPrice` (number, optional): Price range in BDT
- `rating` (number, optional): Minimum rating (1-5)
- `bestSeller` (boolean, optional): `true` to filter best sellers
- `isNew` (boolean, optional): `true` to filter new arrivals
- `bundle` (boolean, optional): `true` for combo sets, `false` for standalone
- `page` (number, default: 1): Page number
- `perPage` (number, default: 12): Items per page

**Example Response:**
```json
{
  "items": [
    {
      "id": 1,
      "slug": "watermelon-cooling-sunscreen-spf-50-pa-with-new-age-uv-filters",
      "name": "Watermelon Cooling Sunscreen SPF 50+ PA++++",
      "tagline": "PROTECT & COOL",
      "category": "sun-care",
      "price": 1450,
      "compareAtPrice": 1650,
      "rating": 5.0,
      "reviewCount": 89,
      "size": "50ml / 1.7 fl.oz",
      "art": { "shape": "tube", "tone": "rose" },
      "image": "https://miiincare.com/assets/products/sunscreen.png",
      "images": [
        { "id": 1, "url": "https://miiincare.com/assets/products/sunscreen.png", "alt": "Product view" }
      ],
      "shortDescription": "SPF 50+ PA++++ with Watermelon Extract & Hyaluronic Acid.",
      "description": "Complete Sun & Light Shield...",
      "ingredients": ["Watermelon Extract", "Hyaluronic Acid", "Niacinamide"],
      "howToUse": "Apply generously 20 minutes before stepping out.",
      "benefits": ["UVA/UVB protection", "No white cast", "Instant cooling"],
      "isBestSeller": true,
      "isNew": true,
      "isBundle": false,
      "stock": 120,
      "createdAt": "2026-01-15T00:00:00.000Z"
    }
  ],
  "meta": { "page": 1, "perPage": 12, "total": 18, "totalPages": 2 }
}
```

---

#### 1.2 Get Product Details
`GET https://miiincare.com/api/products/{slug}`

**Example**: `GET https://miiincare.com/api/products/watermelon-cooling-sunscreen-spf-50-pa-with-new-age-uv-filters`

---

#### 1.3 Product Reviews
- `GET https://miiincare.com/api/products/{slug}/reviews`
- `POST https://miiincare.com/api/products/{slug}/reviews`

**POST Request Body:**
```json
{
  "author": "Fatima Zahra",
  "rating": 5,
  "title": "Best sunscreen in Bangladesh!",
  "body": "No white cast at all and very lightweight under makeup."
}
```

---

#### 1.4 Categories
`GET https://miiincare.com/api/categories`

---

### 2. Cart Management

#### 2.1 Get Cart
`GET https://miiincare.com/api/cart`

**Response:**
```json
{
  "items": [
    {
      "id": "line_1724160001_1",
      "productId": 1,
      "slug": "watermelon-cooling-sunscreen-spf-50-pa-with-new-age-uv-filters",
      "name": "Watermelon Cooling Sunscreen SPF 50+ PA++++",
      "price": 1450,
      "size": "50ml / 1.7 fl.oz",
      "art": { "shape": "tube", "tone": "rose" },
      "image": "https://miiincare.com/assets/products/sunscreen.png",
      "quantity": 2,
      "lineTotal": 2900,
      "stock": 120
    }
  ],
  "coupon": { "code": "WELCOME10", "label": "10% off your first order" },
  "itemCount": 2,
  "subtotal": 2900,
  "discount": 290,
  "shipping": 70,
  "tax": 0,
  "total": 2680,
  "freeShippingThreshold": 2999,
  "amountToFreeShipping": 389
}
```

#### 2.2 Add Item
`POST https://miiincare.com/api/cart/items`
```json
{ "productId": 1, "quantity": 1 }
```

#### 2.3 Update Item Quantity
`PATCH https://miiincare.com/api/cart/items/{id}`
```json
{ "quantity": 2 }
```

#### 2.4 Remove Item & Clear Cart
- `DELETE https://miiincare.com/api/cart/items/{id}`
- `DELETE https://miiincare.com/api/cart`

#### 2.5 Apply / Remove Coupon
- `POST https://miiincare.com/api/cart/coupon` -> `{ "code": "WELCOME10" }`
- `DELETE https://miiincare.com/api/cart/coupon`

---

### 3. Orders & Checkout

#### 3.1 Place Order
`POST https://miiincare.com/api/orders`

**Request Body:**
```json
{
  "email": "customer@gmail.com",
  "firstName": "Tahmid",
  "lastName": "Hasan",
  "address": "Road 11, Block D, Banani",
  "apartment": "Apt 3B",
  "city": "Dhaka",
  "state": "Dhaka",
  "postalCode": "1213",
  "country": "Bangladesh",
  "phone": "+8801711223344",
  "paymentMethod": "cod"
}
```

**Response (200 OK):**
```json
{
  "id": "BEL-82910412",
  "createdAt": "2026-08-20T21:20:00.000Z",
  "status": "confirmed",
  "customer": {
    "email": "customer@gmail.com",
    "name": "Tahmid Hasan",
    "phone": "+8801711223344"
  },
  "shippingAddress": {
    "address": "Road 11, Block D, Banani",
    "apartment": "Apt 3B",
    "city": "Dhaka",
    "state": "Dhaka",
    "postalCode": "1213",
    "country": "Bangladesh"
  },
  "paymentMethod": "cod",
  "items": [ ... ],
  "totals": {
    "subtotal": 2900,
    "discount": 290,
    "shipping": 0,
    "tax": 0,
    "total": 2610
  },
  "estimatedDelivery": "2026-08-25"
}
```

#### 3.2 List Orders
`GET https://miiincare.com/api/orders`
*(Requires `Authorization: Bearer <token>`)*

#### 3.3 Get Order by ID
`GET https://miiincare.com/api/orders/{id}`

---

### 4. Authentication

#### 4.1 Login
`POST https://miiincare.com/api/auth/login`
```json
{ "email": "user@example.com", "password": "securePassword123" }
```

#### 4.2 Register
`POST https://miiincare.com/api/auth/register`
```json
{ "name": "Sadia Islam", "email": "user@example.com", "password": "securePassword123" }
```

#### 4.3 Profile
`GET https://miiincare.com/api/auth/me`
*(Requires `Authorization: Bearer <token>`)*

---

### 5. Content, Blog & Marketing

#### 5.1 Homepage Content
`GET https://miiincare.com/api/content/home`

#### 5.2 Blog Articles
- `GET https://miiincare.com/api/blog?page=1&perPage=6`
- `GET https://miiincare.com/api/blog/{slug}`

#### 5.3 Newsletter Subscribe
`POST https://miiincare.com/api/newsletter/subscribe`
```json
{ "email": "subscriber@gmail.com" }
```

#### 5.4 Contact Inquiry
`POST https://miiincare.com/api/contact`
```json
{
  "name": "Tanvir Ahmed",
  "email": "tanvir@gmail.com",
  "subject": "Wholesale Inquiry",
  "message": "Interested in bulk purchase for retail store."
}
```
