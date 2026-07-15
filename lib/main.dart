import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/localization/language_provider.dart';

void main() {
  runApp(const HomemadeCeoApp());
}

class HomemadeCeoApp extends StatelessWidget {
  const HomemadeCeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageProvider(),
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Homemade CEO',
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
