# Homemade CEO — Digital Surfaces & Page-by-Page Specifications

This document outlines the detailed UI/UX requirements for every digital surface in the Homemade CEO ecosystem, as dictated by the Design & Brand Brief and Technical Brief.

---

## 1. Seller Dashboard (Web, Mobile-First)
**Target Audience:** Rural homemakers (Sellers).
**Device Context:** Low-end Android smartphones, patchy internet, small screens.
**Language:** Strictly Malayalam-first UI.
**Aesthetic:** Dignified, warm, aspirational. No "government scheme" clutter. Primary Navy Blue, Accent Warm Gold, Cream backgrounds.

### 1.1. Home / Overview Page
* **Greeting:** Warm, personalized greeting using the seller's name.
* **Status Cards:** 
  * **Current Course Progress:** A visual progress bar showing their status in the LMS.
  * **Active Products:** Number of products currently live or pending validation.
* **Simplified Revenue Widget:** Total revenue earned to date and pending payouts (presented in clear, large typography).
* **Alerts/Nudges:** Notifications driven by Jami (e.g., "Your Meta Ad campaign was paused. Tap here to see why.").

### 1.2. Products & Campaign Performance Page
* **Product List:** A card-based list of their uploaded products with thumbnail images.
* **Status Badges:** `Pending Validation`, `Live`, `Needs Better Photo`, `Ad Paused`.
* **Simplified Metrics (Per Product):**
  * Views (from Landing Page)
  * Orders received (via WhatsApp)
  * Amount spent on ads for this specific product.

### 1.3. Help & Support Page
* **Support Ticket List:** Status of any complaints raised via WhatsApp.
* **FAQ Section:** Expandable accordions (in Malayalam) covering payouts, course rules, and photo guidelines.

---

## 2. LMS / Course Interface (Integrated into Seller Dashboard)
**Target Audience:** Sellers.
**Function:** Mandatory educational gating before marketplace listing.

### 2.1. Course Module Viewer
* **Video Player:** Highly optimized video player for low-bandwidth connections.
* **Transcript/Notes:** Expandable text notes below the video in Malayalam.
* **Quiz Section:** Simple, touch-friendly multiple-choice questions to validate learning at the end of each module.
* **Progression System:** Locked/Unlocked visual states for modules. (Passing modules unlocks listing eligibility).

---

## 3. Ops / Admin Dashboard (Web, Desktop-Optimized)
**Target Audience:** Marketing Agency, Kudumbashree/LSGD Stakeholders, Platform Admins.
**Device Context:** Desktop/Laptop browsers.
**Language:** English.
**Aesthetic:** Professional, data-dense, highly accountable.

### 3.1. Seller Pipeline & CRM Page
* **Data Table:** List of all onboarded sellers, their current onboarding state, KYC status, and LMS completion percentage.
* **Filtering:** Filter by district, status, or language.

### 3.2. Product & Creative Review Queue
* **Product Intake Review:** Side-by-side view of seller-provided photos, extracted structured data, and the computed Margin Validation breakdown.
* **Creative Approval:** 
  * Displays the auto-generated ad posters and templates.
  * `Approve` / `Reject` buttons. (Rejection triggers a WhatsApp message back to the seller via Jami asking for new photos).

### 3.3. Campaign Management & Spend Ledger (Audit-Grade)
* **Master Campaign View:** Real-time data pulled from Meta Marketing API (Impressions, Clicks, Spend).
* **The Immutable Ledger (Critical):** A strict, append-only table tracking *every rupee* of public money spent per seller per campaign.
* **ROI Stall/Scale Controls:** Sliders/inputs to configure ROI thresholds that automatically pause failing campaigns.
* **Export Tool:** One-click CSV/PDF exports formatted explicitly for government audit reviews.

---

## 4. Product Landing Pages (Auto-Generated, Public)
**Target Audience:** General Public / Buyers clicking on Meta Ads.
**Device Context:** Primarily Mobile (traffic coming from Instagram/Facebook).
**Language:** English & Malayalam support.

### 4.1. Single Product View
* **Hero Image:** Clean, auto-composited product photo.
* **Trust Elements:** "Backed by Kudumbashree" / "Homemade CEO" branding to establish premium credibility.
* **Product Story:** The seller's name, their district, and a short generated story highlighting the dignity of the maker.
* **Price & Details:** Clear pricing, ingredients list.
* **Call to Action (CTA):** Primary button to **"Order via WhatsApp"** (v1 requirement).

---

## 5. Jami WhatsApp Visual Style
*While not a traditional web page, WhatsApp is a primary digital surface.*

* **Message Templates:** Clean formatting using WhatsApp Markdown (bolding, lists) for readability.
* **Creative Frames:** When Jami generates a poster or ad for the seller to review, the image must include the premium Navy/Gold branding frames.
* **Tone:** Conversational logic must remain strictly within the bounds of Dignified, Warm, and Aspirational—never robotic.
