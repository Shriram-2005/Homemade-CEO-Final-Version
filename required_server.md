# Homemade CEO — Infrastructure & Server Requirements

This document outlines the required cloud infrastructure to run the Homemade CEO platform, specifically focusing on the backend server that acts as the "Traffic Controller" for Jami (the WhatsApp AI) and the web dashboards.

## 1. Compute (The Backend Server)
The backend server is responsible for running our core business logic: receiving WhatsApp webhooks, maintaining the State Machine, calling the Sarvam/Claude APIs, and serving data to the Flutter dashboards.

**Requirements:**
* **Type:** A standard environment capable of running Node.js, Python, Go, or Dart (depending on our final backend language choice).
* **Workload:** High I/O (handling many small webhook requests from WhatsApp asynchronously).
* **Recommended Platforms (In order of developer efficiency):**
  1. **Serverless (Firebase Cloud Functions / AWS Lambda / Vercel):** Excellent for unpredictable traffic and extremely cheap to start.
  2. **Managed Containers (Google Cloud Run / Render / DigitalOcean App Platform):** Zero-maintenance scaling.
  3. **Traditional Cloud (AWS EC2):** Only recommended if we need absolute low-level control, though it introduces high DevOps overhead.

## 2. The Database (State & Ledger)
The database is the source of truth for the entire platform. It must handle relational data securely and immutably.

**Requirements:**
* **Data Stored:** 
  * Seller profiles and KYC.
  * Real-time conversation states (e.g., `MARGIN_VALIDATION_STEP_2`).
  * Product inventory and calculated margins.
  * **The Immutable Spend Ledger:** A strict, append-only table tracking public ad spend per seller.
* **Type:** Relational (PostgreSQL) is strongly recommended due to the need for strict accounting in the Spend Ledger. NoSQL (like MongoDB or Firestore) can work but requires stricter application-level validations for the ledger.
* **Recommended Platforms:**
  1. **Supabase:** Built on PostgreSQL, offers real-time subscriptions (great for Dashboards), and is extremely developer-friendly.
  2. **AWS RDS / Google Cloud SQL:** Enterprise-grade, highly scalable, but requires more manual configuration.
  3. **Firebase Firestore:** If we prefer a NoSQL approach.

## 3. File Storage (Blob Storage)
Because the platform relies heavily on media, we need a secure, scalable place to store raw and processed files.

**Requirements:**
* **Files Stored:**
  * Inbound WhatsApp Voice Notes (`.ogg` / `.mp4`).
  * Inbound Seller Product Photos.
  * Outbound Auto-generated Ad Posters.
  * Static assets for the auto-generated Product Landing Pages.
* **Recommended Platforms:**
  1. **AWS S3 (Simple Storage Service):** The industry standard for cheap, infinite object storage.
  2. **Google Cloud Storage (GCS):** Equal to S3 in performance and pricing.
  3. **Supabase Storage / Firebase Storage:** Highly recommended if we are already using them for the database, as it consolidates our infrastructure.

## 4. Auto-scaling & Traffic Management
To handle unpredictable traffic (from massive government ad campaigns to quiet overnight hours) without crashing or wasting public funds, the architecture relies heavily on **Serverless Auto-scaling**.

* **Handling Massive Loads (Scaling Up):** When traffic spikes, the serverless platform (e.g., Google Cloud Run / Firebase) detects the load and instantly clones the backend server into hundreds of temporary instances. The load is distributed evenly, ensuring the platform never crashes under stress.
* **Handling Minimal Users (Scaling to Zero):** During quiet periods, the platform automatically deletes unused server clones, scaling compute power down to zero. This ensures you only pay for the exact milliseconds the code is running, eliminating the wasted costs associated with traditional 24/7 servers.
* **Frontend Delivery (CDN):** All static websites (Dashboards and Landing Pages) are hosted on a Content Delivery Network (CDN) like Cloudflare or Vercel. A CDN caches the website globally so that massive traffic spikes hitting the landing pages do not stress the backend database at all.

## Summary Recommendation & Best Serverless Hosting
For a project moving fast but requiring enterprise stability, a **"Managed Backend-as-a-Service"** stack is highly recommended over raw AWS infrastructure. For the absolute best serverless scaling experience:

* **Frontend Hosting (The Best Choice):** **Vercel** or **Cloudflare Pages**. They provide instantaneous global CDN caching and perfect auto-scaling for the Flutter Web dashboards and auto-generated Landing Pages.
* **Compute/Webhooks (The Best Choice):** **Google Cloud Run**. It scales Docker containers from 0 to thousands instantly, handling WhatsApp webhook spikes beautifully without the "cold start" latency issues common in traditional AWS Lambda.
* **Database & Storage:** **Supabase** (PostgreSQL + S3-compatible storage).

This stack minimizes DevOps workload while providing the extreme scalability required by the Kerala Government guidelines.
