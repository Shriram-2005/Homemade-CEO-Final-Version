import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../core/localization/language_provider.dart';
import '../seller_theme.dart';

class SellerHelpTab extends StatelessWidget {
  const SellerHelpTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final tickets = MockData.supportTickets;
        final faqs = MockData.faqs;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Banner ────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SellerTheme.navy, SellerTheme.navyLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.translate('Help & Support', 'സഹായവും പിന്തുണയും'),
                      style: const TextStyle(
                        color: SellerTheme.gold,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lang.translate("We're here for you", 'ഞങ്ങൾ നിങ്ങൾക്കൊപ്പമുണ്ട്'),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 22),

                    // Quick Actions
                    Row(children: [
                      _quickAction(Icons.chat_bubble_outline_rounded, lang.translate('WhatsApp\nSupport', 'WhatsApp\nപിന്തുണ'), SellerTheme.statusGreen, () {}),
                      const SizedBox(width: 10),
                      _quickAction(Icons.phone_outlined, lang.translate('Call\nUs', 'ഞങ്ങളെ\nവിളിക്കുക'), const Color(0xFF60A5FA), () {}),
                      const SizedBox(width: 10),
                      _quickAction(Icons.report_outlined, lang.translate('File\nTicket', 'ടിക്കറ്റ്\nഫയൽ'), SellerTheme.gold, () {}),
                    ]),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Support Tickets ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [SellerTheme.goldSoft, Color(0xFFF5E6C8)]),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(Icons.support_agent_outlined, color: SellerTheme.goldDeep, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(lang.translate('My Support Tickets', 'എന്റെ ടിക്കറ്റുകൾ'), style: SellerTheme.heading2),
                ]),
              ),

              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tickets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  final isOpen = ticket['status'] == 'Open';
                  final statusColor = isOpen ? SellerTheme.statusOrange : SellerTheme.statusGreen;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: SellerTheme.bgCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: SellerTheme.borderLight),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                        ),
                        child: Icon(
                          isOpen ? Icons.pending_outlined : Icons.check_circle_outline_rounded,
                          color: statusColor, size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(ticket['subject'], style: SellerTheme.heading3),
                          const SizedBox(height: 4),
                          Text(ticket['date'], style: SellerTheme.caption),
                        ]),
                      ),
                      SellerTheme.statusChip(ticket['status']),
                    ]),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ── FAQs ──────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [SellerTheme.goldSoft, Color(0xFFF5E6C8)]),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(Icons.help_outline_rounded, color: SellerTheme.goldDeep, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(lang.translate('Frequently Asked', 'പതിവ് ചോദ്യങ്ങൾ'), style: SellerTheme.heading2),
                ]),
              ),

              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: faqs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: SellerTheme.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: SellerTheme.borderLight),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        iconColor: SellerTheme.goldDeep,
                        collapsedIconColor: SellerTheme.textMuted,
                        title: Text(
                          lang.translate(faq['questionEn']!, faq['questionMl']!),
                          style: SellerTheme.heading3,
                        ),
                        children: [
                          Text(
                            lang.translate(faq['answerEn']!, faq['answerMl']!),
                            style: SellerTheme.bodyText.copyWith(height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ── WhatsApp CTA ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [SellerTheme.goldSoft, Color(0xFFF5E6C8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.5)),
                    boxShadow: [BoxShadow(color: SellerTheme.gold.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SellerTheme.statusGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: SellerTheme.statusGreen.withValues(alpha: 0.25)),
                      ),
                      child: const Icon(Icons.chat_bubble_outline_rounded, color: SellerTheme.statusGreen, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(lang.translate('Still need help?', 'ഇനിയും സഹായം വേണോ?'), style: SellerTheme.heading3),
                        const SizedBox(height: 3),
                        Text(
                          lang.translate('Chat with our team on WhatsApp', 'WhatsApp-ൽ ഞങ്ങളുടെ ടീമുമായി ചാറ്റ്'),
                          style: SellerTheme.caption,
                        ),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: SellerTheme.navy.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.chevron_right_rounded, color: SellerTheme.navy, size: 20),
                    ),
                  ]),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _quickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600, height: 1.3),
            ),
          ]),
        ),
      ),
    );
  }
}
