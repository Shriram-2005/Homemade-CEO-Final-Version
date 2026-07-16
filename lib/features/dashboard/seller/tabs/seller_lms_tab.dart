import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/providers/course_provider.dart';
import '../seller_theme.dart';

/// Unskippable, un-fast-forwardable LMS tab.
/// Each module has a mandatory watch timer. The progress bar is read-only.
/// Page-visibility-aware: timer pauses when browser tab is hidden (via WidgetsBindingObserver).
/// Developer bypass: a hidden text field at the very bottom accepts 'HOMECEO_DEV' to complete all modules.
class SellerLmsTab extends StatefulWidget {
  const SellerLmsTab({super.key});

  @override
  State<SellerLmsTab> createState() => _SellerLmsTabState();
}

class _SellerLmsTabState extends State<SellerLmsTab> with WidgetsBindingObserver {
  final _course = CourseProvider();
  final _devController = TextEditingController();
  String? _devError;
  bool _devSuccess = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _devController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _course,
      builder: (context, _) {
        final lang = LanguageProvider();
        final modules = _course.modules;
        final completed = _course.completedCount;
        final total = _course.totalCount;
        final progress = _course.progress;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Progress Banner ──────────────────────────────────────
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
                            style: const TextStyle(color: SellerTheme.gold, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _course.allCoursesCompleted
                                ? lang.translate('🎉 All modules complete! You can start selling.', '🎉 എല്ലാ മൊഡ്യൂളുകളും പൂർത്തിയായി!')
                                : lang.translate('Complete all modules to unlock selling features', 'വിൽക്കാൻ എല്ലാ മൊഡ്യൂളും പൂർത്തിയാക്കുക'),
                            style: TextStyle(color: _course.allCoursesCompleted ? const Color(0xFF6EE7B7) : Colors.white54, fontSize: 12, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '$completed / $total ${lang.translate("modules complete", "മൊഡ്യൂൾ പൂർത്തി")}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: Colors.white.withValues(alpha: 0.12),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _course.allCoursesCompleted ? const Color(0xFF6EE7B7) : SellerTheme.gold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}% ${lang.translate("Complete", "പൂർത്തി")}${_course.allCoursesCompleted ? " ✅" : " 🌟"}',
                            style: TextStyle(
                              color: _course.allCoursesCompleted ? const Color(0xFF6EE7B7) : SellerTheme.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 80, height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 7,
                            backgroundColor: Colors.white.withValues(alpha: 0.12),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _course.allCoursesCompleted ? const Color(0xFF6EE7B7) : SellerTheme.gold,
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(color: SellerTheme.gold, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Sell Gate Warning ──────────────────────────────────────────
              if (!_course.allCoursesCompleted)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: SellerTheme.statusOrange.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: SellerTheme.statusOrange.withValues(alpha: 0.3)),
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.lock_outline_rounded, color: SellerTheme.statusOrange, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          lang.translate(
                            'Products & Payments tabs are locked until you complete all course modules. Complete each module by watching it fully.',
                            'എല്ലാ കോഴ്‌സ് മൊഡ്യൂളുകളും പൂർത്തിയാക്കുന്നതുവരെ ഉൽപ്പന്നങ്ങളും പേയ്‌മെന്റ് ടാബുകളും ലോക്ക് ചെയ്‌തിരിക്കുന്നു.',
                          ),
                          style: SellerTheme.bodyText.copyWith(fontSize: 12, height: 1.5),
                        ),
                      ),
                    ]),
                  ),
                ),

              const SizedBox(height: 20),

              // ── Modules Label ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Container(width: 4, height: 18, decoration: BoxDecoration(color: SellerTheme.gold, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 10),
                  Text(lang.translate('Course Modules', 'കോഴ്‌സ് മൊഡ്യൂളുകൾ'), style: SellerTheme.heading2),
                ]),
              ),

              const SizedBox(height: 14),

              // ── Module Cards ───────────────────────────────────────────────
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: modules.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return _ModuleCard(
                    module: module,
                    index: index,
                    lang: lang,
                    onCompleted: () => _course.completeModule(module['id']),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ── Certificate ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CertificateCard(lang: lang, isUnlocked: _course.allCoursesCompleted, progress: progress),
              ),

              // ── DEV BYPASS (last item, testing only) ─────────────────────
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _DevBypassSection(
                  controller: _devController,
                  error: _devError,
                  success: _devSuccess,
                  lang: lang,
                  onSubmit: () {
                    final ok = _course.applyDevBypass(_devController.text);
                    setState(() {
                      _devError = ok ? null : 'Invalid bypass code.';
                      _devSuccess = ok;
                    });
                  },
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

// ── Individual Module Card ─────────────────────────────────────────────────────

class _ModuleCard extends StatelessWidget {
  final Map<String, dynamic> module;
  final int index;
  final LanguageProvider lang;
  final VoidCallback onCompleted;

  const _ModuleCard({
    required this.module,
    required this.index,
    required this.lang,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = module['status'] == 'Locked';
    final isCompleted = module['status'] == 'Completed';

    final Color accentColor = isCompleted
        ? SellerTheme.statusGreen
        : (isLocked ? SellerTheme.textMuted : SellerTheme.gold);
    final IconData dotIcon = isCompleted
        ? Icons.check_circle_rounded
        : (isLocked ? Icons.lock_rounded : Icons.play_circle_fill_rounded);

    Color bgCard = SellerTheme.bgCard;
    if (isCompleted) bgCard = const Color(0xFFF0FBF5);

    return Opacity(
      opacity: isLocked ? 0.58 : 1.0,
      child: GestureDetector(
        onTap: isLocked
            ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(lang.translate('Complete previous modules first.', 'ആദ്യം മുൻ മൊഡ്യൂളുകൾ പൂർത്തിയാക്കുക.')),
                  backgroundColor: SellerTheme.navy,
                ))
            : () => _openPlayer(context),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: bgCard,
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
                    lang.translate('${module['duration']} min · Must watch fully', '${module['duration']} മിനിറ്റ് · പൂർണ്ണമായി കാണണം'),
                    style: SellerTheme.caption.copyWith(fontSize: 10),
                  ),
                ]),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isCompleted
                    ? SellerTheme.statusGreen.withValues(alpha: 0.10)
                    : (isLocked ? SellerTheme.bgSurface : SellerTheme.goldSoft),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCompleted
                      ? SellerTheme.statusGreen.withValues(alpha: 0.3)
                      : (isLocked ? SellerTheme.borderLight : SellerTheme.borderGold.withValues(alpha: 0.4)),
                ),
              ),
              child: Text(
                isCompleted
                    ? lang.translate('Done', 'പൂർത്തി')
                    : (isLocked ? lang.translate('Locked', 'ലോക്ക്') : lang.translate('Watch', 'കാണുക')),
                style: TextStyle(
                  color: isCompleted ? SellerTheme.statusGreen : (isLocked ? SellerTheme.textMuted : SellerTheme.goldDeep),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _openPlayer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false, // cannot dismiss mid-watch
      enableDrag: false,
      builder: (_) => _CoursePlayerSheet(
        module: module,
        index: index,
        lang: lang,
        onCompleted: onCompleted,
      ),
    );
  }
}

