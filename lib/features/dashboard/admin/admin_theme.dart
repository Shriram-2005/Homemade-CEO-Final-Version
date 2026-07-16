import 'package:flutter/material.dart';

/// Admin Dashboard Light Theme — Professional SaaS aesthetic
class AdminTheme {
  // Background
  static const Color bgPage = Color(0xFFF4F6F9);
  static const Color bgGrey = Color(0xFFEFF2F7);
  static const Color bgSidebar = Color(0xFF1E2A3B);

  // Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Borders
  static const Color borderColor = Color(0xFFE5E7EB);

  // Accent Colors
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color accentGreen = Color(0xFF059669);
  static const Color accentGold = Color(0xFFD97706);
  static const Color accentPurple = Color(0xFF7C3AED);
  static const Color accentRed = Color(0xFFDC2626);
  static const Color accentOrange = Color(0xFFEA580C);
  static const Color accentCyan = Color(0xFF0891B2);

  // Typography
  static TextStyle get heading1 => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle get heading2 => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get bodyText => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle get caption => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );

  static TextStyle get labelBold => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  // Card Shadow
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Status Chips
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live': case 'active': case 'verified': case 'completed': case 'processed': case 'resolved': return accentGreen;
      case 'pending': case 'lms in-progress': case 'unlocked': return accentBlue;
      case 'paused': case 'kyc pending': return accentOrange;
      case 'stalled': case 'rejected': case 'kyc rejected': return accentRed;
      case 'applied': return accentPurple;
      default: return textSecondary;
    }
  }

  static Widget statusChip(String label) {
    final color = statusColor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
