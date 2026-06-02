import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/profile_general_option.dart';
import 'package:readbee_lite/core/services/auth_services.dart';
import 'package:readbee_lite/pages/profile/account_details_page.dart';
import 'package:readbee_lite/providers/dark_mode_provider.dart';
import 'package:readbee_lite/providers/profile_provider.dart';
import 'package:readbee_lite/providers/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

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
            const SizedBox(height: 25),
            const Text(
              'Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Row(
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
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'R E A D B E E',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'General',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
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
    final authServices = AuthServices();
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: profileAsync.when(
            data: (profile) {
              debugPrint('ProfileName: ${profile?.fullName}');

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
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
                            const SizedBox(height: 25),
                            Text(
                              'PROFILE',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 50, // bigger for tablet
                                  backgroundColor: Colors.amber,
                                  child: Icon(Icons.person, size: 50),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile?.fullName ?? 'Guest#4153',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                      profile?.email ?? 'guest#@gmail.com',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(24.0),
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

                      const SizedBox(width: 40),

                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),

                            const Text(
                              'General',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ProfileGeneralOption(
                              size: 22,
                              title: 'Account',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageAnimationTransition(
                                    page: EditProfilePage(profile: profile),
                                    pageAnimationType: RightToLeftTransition(),
                                  ),
                                );
                              },
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
                              title: 'Dark Mode',
                              value: ref.watch(darkModeProvider),
                              onTap: () {
                                ref.read(themeProvider.notifier).toggleTheme();
                              },
                              isToggle: true,
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: InkWell(
                                onTap: () async {
                                  await authServices.signOut();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading:
                () => Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.amber,
                  child: const Column(
                    children: [
                      Text(
                        'ReadBee',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        'ReadBeeEmail',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
            error: (e, _) => const Text('Error'),
          ),
        ),
      ),
    );
  }
}
