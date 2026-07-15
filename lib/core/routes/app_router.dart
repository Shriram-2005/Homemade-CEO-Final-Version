import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/landing/landing_screen.dart';
import '../../features/story/story_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/story',
        builder: (context, state) => const StoryScreen(),
      ),
    ],
  );
}
