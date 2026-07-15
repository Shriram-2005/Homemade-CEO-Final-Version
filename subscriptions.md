# Homemade CEO — Required Subscriptions & Cost Architecture

To run the Homemade CEO platform at scale, you will need to utilize a mix of monthly subscriptions and "Pay-as-you-go" API services. Here is the complete list of everything required to run the platform in production.

---

## 1. Fixed Monthly Subscriptions
These services charge a flat, predictable monthly fee.

* **Interakt (WhatsApp BSP):**
  * **What it is:** The "pipe" connecting us to WhatsApp. Handles message template approvals.
  * **Cost:** Fixed monthly fee (approx. ₹1,000 - ₹2,500/month depending on plan) + Meta's per-conversation fees.
* **Supabase (Database & File Storage):**
  * **What it is:** The PostgreSQL database storing seller profiles, the spend ledger, and the AWS S3-compatible storage for photos/audio.
  * **Cost:** While there is a free tier for testing, a production app of this scale requires the **Pro Plan ($25/month)**.

## 2. Pay-As-You-Go (Usage-Based APIs)
These services do not have a flat monthly subscription. You only pay for exactly what you use. If no one uses the app today, you pay $0 today.

* **Claude / Anthropic API (The Brain):**
  * **What it is:** The LLM orchestrating the state machine and generating Malayalam replies.
  * **Cost:** Paid per 1,000 "tokens" (words) processed. Claude 3.5 Haiku is incredibly cheap (fractions of a cent per message).
* **Sarvam AI API (The Ears):**
  * **What it is:** Converts Malayalam voice notes into text.
  * **Cost:** Paid per minute of audio transcribed.
* **Google Cloud Run (Compute Hosting):**
  * **What it is:** The server that runs our custom backend code (the traffic controller).
  * **Cost:** Billed to the millisecond. Scales to zero. A highly active platform might cost $5 to $20 a month, but it is strictly based on usage.

## 3. Transaction-Based (Zero Upfront Cost)
These services take a cut of the money flowing through the platform rather than charging a subscription.

* **Razorpay or Cashfree (Payments / UPI):**
  * **What it is:** Generates the UPI payment links for buyers.
  * **Cost:** No monthly subscription. They take a standard percentage fee (approx. ~2%) on every successful transaction.

## 4. Annual & Misc Costs
* **Domain Name (e.g., homemadeceo.in):**
  * **Cost:** Paid yearly via providers like GoDaddy or Namecheap (approx. ₹500 - ₹1,000/year).
* **Meta Ads Budget:**
  * **Cost:** Not a software subscription, but requires a budget (public funds/LSGD) to actually run the Instagram/Facebook ads to find buyers.

---
### Summary
The absolute minimum you need to swipe a credit card for every month to keep the server lights on is **Interakt (~₹1,500)** and **Supabase Pro ($25)**. Every other piece of technology (Claude, Sarvam, Cloud Run) scales beautifully, meaning you only pay for them when sellers are actively talking to Jami!
