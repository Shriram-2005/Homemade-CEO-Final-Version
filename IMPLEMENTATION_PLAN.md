# Homemade CEO — Master Implementation Plan & Technical Spec

## 1. Project Overview & Core Philosophy
**Homemade CEO** is a marketplace and learning platform designed to turn rural homemakers in Kerala into e-commerce entrepreneurs. 

**Brand Thesis:** *Every home has a CEO.*
**Tone:** Dignified. Warm. Aspirational. (Never charitable or pitying).
**Core Constraint:** Every feature, UI element, and technical decision must prioritize performance on low-end Android devices and intermittent internet connectivity.

## 2. Global Design System
* **Primary/Authority Color:** Deep Navy Blue
* **Accent Color:** Warm Gold (`#D4A24E`)
* **Background:** Cream/Off-white
* **Typography:** `HOMEMADE` (Small-caps, generous spacing) + `CEO` (Bold). Body font must have robust, primary support for **Malayalam script**, while retaining clean English rendering for Ops/Admin interfaces.
* **Language Logic:** Seller-facing surfaces (Dashboards, WhatsApp) are **strictly Malayalam-first**. Admin/Ops surfaces are English.

## 3. System Architecture (End-to-End)

### 3.1. The Frontend (Dashboards) - Built with Flutter
* **Seller Dashboard (Web, Mobile-first):**
  * Tracks course progress (LMS), product status, campaign performance, and revenue owed.
  * UI completely in Malayalam.
  * Extremely lightweight, minimal assets, optimized for old Android browsers.
* **Ops/Admin Dashboard (Desktop Web):**
  * English UI.
  * Seller pipeline, product review queue, creative review queue, spend ledger, campaign management, audit exports.
* **Frontend Tech Stack:**
  * **Framework:** Flutter (Web target initially, deferred native app)
  * **State Management:** Riverpod (Highly scalable, reactive, compile-safe)
  * **Routing:** GoRouter (For web URLs and deep linking)
  * **Localization:** Custom dictionary via `flutter_localizations`

### 3.2. Jami & WhatsApp Layer (Backend Integration)
* **WhatsApp Business Cloud API:** Handled via a BSP (Gupshup / Interakt / AiSensy) or direct Meta Cloud API. Supports Malayalam text & voice notes.
* **Jami (LLM Orchestration Layer):**
  * State Machine + LLM (Not a free-running agent). States: Onboarding → Course → Product Intake → Validation → Live → Campaign.
  * Malayalam Speech-to-Text (STT): Requires rigorous evaluation (Google STT / Sarvam / AI4Bharat).
  * Evaluated LLM: Claude / GPT / Gemini benchmarked on Malayalam.

### 3.3. Content Generation Pipeline
* **Margin Validation (Hard Gate):** Strict ≥100% gross margin requirement. Jami prompts sellers for raw materials + packaging + labor + overheads.
* **Outputs:** 
  1. Ad posters (Template compositing preferred over raw AI generation for cost/consistency).
  2. Product landing pages (Static generation, fast, order CTA linked to WhatsApp).
  3. Short product videos (Phase 2).
* **Workflow:** Async job-based (Intake → Queue → Generate → Human Review flag → Publish).

### 3.4. Marketing Ops Layer & Ledger
* **Meta Marketing API:** Campaign creation, budget management, performance pull.
* **Human-in-the-loop (v1):** System prepares campaign drafts; Ops team approves.
* **Immutable Spend Ledger:** Audit-grade ledger per seller/campaign to track public funds (LSGD/Kudumbashree).
* **ROI Stall/Scale Logic:** Configurable ROI thresholds based on validated margin.

## 4. Build Phases

### Phase 1 — Jami Core + Intake (Weeks 1–6)
* WhatsApp API integration.
* Jami onboarding conversation in Malayalam.
* Product intake with photos.
* Margin validation calculator logic.
* Basic Admin Dashboard scaffolding in Flutter.
* Seller data model in backend.

### Phase 2 — Content + Landing Pages (Weeks 5–10)
* Template-based poster generation.
* Landing page generator and hosting.
* Creative review queue built into Admin Dashboard.
* WhatsApp-based ordering flow with UPI links (Razorpay/Cashfree).

### Phase 3 — LMS (Weeks 8–12)
* Course delivery and progress tracking built into Seller Dashboard.
* Jami LMS nudges.
* Marketplace gating logic.

### Phase 4 — Ads + Ledger (Weeks 10–16)
* Meta Marketing API integration.
* Human-in-the-loop campaign dashboard.
* Spend ledger and audit exports.
* ROI threshold engine and stall/diagnostic report flow.

## 5. Engineering Risks & Mitigation Strategies
1. **Malayalam LLM/STT Quality:** Must benchmark heavily in Week 1 with raw, noisy audio samples from target demographic.
2. **Photo Quality:** Jami needs a robust re-request loop to coach sellers on lighting/angles.
3. **WhatsApp Policy:** Strict 24-hour session rules and template approvals will dictate notification architecture.
4. **Attribution Gaps:** WhatsApp ordering limits clean pixel conversion tracking. The ledger must flag attribution confidence.
5. **Audit Exposure:** The spend ledger must be an append-only, first-class financial system, not an afterthought.

---
*Document permanently stored in the project workspace for continuous alignment.*
