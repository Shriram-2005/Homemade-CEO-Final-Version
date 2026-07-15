# Homemade CEO — Project Timeline (AI-Assisted Solo Developer)

The original technical brief estimated a 16-week timeline for a traditional agency team. However, by leveraging an AI coding assistant to handle boilerplate code, architecture structuring, and rapid UI generation, this timeline is significantly compressed for a single developer.

**Total Estimated Time:** 8 to 12 Weeks (2 to 3 Months)

---

## Phase 1: The Brain & Backend Foundation (Weeks 1–3)
**Focus:** Infrastructure, Jami Orchestration, and Speech-to-Text testing.
* **Setup:** Provision Supabase (Database/Storage) and Google Cloud Run (Backend Server).
* **Integrations:** Connect the Interakt (WhatsApp API), Claude 3.5 Haiku (LLM), and Sarvam (STT) APIs to the backend.
* **Core Logic:** Build the State Machine logic for Jami's onboarding flow and Margin Validation calculator.
* **Testing:** Rigorous testing of the Sarvam API with actual Malayalam voice notes (focusing on regional dialects and background noise).

## Phase 2: The Flutter Dashboards & Content (Weeks 4–6)
**Focus:** Web UI, Landing Pages, and Payments.
* **Dashboard Build:** Develop the Seller Dashboard and Admin Dashboard using Flutter Web (Riverpod for state management, GoRouter for navigation).
* **Content Pipeline:** Build the automated engine to generate the static Product Landing Pages and Ad Posters.
* **Payments:** Integrate Razorpay/Cashfree for the WhatsApp-to-UPI checkout flow.

## Phase 3: LMS & Margin Enforcement (Weeks 7–8)
**Focus:** Marketplace gating and education.
* **LMS Integration:** Add video players and quizzes to the Flutter Seller Dashboard.
* **Logic Wiring:** Wire the course completion states directly into Jami's brain, ensuring sellers cannot access the `PRODUCT_INTAKE` state until they pass the final quiz.

## Phase 4: Ads Integration & The Immutable Ledger (Weeks 9–10)
**Focus:** Audit compliance and Meta integration.
* **Ledger Build:** Construct the government-grade, append-only Spend Ledger in Supabase to track every rupee spent on Meta Ads.
* **Meta API:** Integrate the Meta Marketing API to pull campaign data (impressions, clicks, spend) directly into the Admin Dashboard.
* **ROI Logic:** Implement the stall/scale logic that automatically pauses failing ad campaigns.

## Phase 5: End-to-End Rigorous Testing (Weeks 11–12)
**Focus:** Security, stability, and bug fixing.
* **Simulation:** Run complete, simulated loops from a fake buyer clicking an ad, to paying on WhatsApp, to the revenue split updating on the Seller's dashboard.
* **Audit Checks:** Ensure the Spend Ledger strictly complies with government tracking requirements.
* **Policy Review:** Final check of DPDP Act 2023 compliance (consent capture) and WhatsApp 24-hour messaging policy rules.
