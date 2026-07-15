# Jami AI Architecture: Master Implementation Plan

This document details the exact technical architecture, data flow, and integration strategy for **Jami**, the conversational AI assistant for Homemade CEO, utilizing WhatsApp, Sarvam AI, and Claude.

## 1. Core Philosophy: The Orchestration Layer
Jami is **not** a free-running AI chatbot. She is a highly controlled Orchestration Layer managed by a deterministic **State Machine**. This ensures auditability, prevents hallucination, and strictly enforces business logic (like margin validation).

## 2. Component Roles
* **WhatsApp Business API (The Mouth/Ears):** Captures raw text, voice notes, and images from the seller and delivers Jami's responses.
* **Backend Server (The Traffic Controller):** A Node.js/Python server that handles webhooks, manages the state machine, interacts with the database, and calls external APIs (Sarvam/Claude).
* **Sarvam API (The Translator):** Specialized Indic-language Speech-to-Text (STT). Responsible *only* for converting noisy Malayalam voice notes into accurate text.
* **Claude 3.5 Haiku (The Brain):** An LLM responsible for reading the text, extracting structured JSON data (e.g., costs, product names), and generating natural, warm Malayalam responses based on strict State Machine prompts.

## 3. The State Machine Architecture
Every seller interaction is tied to a specific state in the database. Claude is given a different system prompt depending on the current state.
**Key States:**
1. `ONBOARDING`: Capturing name, location, and KYC details.
2. `COURSE_DELIVERY`: Nudging the seller to finish LMS modules.
3. `PRODUCT_INTAKE`: Collecting product photos and descriptions.
4. `MARGIN_VALIDATION`: (Strict Gate) Prompting for raw materials, packaging, and labor costs until a ≥100% margin is mathematically achieved.
5. `SUPPORT`: Routing queries to the Ops team.

## 4. Step-by-Step Data Flow (Example: Margin Validation)

**Phase A: Ingestion**
1. **User Action:** Seller sends a Malayalam voice note on WhatsApp: *"My packaging cost is 20 rupees."*
2. **Webhook Trigger:** WhatsApp sends a webhook to our Backend Server with the audio file URL.
3. **Download:** Backend Server downloads the `.ogg` or `.mp4` audio file.

**Phase B: Transcription**
4. **STT API Call:** Backend Server sends the audio file to **Sarvam API**.
5. **STT Response:** Sarvam returns the Malayalam text transcript (e.g., "പാക്കേജിംഗിന് 20 രൂപ ചിലവായി").

**Phase C: Orchestration & Extraction**
6. **State Lookup:** Backend Server checks the database and identifies the seller is in the `MARGIN_VALIDATION` state, specifically waiting for `packaging_cost`.
7. **LLM API Call:** Backend Server sends a structured prompt to **Claude 3.5 Haiku**:
   * *System Prompt:* "You are Jami. The seller is validating margins. They are telling you their packaging cost. Extract the cost as an integer in JSON format. Then write a warm Malayalam response asking for their labor time."
   * *User Input:* "പാക്കേജിംഗിന് 20 രൂപ ചിലവായി"
8. **LLM Response:** Claude returns:
   * **Extracted Data:** `{"packaging_cost": 20}`
   * **Generated Text:** `"മനസ്സിലായി! ഇത് ഉണ്ടാക്കാൻ എത്ര സമയമെടുത്തു?"`

**Phase D: Execution & Delivery**
9. **Database Update:** Backend Server saves `packaging_cost: 20` into the seller's database record.
10. **Delivery:** Backend Server sends Claude's Malayalam text response to the WhatsApp API.
11. **Final Step:** WhatsApp delivers the message to the seller's phone.

## 5. Engineering Best Practices & Risk Mitigation
* **Stateless LLM:** Claude must be treated as stateless. The Backend Server must inject the relevant conversation history into the prompt for every single API call to maintain context.
* **Fallback Mechanisms:** If Sarvam fails to transcribe a highly garbled voice note, the Backend Server must gracefully bypass Claude and send a hardcoded WhatsApp template: *"I couldn't hear that clearly, could you try recording it again?"*
* **JSON Enforcement:** Claude API calls must use `response_format: { type: "json_object" }` or strict system prompting to ensure the extracted business data never breaks the server parsing logic.
