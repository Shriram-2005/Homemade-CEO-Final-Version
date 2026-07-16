import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../core/localization/language_provider.dart';
import '../../features/dashboard/seller/seller_theme.dart';

/// Shared OTP Auth Screen for both Buyer and Seller.
/// Pass [role] as 'buyer' or 'seller' to determine destination route.
class OtpAuthScreen extends StatefulWidget {
  final String role; // 'buyer' or 'seller'
  const OtpAuthScreen({super.key, required this.role});

  @override
  State<OtpAuthScreen> createState() => _OtpAuthScreenState();
}

class _OtpAuthScreenState extends State<OtpAuthScreen> with TickerProviderStateMixin {
  // ── Phase control ──────────────────────────────────────────────────────────
  bool _otpSent = false;
  String _phone = '';
  String _generatedOtp = '';

  // ── Phone entry ────────────────────────────────────────────────────────────
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();

  // ── OTP entry ──────────────────────────────────────────────────────────────
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocuses = List.generate(4, (_) => FocusNode());

  // ── Timer ──────────────────────────────────────────────────────────────────
  int _timerSeconds = 30;
  bool _canResend = false;
  late AnimationController _timerAnimController;

  // ── Error shake ────────────────────────────────────────────────────────────
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _timerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..addListener(() {
        final remaining = (30 * (1 - _timerAnimController.value)).ceil();
        if (remaining != _timerSeconds) {
          setState(() {
            _timerSeconds = remaining;
            if (remaining == 0) _canResend = true;
          });
        }
      });

    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocuses) f.dispose();
    _timerAnimController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _generateOtp() {
    final rand = Random();
    return List.generate(4, (_) => rand.nextInt(10)).join();
  }

  void _sendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      setState(() => _errorMsg = 'Enter a valid 10-digit mobile number');
      return;
    }
    final otp = _generateOtp();
    setState(() {
      _phone = phone;
      _generatedOtp = otp;
      _otpSent = true;
      _errorMsg = null;
      _timerSeconds = 30;
      _canResend = false;
    });
    _timerAnimController.forward(from: 0);
  }

  void _resendOtp() {
    if (!_canResend) return;
    final otp = _generateOtp();
    for (final c in _otpControllers) c.clear();
    setState(() {
      _generatedOtp = otp;
      _timerSeconds = 30;
      _canResend = false;
      _errorMsg = null;
    });
    _timerAnimController.forward(from: 0);
    _otpFocuses[0].requestFocus();
  }

  void _verifyOtp() {
    final entered = _otpControllers.map((c) => c.text).join();
    if (entered == _generatedOtp) {
      final dest = widget.role == 'buyer' ? '/buyer/dashboard' : '/seller/dashboard';
      context.go(dest);
    } else {
      setState(() => _errorMsg = LanguageProvider().translate('Invalid OTP. Please try again.', 'OTP തെറ്റാണ്. വീണ്ടും ശ്രമിക്കുക.'));
      _shakeController.forward(from: 0);
      for (final c in _otpControllers) c.clear();
      _otpFocuses[0].requestFocus();
    }
  }

  void _editNumber() {
    setState(() {
      _otpSent = false;
      _errorMsg = null;
      _timerAnimController.stop();
      for (final c in _otpControllers) c.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () => _phoneFocus.requestFocus());
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();
    final isBuyer = widget.role == 'buyer';
    final accentColor = isBuyer ? SellerTheme.navy : SellerTheme.navy;

    return ListenableBuilder(
      listenable: lang,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: SellerTheme.bgPage,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ── Hero Header ────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
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
                        // Back button
                        GestureDetector(
                          onTap: () => context.go('/landing'),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Icon
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: SellerTheme.gold.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.35)),
                          ),
                          child: Icon(
                            isBuyer ? Icons.shopping_bag_outlined : Icons.storefront_outlined,
                            color: SellerTheme.gold,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          isBuyer
                              ? lang.translate('Buyer Sign In', 'ബയർ സൈൻ ഇൻ')
                              : lang.translate('Seller Sign In', 'സെല്ലർ സൈൻ ഇൻ'),
                          style: const TextStyle(
                            color: SellerTheme.gold,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _otpSent
                              ? lang.translate('Enter the OTP sent to your WhatsApp', 'WhatsApp-ൽ ലഭിച്ച OTP നൽകുക')
                              : lang.translate('Enter your mobile number to continue', 'തുടരാൻ നിങ്ങളുടെ ഫോൺ നമ്പർ നൽകുക'),
                          style: const TextStyle(color: Colors.white60, fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  // ── Form ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(anim),
                          child: child,
                        ),
                      ),
                      child: _otpSent
                          ? _OtpForm(
                              key: const ValueKey('otp'),
                              phone: _phone,
                              generatedOtp: _generatedOtp,
                              otpControllers: _otpControllers,
                              otpFocuses: _otpFocuses,
                              timerSeconds: _timerSeconds,
                              canResend: _canResend,
                              errorMsg: _errorMsg,
                              shakeAnimation: _shakeAnimation,
                              onVerify: _verifyOtp,
                              onResend: _resendOtp,
                              onEditNumber: _editNumber,
                              lang: lang,
                              accentColor: accentColor,
                            )
                          : _PhoneForm(
                              key: const ValueKey('phone'),
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              errorMsg: _errorMsg,
                              onSend: _sendOtp,
                              lang: lang,
                              accentColor: accentColor,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Phone Entry Form ──────────────────────────────────────────────────────────

class _PhoneForm extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorMsg;
  final VoidCallback onSend;
  final LanguageProvider lang;
  final Color accentColor;

  const _PhoneForm({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.errorMsg,
    required this.onSend,
    required this.lang,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.translate('Mobile Number', 'മൊബൈൽ നമ്പർ'), style: SellerTheme.heading3),
        const SizedBox(height: 12),

        // Phone Input
        Container(
          decoration: BoxDecoration(
            color: SellerTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorMsg != null ? SellerTheme.statusRed.withValues(alpha: 0.5) : SellerTheme.borderLight,
              width: 1.5,
            ),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Row(
            children: [
              // Country code
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: SellerTheme.bgSurface,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                  border: Border(right: BorderSide(color: SellerTheme.borderLight)),
                ),
                child: Row(children: [
                  const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text('+91', style: TextStyle(color: SellerTheme.navy, fontWeight: FontWeight.bold, fontSize: 16)),
                ]),
              ),
              // Number field
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(color: SellerTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 2),
                  decoration: InputDecoration(
                    hintText: '98765 43210',
                    hintStyle: TextStyle(color: SellerTheme.textMuted, fontSize: 16, letterSpacing: 1, fontWeight: FontWeight.normal),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    counterText: '',
                  ),
                ),
              ),
            ],
          ),
        ),

        if (errorMsg != null) ...[
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.error_outline, size: 14, color: SellerTheme.statusRed),
            const SizedBox(width: 6),
            Text(errorMsg!, style: const TextStyle(color: SellerTheme.statusRed, fontSize: 12)),
          ]),
        ],

        const SizedBox(height: 28),

        // Send OTP Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onSend,
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
            label: Text(
              lang.translate('Get OTP on WhatsApp', 'WhatsApp-ൽ OTP നേടുക'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: SellerTheme.navy,
              foregroundColor: SellerTheme.gold,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),

        const SizedBox(height: 20),
        Center(
          child: Text(
            lang.translate('By continuing you agree to our Terms & Privacy Policy', 'തുടരുന്നതിലൂടെ നിങ്ങൾ ഞങ്ങളുടെ നിബന്ധനകൾ സമ്മതിക്കുന്നു'),
            textAlign: TextAlign.center,
            style: SellerTheme.caption,
          ),
        ),
      ],
    );
  }
}

