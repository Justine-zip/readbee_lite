import 'package:flutter/material.dart';
import 'package:readbee_lite/core/services/auth_services.dart';
import 'package:readbee_lite/layouts/responsive.dart';
import 'package:readbee_lite/pages/auth/login_page.dart';
import 'package:readbee_lite/pages/auth/status_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    AuthServices supabase = AuthServices();

    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
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
