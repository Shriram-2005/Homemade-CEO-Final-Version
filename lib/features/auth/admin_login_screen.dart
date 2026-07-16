import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/language_provider.dart';
import '../../features/dashboard/seller/seller_theme.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  String? _error;
  bool _loading = false;

  // Demo credentials
  static const _demoEmail = 'admin@homemadeceo.com';
  static const _demoPassword = 'admin123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() { _error = null; _loading = true; });
    await Future.delayed(const Duration(milliseconds: 800));

    if (_emailController.text.trim() == _demoEmail &&
        _passwordController.text == _demoPassword) {
      if (mounted) context.go('/admin/dashboard');
    } else {
      setState(() {
        _error = 'Invalid credentials. Use the demo credentials shown below.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageProvider();

    return ListenableBuilder(
      listenable: lang,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A1128),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ── Dark navy hero ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back
                        GestureDetector(
                          onTap: () => context.go('/landing'),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Shield icon
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: SellerTheme.gold.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(color: SellerTheme.gold.withValues(alpha: 0.3)),
                          ),
                          child: const Icon(Icons.admin_panel_settings_outlined, color: SellerTheme.gold, size: 38),
                        ),
                        const SizedBox(height: 22),

                        const Text(
                          'Admin Portal',
                          style: TextStyle(color: SellerTheme.gold, fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Restricted access — authorised personnel only.',
                          style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  // ── Form card ──────────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: SellerTheme.bgPage,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: SellerTheme.borderLight),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 30, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Demo credentials hint
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: SellerTheme.goldSoft,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: SellerTheme.borderGold.withValues(alpha: 0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                const Icon(Icons.info_outline_rounded, size: 14, color: SellerTheme.goldDeep),
                                const SizedBox(width: 6),
                                Text('Demo Credentials', style: SellerTheme.goldBold.copyWith(fontSize: 12)),
                              ]),
                              const SizedBox(height: 8),
                              _credRow(Icons.email_outlined, _demoEmail),
                              const SizedBox(height: 4),
                              _credRow(Icons.lock_outlined, _demoPassword),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Email
                        Text('Email Address', style: SellerTheme.heading3),
                        const SizedBox(height: 10),
                        _inputField(
                          controller: _emailController,
                          hint: _demoEmail,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 18),

                        // Password
                        Text('Password', style: SellerTheme.heading3),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: SellerTheme.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _error != null ? SellerTheme.statusRed.withValues(alpha: 0.5) : SellerTheme.borderLight, width: 1.5),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Icon(Icons.lock_outlined, color: SellerTheme.textMuted, size: 18),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: !_showPassword,
                                  style: const TextStyle(color: SellerTheme.textPrimary, fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText: '••••••••',
                                    hintStyle: TextStyle(color: SellerTheme.textMuted),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _showPassword = !_showPassword),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Icon(
                                    _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: SellerTheme.textMuted, size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (_error != null) ...[
                          const SizedBox(height: 10),
                          Row(children: [
                            const Icon(Icons.error_outline, size: 14, color: SellerTheme.statusRed),
                            const SizedBox(width: 6),
                            Flexible(child: Text(_error!, style: const TextStyle(color: SellerTheme.statusRed, fontSize: 12))),
                          ]),
                        ],

                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SellerTheme.navy,
                              foregroundColor: SellerTheme.gold,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: _loading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: SellerTheme.gold))
                                : const Text('Sign In to Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _credRow(IconData icon, String value) {
    return Row(children: [
      Icon(icon, size: 12, color: SellerTheme.goldDeep),
      const SizedBox(width: 6),
      Text(value, style: const TextStyle(color: SellerTheme.navy, fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: SellerTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _error != null ? SellerTheme.statusRed.withValues(alpha: 0.5) : SellerTheme.borderLight, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Icon(icon, color: SellerTheme.textMuted, size: 18)),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(color: SellerTheme.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: SellerTheme.textMuted),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
