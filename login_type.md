# Homemade CEO — Authentication & Profile Management

This document details the frictionless authentication architecture and profile creation logic for the Homemade CEO platform, designed specifically for rural homemakers in Kerala.

## 1. The Core Philosophy: "Zero Sign-Up"
Traditional apps require users to click "Sign Up," enter an email, create a password, and verify an email address. This creates a massive drop-off rate for our target demographic. 
Instead, Homemade CEO uses a **WhatsApp-Native Identity Model**. A seller's phone number *is* their unique identity.

## 2. Automatic Profile Creation (The First Contact)
Sellers do not manually "create an account" before talking to Jami. The account is created instantly during their first interaction.

**The Workflow:**
1. **Initial Trigger:** A homemaker sees a Kudumbashree flyer or Meta Ad and sends a simple message (e.g., "Hi") to the official Homemade CEO WhatsApp number.
2. **Backend Lookup:** The webhook fires, and the backend server checks the database (Supabase/PostgreSQL) to see if the sender's phone number exists.
3. **Ghost Profile Creation:** If the number is not found, the backend automatically spins up a new user profile using that phone number as the Primary Key.
4. **State Machine Activation:** The new profile is immediately assigned the state `ONBOARDING_STEP_1`.
5. **Conversational Intake:** Jami replies automatically, asking for their name and location to flesh out the rest of the profile natively inside the chat.

*From that second forward, every product photo they send, every course they complete, and every rupee they earn is permanently linked to that phone number.*

## 3. Web Dashboard Authentication (WhatsApp OTP)
When a seller wants to view their sales data, course progress, or raise a formal support ticket, they visit the Web Dashboard (built in Flutter). They do not log in with a password.

**The Login Flow:**
1. **Phone Number Entry:** The seller opens the dashboard and is presented with a single input field: "Enter your Phone Number".
2. **OTP Generation:** The backend receives the request, generates a secure 4-digit or 6-digit One-Time Password (OTP), and temporarily stores it in the database.
3. **WhatsApp Delivery:** Jami sends a WhatsApp message directly to the seller: *"Your secure login code for the Homemade CEO Dashboard is 8421. Do not share this with anyone."*
4. **Verification:** The seller enters the code into the web dashboard.
5. **Session Created:** The backend verifies the code, issues a secure JSON Web Token (JWT) or session cookie, and logs the user directly into their personal dashboard.

## 4. Why This Architecture is Superior
* **Zero Friction:** Users don't need an email address, nor do they have to remember passwords.
* **Cost Effective:** Sending an OTP via a WhatsApp Business message is often cheaper and more reliable than standard SMS routing in India.
* **Implicit Two-Factor Authentication:** Because we communicate business data over WhatsApp, confirming they hold the device currently logged into that WhatsApp account ensures robust security.
* **High Trust:** Receiving the login code from "Jami" (the same persona helping them build their business) reinforces brand trust and continuity.
