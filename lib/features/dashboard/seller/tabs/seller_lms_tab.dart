import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../../../../core/localization/language_provider.dart';
import '../seller_theme.dart';

class SellerLmsTab extends StatelessWidget {
  const SellerLmsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        final lang = LanguageProvider();
        final modules = MockData.lmsModules;
        final completed = modules.where((m) => m['status'] == 'Completed').length;
        final progress = completed / modules.length;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Progress Banner ───────────────────────────────────────
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.translate('Learn & Grow', 'പഠിക്കുക & വളരുക'),
                            style: const TextStyle(
                              color: SellerTheme.gold,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.translate('Complete modules to unlock full access', 'മൊഡ്യൂൾ പൂർത്തിയാക്കി ആക്‌സസ് നേടുക'),
                            style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '$completed / ${modules.length} ${lang.translate('modules complete', 'മൊഡ്യൂൾ പൂർത്തി')}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: Colors.white.withValues(alpha: 0.12),
                              valueColor: const AlwaysStoppedAnimation<Color>(SellerTheme.gold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}% ${lang.translate('Complete', 'പൂർത്തി')} 🌟',
                            style: const TextStyle(color: SellerTheme.gold, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Circular Progress Indicator
                    SizedBox(
                      width: 80, height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 7,
                            backgroundColor: Colors.white.withValues(alpha: 0.12),
                            valueColor: const AlwaysStoppedAnimation<Color>(SellerTheme.gold),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(color: SellerTheme.gold, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Modules Label ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(width: 4, height: 18, decoration: BoxDecoration(color: SellerTheme.gold, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 10),
                  Text(lang.translate('Modules', 'മൊഡ്യൂളുകൾ'), style: SellerTheme.heading2),
                ]),
              ),

              const SizedBox(height: 14),

              // ── Modules List ──────────────────────────────────────────────
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: modules.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final module = modules[index];
                  final isLocked = module['status'] == 'Locked';
                  final isCompleted = module['status'] == 'Completed';

                  final Color accentColor = isCompleted
                      ? SellerTheme.statusGreen
                      : (isLocked ? SellerTheme.textMuted : SellerTheme.gold);
                  final IconData dotIcon = isCompleted
                      ? Icons.check_circle_rounded
                      : (isLocked ? Icons.lock_rounded : Icons.play_circle_filled_rounded);

                  Color bgTint = SellerTheme.bgCard;
                  if (isCompleted) bgTint = const Color(0xFFF0FBF5);
                  if (isLocked) bgTint = const Color(0xFFF8F8F8);

                  return Opacity(
                    opacity: isLocked ? 0.60 : 1.0,
                    child: GestureDetector(
                      onTap: isLocked ? null : () => _showVideoPlayer(context, module, lang),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: bgTint,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCompleted
                                ? SellerTheme.statusGreen.withValues(alpha: 0.3)
                                : (isLocked ? SellerTheme.borderLight : SellerTheme.borderGold.withValues(alpha: 0.5)),
                            width: 1.5,
                          ),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
                        ),
                        child: Row(children: [
                          Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.10),
                              shape: BoxShape.circle,
                              border: Border.all(color: accentColor.withValues(alpha: 0.35)),
                            ),
                            child: Center(child: Icon(dotIcon, color: accentColor, size: 24)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                lang.translate('Module ${index + 1}', 'മൊഡ്യൂൾ ${index + 1}'),
                                style: SellerTheme.caption,
                              ),
                              const SizedBox(height: 3),
                              Text(module['title'], style: SellerTheme.heading3),
                              const SizedBox(height: 6),
                              Row(children: [
                                const Icon(Icons.access_time_outlined, size: 12, color: SellerTheme.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  lang.translate('${module['duration']} min', '${module['duration']} മിനിറ്റ്'),
                                  style: SellerTheme.caption,
                                ),
                              ]),
                            ]),
                          ),
                          SellerTheme.statusChip(lang.translate(module['status'], module['status'])),
                        ]),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  void _showVideoPlayer(BuildContext context, Map<String, dynamic> module, LanguageProvider lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: SellerTheme.bgPage,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: SellerTheme.borderLight),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: SellerTheme.borderLight, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(lang.translate('Module ${module['id']}', 'മൊഡ്യൂൾ ${module['id']}'), style: SellerTheme.caption),
              const SizedBox(height: 4),
              Text(module['title'], style: SellerTheme.heading1),
            ]),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [SellerTheme.navy, SellerTheme.navyLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.2)),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: SellerTheme.gold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_circle_fill_rounded, color: SellerTheme.gold, size: 64),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      lang.translate('${module['duration']} min · Tap to play', '${module['duration']} മിനിറ്റ്'),
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                lang.translate(
                  'Watch this module fully before taking the quiz. Skipping will void the completion record.',
                  'ക്വിസ് എടുക്കുന്നതിന് മുമ്പ് ഈ മൊഡ്യൂൾ പൂർണ്ണമായും കാണുക.',
                ),
                style: SellerTheme.bodyText.copyWith(height: 1.6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.quiz_outlined, size: 18),
                label: Text(lang.translate('Take Quiz', 'ക്വിസ് എടുക്കുക'), style: const TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SellerTheme.navy,
                  foregroundColor: SellerTheme.gold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
