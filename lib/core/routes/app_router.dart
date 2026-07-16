import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/landing/landing_screen.dart';
import '../../features/story/story_screen.dart';
import '../../features/products/products_screen.dart';
import '../../features/dashboard/seller/seller_dashboard.dart';
import '../../features/dashboard/buyer/buyer_dashboard.dart';
import '../../features/dashboard/admin/admin_dashboard.dart';
import '../../features/auth/otp_auth_screen.dart';
import '../../features/auth/admin_login_screen.dart';

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
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      // ── Auth ──────────────────────────────────────────────────────────────
      GoRoute(
        path: '/auth/buyer',
        builder: (context, state) => const OtpAuthScreen(role: 'buyer'),
      ),
      GoRoute(
        path: '/auth/seller',
        builder: (context, state) => const OtpAuthScreen(role: 'seller'),
      ),
      GoRoute(
        path: '/auth/admin',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      // ── Dashboards ────────────────────────────────────────────────────────
      GoRoute(
        path: '/seller/dashboard',
        builder: (context, state) => const SellerDashboard(),
      ),
      GoRoute(
        path: '/buyer/dashboard',
        builder: (context, state) => const BuyerDashboard(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
  );
}
