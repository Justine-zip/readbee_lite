import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/layouts/responsive.dart';
import 'package:readbee_lite/pages/auth/login_page.dart';
import 'package:readbee_lite/pages/auth/status_page.dart';
import 'package:readbee_lite/providers/auth_service_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabase = ref.watch(authServicesProvider);

    return StreamBuilder<AuthState>(
      stream: supabase.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const StatusPage();
        } else {
          return Responsive(
            mobile: MobileLoginPage(authServices: supabase),
            tablet: const TabletLoginPage(),
          );
        }
      },
    );
  }
}
