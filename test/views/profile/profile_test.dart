import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:readbee_lite/components/profile_general_option.dart';
import 'package:readbee_lite/core/services/auth_services.dart';
import 'package:readbee_lite/models/profile.dart';
import 'package:readbee_lite/viewmodels/providers/auth_service_provider.dart';
import 'package:readbee_lite/viewmodels/providers/dark_mode_provider.dart';
import 'package:readbee_lite/viewmodels/providers/profile_provider.dart';
import 'package:readbee_lite/viewmodels/providers/theme_provider.dart';
import 'package:readbee_lite/views/profile/profile_page.dart';

import '../../helpers/test_helper.dart';

class MockAuthServices extends Mock implements AuthServices {}

void main() {
  late MockAuthServices mockAuth;

  setUp(() {
    mockAuth = MockAuthServices();
  });

  testWidgets('check if user is available', (tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          authServicesProvider.overrideWithValue(mockAuth),

          profileProvider.overrideWith(
            (ref) =>
                Profile(id: '1', fullName: 'test', email: 'test@gmail.com'),
          ),
        ],
        child: const MobileProfilePage(),
      ),
    );

    await tester.pump();

    expect(find.text('test@gmail.com'), findsOneWidget);
  });

  testWidgets('toggles dark mode when tapped', (tester) async {
    await tester.pumpWidget(
      createTestWidget(
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                return ProfileGeneralOption(
                  size: 16,
                  title: 'Dark Mode',
                  value: ref.watch(darkModeProvider),
                  onTap: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  isToggle: true,
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dark Mode'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ProfileGeneralOption)),
    );

    expect(container.read(darkModeProvider), isTrue);
  });
}