// ── OTP Verification Form ─────────────────────────────────────────────────────

class _OtpForm extends StatelessWidget {
  final String phone;
  final String generatedOtp;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocuses;
  final int timerSeconds;
  final bool canResend;
  final String? errorMsg;
  final Animation<double> shakeAnimation;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onEditNumber;
  final LanguageProvider lang;
  final Color accentColor;

  const _OtpForm({
    super.key,
    required this.phone,
    required this.generatedOtp,
    required this.otpControllers,
    required this.otpFocuses,
    required this.timerSeconds,
    required this.canResend,
    required this.errorMsg,
    required this.shakeAnimation,
    required this.onVerify,
    required this.onResend,
    required this.onEditNumber,
    required this.lang,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final maskedPhone = phone.length >= 10
        ? '${phone.substring(0, 2)}XXXXXX${phone.substring(8)}'
        : phone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phone display + edit
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: SellerTheme.bgSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: SellerTheme.borderLight),
          ),
          child: Row(children: [
            const Text('🇮🇳', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text('+91 $maskedPhone', style: const TextStyle(color: SellerTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            GestureDetector(
              onTap: onEditNumber,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: SellerTheme.goldSoft,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.4)),
                ),
                child: Row(children: [
                  const Icon(Icons.edit_outlined, size: 13, color: SellerTheme.goldDeep),
                  const SizedBox(width: 4),
                  Text(lang.translate('Edit', 'മാറ്റുക'), style: const TextStyle(color: SellerTheme.goldDeep, fontSize: 12, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ]),
        ),

        const SizedBox(height: 20),

        // 🔔 Demo OTP hint banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.4)),
          ),
          child: Row(children: [
            const Icon(Icons.info_outline_rounded, color: SellerTheme.goldDeep, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: SellerTheme.caption.copyWith(fontSize: 13),
                  children: [
                    TextSpan(text: lang.translate('Demo OTP: ', 'ഡെമോ OTP: ')),
                    TextSpan(
                      text: generatedOtp,
                      style: const TextStyle(
                        color: SellerTheme.navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),

        const SizedBox(height: 24),

        Text(lang.translate('Enter 4-digit OTP', '4-അക്ക OTP നൽകുക'), style: SellerTheme.heading3),
        const SizedBox(height: 16),

        // OTP boxes
        AnimatedBuilder(
          animation: shakeAnimation,
          builder: (context, child) {
            final shake = Sin(shakeAnimation.value * pi * 4) * 12;
            return Transform.translate(
              offset: Offset(shake, 0),
              child: child,
            );
          },
          child: Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
                  child: _OtpBox(
                    controller: otpControllers[i],
                    focusNode: otpFocuses[i],
                    onChanged: (v) {
                      if (v.length == 1 && i < 3) {
                        otpFocuses[i + 1].requestFocus();
                      }
                      if (v.isEmpty && i > 0) {
                        otpFocuses[i - 1].requestFocus();
                      }
                      // Auto-submit when all filled
                      if (otpControllers.every((c) => c.text.length == 1)) {
                        Future.delayed(const Duration(milliseconds: 100), onVerify);
                      }
                    },
                    hasError: errorMsg != null,
                  ),
                ),
              );
            }),
          ),
        ),

        if (errorMsg != null) ...[
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.error_outline, size: 14, color: SellerTheme.statusRed),
            const SizedBox(width: 6),
            Flexible(child: Text(errorMsg!, style: const TextStyle(color: SellerTheme.statusRed, fontSize: 12))),
          ]),
        ],

