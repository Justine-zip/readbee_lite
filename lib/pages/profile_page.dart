import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/profile_general_option.dart';
import 'package:readbee_lite/providers/theme_provider.dart';

class MobileProfilePage extends ConsumerWidget {
  const MobileProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Text(
              'Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.amber,
                  child: Text('Img'),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Guest#4153'), Text('guest#@gmail.com')],
                ),
              ],
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'R E A D B E E',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'General',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ProfileGeneralOption(
                    size: 18,
                    title: 'Account',
                    onTap: () {},
                  ),
                  ProfileGeneralOption(
                    size: 18,
                    title: 'Show Assistant',
                    onTap: () {},
                    isToggle: true,
                    value: false,
                  ),
                  ProfileGeneralOption(
                    size: 18,
                    title: 'Show Transcript',
                    onTap: () {},
                    isToggle: true,
                    value: true,
                  ),
                  ProfileGeneralOption(
                    size: 18,
                    title: 'Dark Mode',
                    value: ref.watch(themeProvider) == ThemeMode.dark,
                    onTap: () {
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                    isToggle: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabletProfilePage extends ConsumerWidget {
  const TabletProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25),
                        Text(
                          'PROFILE',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 50, // bigger for tablet
                              backgroundColor: Colors.amber,
                              child: Text('Img'),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Guest#4153',
                                  style: TextStyle(fontSize: 24),
                                ),
                                Text(
                                  'guest#@gmail.com',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'R E A D B E E',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 40),

                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),

                        Text(
                          'General',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ProfileGeneralOption(
                          size: 22,
                          title: 'Account',
                          onTap: () {},
                        ),
                        ProfileGeneralOption(
                          size: 22,
                          title: 'Show Assistant',
                          onTap: () {},
                          isToggle: true,
                          value: false,
                        ),
                        ProfileGeneralOption(
                          size: 22,
                          title: 'Show Transcript',
                          onTap: () {},
                          isToggle: true,
                          value: true,
                        ),
                        ProfileGeneralOption(
                          size: 22,
                          title: 'Dark Mode',
                          value: ref.watch(themeProvider) == ThemeMode.dark,
                          onTap: () {
                            ref.read(themeProvider.notifier).toggleTheme();
                          },
                          isToggle: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
