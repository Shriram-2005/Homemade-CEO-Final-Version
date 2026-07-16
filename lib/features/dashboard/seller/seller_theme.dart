import 'package:flutter/material.dart';

/// Seller & Buyer Dashboard — Warm Navy/Gold/Cream theme
/// As specified in PAGES.md: "Dignified, warm, aspirational"
class SellerTheme {
  // ── Background ──────────────────────────────────────────────────────────
  static const Color bgPage     = Color(0xFFFDFBF7); // Warm cream
  static const Color bgCard     = Color(0xFFFFFFFF); // Pure white cards
  static const Color bgSurface  = Color(0xFFF7F4EE); // Slightly warm surface
  static const Color bgGold     = Color(0xFFFBF6E9); // Gold-tinted surface

  // ── Primary Navy ─────────────────────────────────────────────────────────
  static const Color navy       = Color(0xFF0A1128); // Deep navy
  static const Color navyLight  = Color(0xFF162041); // Slightly lighter navy

  // ── Accent Gold ──────────────────────────────────────────────────────────
  static const Color gold       = Color(0xFFD4A24E); // Warm gold (brand)
  static const Color goldDeep   = Color(0xFFB8862F); // Darker gold for text
  static const Color goldSoft   = Color(0xFFF9EDD4); // Very soft gold bg

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF0A1128); // Navy as primary text
  static const Color textSecondary = Color(0xFF4A5568); // Mid grey
  static const Color textMuted     = Color(0xFF9CA3AF); // Light grey

  // ── Status ───────────────────────────────────────────────────────────────
  static const Color statusGreen  = Color(0xFF059669);
  static const Color statusOrange = Color(0xFFEA580C);
  static const Color statusRed    = Color(0xFFDC2626);
  static const Color statusBlue   = Color(0xFF2563EB);

  // ── Border ───────────────────────────────────────────────────────────────
  static const Color borderLight = Color(0xFFE8E2D6); // Warm border
  static const Color borderGold  = Color(0xFFDFC08A); // Gold border

  // ── Typography ───────────────────────────────────────────────────────────
  static TextStyle get heading1 => const TextStyle(
    fontSize: 28, fontWeight: FontWeight.bold, color: navy, letterSpacing: -0.5,
  );

  static TextStyle get heading2 => const TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold, color: navy,
  );

  static TextStyle get heading3 => const TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600, color: navy,
  );

  static TextStyle get bodyText => const TextStyle(
    fontSize: 14, color: textSecondary, height: 1.5,
  );

  static TextStyle get caption => const TextStyle(
    fontSize: 12, color: textMuted,
  );

  static TextStyle get goldBold => const TextStyle(
    fontSize: 14, fontWeight: FontWeight.bold, color: goldDeep,
  );

  // ── Card Shadow ───────────────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> get goldShadow => [
    BoxShadow(
      color: gold.withValues(alpha: 0.18),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // ── Card Decoration ───────────────────────────────────────────────────────
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: bgCard,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderLight),
    boxShadow: cardShadow,
  );

  static BoxDecoration get goldCardDecoration => BoxDecoration(
    color: goldSoft,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderGold.withValues(alpha: 0.5)),
    boxShadow: goldShadow,
  );

  // ── Status Helper ─────────────────────────────────────────────────────────
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live': case 'active': case 'paid': case 'completed': case 'resolved': case 'delivered': return statusGreen;
      case 'pending': case 'processing': case 'in transit': return statusOrange;
      case 'needs better photo': case 'paused': case 'rejected': return statusRed;
      default: return statusBlue;
    }
  }

  static Widget statusChip(String label) {
    final color = statusColor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