        const SizedBox(height: 28),

        // Verify button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onVerify,
            style: ElevatedButton.styleFrom(
              backgroundColor: SellerTheme.navy,
              foregroundColor: SellerTheme.gold,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Text(
              lang.translate('Verify & Sign In', 'പരിശോധിച്ച് സൈൻ ഇൻ'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Timer / Resend
        Center(
          child: canResend
              ? GestureDetector(
                  onTap: onResend,
                  child: Text(
                    lang.translate('Resend OTP', 'OTP വീണ്ടും അയക്കുക'),
                    style: const TextStyle(
                      color: SellerTheme.goldDeep,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.timer_outlined, size: 14, color: SellerTheme.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    lang.translate('Resend in ${timerSeconds}s', '${timerSeconds} സെക്കൻഡിൽ OTP വീണ്ടും'),
                    style: SellerTheme.caption,
                  ),
                ]),
        ),
      ],
    );
  }
}

// ignore: non_constant_identifier_names
double Sin(double x) => sin(x);

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: SellerTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasError
              ? SellerTheme.statusRed.withValues(alpha: 0.6)
              : focusNode.hasFocus
                  ? SellerTheme.gold
                  : SellerTheme.borderLight,
          width: 1.8,
        ),
        boxShadow: focusNode.hasFocus
            ? [BoxShadow(color: SellerTheme.gold.withValues(alpha: 0.18), blurRadius: 10)]
            : null,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          color: SellerTheme.navy,
          fontSize: 26,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
