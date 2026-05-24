import 'package:flutter/material.dart';
import 'package:readbee_lite/layouts/main_layout.dart';
import 'package:readbee_lite/layouts/responsive.dart';
import 'package:readbee_lite/pages/auth/login_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const MobileMainLayout(),
      tablet: const TabletLoginPage(),
    );
  }
}