// ── Unskippable Course Player ─────────────────────────────────────────────────

class _CoursePlayerSheet extends StatefulWidget {
  final Map<String, dynamic> module;
  final int index;
  final LanguageProvider lang;
  final VoidCallback onCompleted;

  const _CoursePlayerSheet({
    required this.module,
    required this.index,
    required this.lang,
    required this.onCompleted,
  });

  @override
  State<_CoursePlayerSheet> createState() => _CoursePlayerSheetState();
}

class _CoursePlayerSheetState extends State<_CoursePlayerSheet> with WidgetsBindingObserver {
  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  bool _playing = false;
  bool _completed = false;
  bool _tabHidden = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _totalSeconds = (widget.module['duration'] as int) * 60;
    _remainingSeconds = _totalSeconds;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause when app goes to background / hidden tab
    if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) {
      _pauseTimer();
      setState(() => _tabHidden = true);
    } else if (state == AppLifecycleState.resumed) {
      setState(() => _tabHidden = false);
      // Don't auto-resume — user must press play again
    }
  }

  void _startTimer() {
    setState(() { _playing = true; _tabHidden = false; });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          t.cancel();
          _playing = false;
          _completed = true;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    if (mounted) setState(() => _playing = false);
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _progress => 1.0 - (_remainingSeconds / _totalSeconds);

  void _finish() {
    widget.onCompleted();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: SellerTheme.bgPage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: SellerTheme.borderLight, borderRadius: BorderRadius.circular(2)),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lang.translate('Module ${widget.index + 1}', 'മൊഡ്യൂൾ ${widget.index + 1}'), style: SellerTheme.caption),
                  const SizedBox(height: 4),
                  Text(widget.module['title'], style: SellerTheme.heading1),

                  const SizedBox(height: 20),

                  // Tab hidden warning
                  if (_tabHidden)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: SellerTheme.statusRed.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: SellerTheme.statusRed.withValues(alpha: 0.3)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.warning_amber_rounded, color: SellerTheme.statusRed, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            lang.translate('Timer paused — tab was hidden. Press ▶ to resume.', 'ടാബ് മറഞ്ഞതിനാൽ ടൈമർ നിർത്തി. ▶ അമർത്തി തുടരുക.'),
                            style: TextStyle(color: SellerTheme.statusRed, fontSize: 12),
                          ),
                        ),
                      ]),
                    ),

                  // Video player mock
                  AspectRatio(
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
                      child: _completed
                          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(color: SellerTheme.statusGreen.withValues(alpha: 0.15), shape: BoxShape.circle),
                                child: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF6EE7B7), size: 56),
                              ),
                              const SizedBox(height: 12),
                              Text(lang.translate('Module Complete! 🎉', 'മൊഡ്യൂൾ പൂർത്തി! 🎉'),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            ])
                          : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              GestureDetector(
                                onTap: _playing ? _pauseTimer : _startTimer,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(_playing ? 14 : 18),
                                  decoration: BoxDecoration(
                                    color: SellerTheme.gold.withValues(alpha: _playing ? 0.1 : 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                                    color: SellerTheme.gold,
                                    size: _playing ? 52 : 64,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  const Icon(Icons.timer_outlined, color: SellerTheme.gold, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    _playing
                                        ? lang.translate('${_formatTime(_remainingSeconds)} remaining', '${_formatTime(_remainingSeconds)} ബാക്കി')
                                        : lang.translate('Tap ▶ to ${_remainingSeconds == _totalSeconds ? "start" : "resume"}', '▶ ടാപ്പ് ചെയ്ത് ${_remainingSeconds == _totalSeconds ? "ആരംഭിക്കുക" : "തുടരുക"}'),
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ]),
                              ),
                            ]),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Progress bar (READ-ONLY — cannot seek)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          lang.translate('Watch Progress', 'കാഴ്ച പുരോഗതി'),
                          style: SellerTheme.caption,
                        ),
                        const Spacer(),
                        Row(children: [
                          const Icon(Icons.lock_outline, size: 11, color: SellerTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(lang.translate('Cannot skip', 'സ്കിപ്പ് ചെയ്യാൻ കഴിയില്ല'), style: SellerTheme.caption.copyWith(fontSize: 10)),
                        ]),
                      ]),
                      const SizedBox(height: 8),
                      IgnorePointer( // ← progress bar is completely non-interactive
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 8,
                            backgroundColor: SellerTheme.bgSurface,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _completed ? SellerTheme.statusGreen : SellerTheme.gold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${(_progress * 100).toStringAsFixed(0)}% ${lang.translate("watched", "കണ്டു")} · ${_formatTime(_remainingSeconds)} ${lang.translate("left", "ബാക്കി")}',
                        style: SellerTheme.caption.copyWith(fontSize: 10),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Unskippable notice
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: SellerTheme.navy.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SellerTheme.borderLight),
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.info_outline_rounded, color: SellerTheme.navy, size: 15),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          lang.translate(
                            'This module is mandatory and cannot be skipped or fast-forwarded. The timer pauses if you switch tabs.',
                            'ഈ മൊഡ്യൂൾ നിർബന്ധമാണ്. ടാബ് മാറ്റിയാൽ ടൈമർ നിർത്തും.',
                          ),
                          style: SellerTheme.bodyText.copyWith(fontSize: 12, height: 1.5),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom CTA ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(children: [
              if (_completed)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _finish,
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                    label: Text(widget.lang.translate('Mark Complete & Continue', 'പൂർത്തിയായി & തുടരുക'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SellerTheme.statusGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SellerTheme.textSecondary,
                      side: BorderSide(color: SellerTheme.borderLight),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(widget.lang.translate('Exit (progress saved)', 'Exit (പുരോഗതി സൂക്ഷിക്കുന്നു)'),
                      style: const TextStyle(fontSize: 14)),
                  ),
                ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Certificate Card ──────────────────────────────────────────────────────────

class _CertificateCard extends StatelessWidget {
  final LanguageProvider lang;
  final bool isUnlocked;
  final double progress;

  const _CertificateCard({required this.lang, required this.isUnlocked, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: isUnlocked
            ? const LinearGradient(colors: [SellerTheme.navy, SellerTheme.navyLight], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
        color: isUnlocked ? null : SellerTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked ? SellerTheme.gold.withValues(alpha: 0.4) : SellerTheme.borderLight,
          width: isUnlocked ? 1.5 : 1,
        ),
        boxShadow: isUnlocked
            ? [BoxShadow(color: SellerTheme.gold.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 6))]
            : null,
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnlocked ? SellerTheme.gold.withValues(alpha: 0.15) : SellerTheme.bgSurface,
            shape: BoxShape.circle,
            border: Border.all(color: isUnlocked ? SellerTheme.gold.withValues(alpha: 0.35) : SellerTheme.borderLight),
          ),
          child: Icon(
            isUnlocked ? Icons.workspace_premium_rounded : Icons.lock_outline_rounded,
            color: isUnlocked ? SellerTheme.gold : SellerTheme.textMuted,
            size: 30,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              lang.translate('Completion Certificate', 'പൂർണ്ണ സർട്ടിഫിക്കറ്റ്'),
              style: TextStyle(
                color: isUnlocked ? SellerTheme.gold : SellerTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isUnlocked
                  ? lang.translate('Congratulations! Download your certificate.', 'അഭിനന്ദനങ്ങൾ! സർട്ടിഫിക്കറ്റ് ഡൗൺലോഡ് ചെയ്യുക.')
                  : lang.translate('Complete ${((1 - progress) * 100).toStringAsFixed(0)}% more to unlock', 'അൺലോക്ക് ചെയ്യാൻ ${((1 - progress) * 100).toStringAsFixed(0)}% കൂടി'),
              style: TextStyle(
                color: isUnlocked ? Colors.white70 : SellerTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ]),
        ),
        if (isUnlocked)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: SellerTheme.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.download_outlined, color: SellerTheme.gold, size: 20),
          ),
      ]),
    );
  }
}

// ── DEV Bypass Section ────────────────────────────────────────────────────────

class _DevBypassSection extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final bool success;
  final LanguageProvider lang;
  final VoidCallback onSubmit;

  const _DevBypassSection({
    required this.controller,
    required this.error,
    required this.success,
    required this.lang,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    if (success) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0), style: BorderStyle.solid),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.construction_outlined, size: 14, color: Color(0xFF999999)),
          const SizedBox(width: 6),
          const Text(
            'DEVELOPER TESTING ONLY',
            style: TextStyle(color: Color(0xFF999999), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
        ]),
        const SizedBox(height: 10),
        Text(
          lang.translate('Enter bypass code to skip all modules (for testing)', 'ടെസ്റ്റിംഗിനായി എല്ലാ മൊഡ്യൂളുകളും ഒഴിവാക്കാൻ ബൈപ്പാസ് കോഡ് നൽകുക'),
          style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13, letterSpacing: 2),
              decoration: InputDecoration(
                hintText: '••••••••••',
                hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: error != null ? SellerTheme.statusRed : const Color(0xFFDDDDDD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF333333),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Apply', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ]),
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(error!, style: const TextStyle(color: SellerTheme.statusRed, fontSize: 11)),
        ],
      ]),
    );
  }
}
