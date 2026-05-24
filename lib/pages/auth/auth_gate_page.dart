import 'package:flutter/material.dart';
import 'package:readbee_lite/layouts/main_layout.dart';
import 'package:readbee_lite/layouts/responsive.dart';
import 'package:readbee_lite/pages/auth/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
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
          return Responsive(
            mobile: MobileMainLayout(),
            tablet: TabletMainLayout(),
          );
        } else {
          return TabletLoginPage();
        }
      },
    );
  }
}
