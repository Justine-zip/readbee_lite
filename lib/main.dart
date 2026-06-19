import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/core/layouts/orientation_manager.dart';
import 'package:readbee_lite/core/layouts/responsive.dart';
import 'package:readbee_lite/core/themes/app_theme.dart';
import 'package:readbee_lite/viewmodels/providers/theme_provider.dart';
import 'package:readbee_lite/views/startup/splash_screen_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vwpcsfuytvymxhahfmun.supabase.co',
    anonKey: 'sb_publishable_iLDvUdz4hQoqrZq3GKKlaQ_4CHlxAhX',
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return OrientationManager(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: theme,
        home: const Responsive(
          mobile: MobileSplashScreenPage(),
          tablet: TabletSplashScreenPage(),
        ),
      ),
    );
  }
}
