import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:readbee_lite/core/services/auth_services.dart';
import 'package:readbee_lite/pages/auth/login_page.dart';

import '../../helpers/test_helper.dart';

class MockAuthServices extends Mock implements AuthServices {}

void main() {
  late MockAuthServices mockAuth;

  setUp(() {
    mockAuth = MockAuthServices();
  });

  Widget createWidget() {
    return createTestWidget(child: MobileLoginPage(authServices: mockAuth));
  }

  group('MobileLoginPage', () {
    testWidgets('renders login form correctly', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('Login'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('password visibility toggles', (tester) async {
      await tester.pumpWidget(createWidget());

      TextField passwordField = tester.widget<TextField>(
        find.byType(TextField).at(1),
      );

      expect(passwordField.obscureText, true);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      passwordField = tester.widget<TextField>(find.byType(TextField).at(1));

      expect(passwordField.obscureText, false);
    });

    testWidgets('user can enter email and password', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextField).at(0), 'test@gmail.com');

      await tester.enterText(find.byType(TextField).at(1), 'password123');

      expect(find.text('test@gmail.com'), findsOneWidget);

      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('login button calls auth service', (tester) async {
      when(() => mockAuth.signInWithEmailPassword(any(), any())).thenAnswer((
        _,
      ) async {
        throw Exception('Fake login');
      });

      await tester.pumpWidget(createWidget());

      await tester.enterText(find.byType(TextField).at(0), 'test@gmail.com');

      await tester.enterText(find.byType(TextField).at(1), 'password123');

      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      verify(
        () => mockAuth.signInWithEmailPassword('test@gmail.com', 'password123'),
      ).called(1);

      expect(find.text('Invalid login credentials'), findsOneWidget);
    });
  });
}
