# Homemade CEO — Phase 0: Non-API Development Plan (Mocking & Scaffolding)

This document outlines everything we can (and will) build in the codebase *before* purchasing any subscriptions or generating live API keys. By using a "Dependency Injection" and "Mocking" pattern, we can construct 80% of the platform using placeholder data, and simply swap in the real APIs later.

---

## 1. The Strategy: Interface Mocking & Environment Variables
We will build the application to rely on abstract data interfaces. For example, instead of writing code that talks directly to Supabase, we will write an `AuthRepository`. 
* **Right now:** `AuthRepository` will return hardcoded dummy user data (`MockUser("Saina", "Ernakulam")`).
* **Later:** We just swap the mock with the real Supabase SDK. 
* **The `.env` File:** We will create a local `.env` file that holds placeholders for future API keys so the architecture is ready.

```env
# PLACEHOLDER .env FILE
SUPABASE_URL="PENDING_SUBSCRIPTION"
CLAUDE_API_KEY="PENDING_SUBSCRIPTION"
SARVAM_API_KEY="PENDING_SUBSCRIPTION"
INTERAKT_API_KEY="PENDING_SUBSCRIPTION"
RAZORPAY_KEY="PENDING_SUBSCRIPTION"
```

---

## 2. What We Can Build NOW (Flutter Frontend)
Since the frontend mostly consumes data, we can build the entire visual application using mock JSON data via Riverpod.

### A. Routing & State Architecture
* **GoRouter Setup:** Define the complete URL structure for the Web Dashboards (e.g., `/seller/home`, `/seller/lms`, `/admin/crm`, `/admin/ledger`).
* **Riverpod Setup:** Scaffold the state providers that will hold our (currently fake) data.

### B. Global Design System (UI/UX)
* **Theming:** Implement the deep Navy Blue, warm Gold (`#D4A24E`), and Cream color palette.
* **Typography:** Integrate strong Malayalam script fonts (like Google Noto Sans Malayalam).
* **Responsive Layouts:** Build the scaffolding so the Seller Dashboard looks great on low-end Android mobile browsers, and the Admin Dashboard spreads out beautifully on desktop screens.

### C. The Seller Dashboard UI
* **Home Page:** Build the UI for the Course Progress bar, Active Products count, and Revenue Widget using fake numbers.
* **Products Page:** Build the grid of uploaded product cards with fake status badges (`Pending Validation`, `Live`).
* **LMS Course UI:** Build the video player skeleton and the quiz interface.

### D. The Admin Dashboard UI
* **CRM Table:** Build a data table populated with fake seller names and KYC statuses.
* **Creative Review Queue:** Build the UI that displays an auto-generated poster (using a placeholder image) with `Approve` and `Reject` buttons.
* **Spend Ledger:** Build the highly accountable, append-only data table for tracking ad spend.

---

## 3. What We Can Build NOW (Backend Business Logic)
Even without Claude, Sarvam, or Supabase, we can write the core mathematical and operational logic that Jami uses.

### A. The State Machine Core
* Write the Dart/Node.js logic that defines exactly what state a user is in and what transitions are allowed (e.g., `ONBOARDING` -> `COURSE_DELIVERY` -> `PRODUCT_INTAKE`).

### B. The Margin Validation Engine (The Hard Gate)
* Write the mathematical functions that Jami will use to calculate profitability.
* *Logic:* `Profit = Price - (Raw Materials + Packaging + Labor + Overhead)`. 
* We can write and test this engine thoroughly using fake inputs to ensure it strictly enforces the ≥100% margin rule.

### C. The OTP Login Logic Workflow
* Write the local logic flow that generates a random 4-digit code and verifies it. Instead of actually sending it via WhatsApp, we can just print the code to the debug console to test the login screen on the frontend!
