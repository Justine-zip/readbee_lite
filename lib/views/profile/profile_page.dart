import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/profile_general_option.dart';
import 'package:readbee_lite/viewmodels/providers/auth_service_provider.dart';
import 'package:readbee_lite/viewmodels/providers/dark_mode_provider.dart';
import 'package:readbee_lite/viewmodels/providers/profile_provider.dart';
import 'package:readbee_lite/viewmodels/providers/theme_provider.dart';
import 'package:readbee_lite/views/profile/account_details_page.dart';
import 'package:shimmer/shimmer.dart';

class MobileProfilePage extends ConsumerWidget {
  const MobileProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authServices = ref.watch(authServicesProvider);
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: profileAsync.when(
            data: (profile) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        Text(
                          'PROFILE',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.amber,
                              child: Icon(Icons.person, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile?.fullName ?? 'Guest#4153',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  profile?.email ?? 'guest#@gmail.com',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 40),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),

                        const Text(
                          'General',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ProfileGeneralOption(
                          size: 16,
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
                          size: 16,
                          title: 'Dark Mode',
                          value: ref.watch(darkModeProvider),
                          onTap: () {
                            ref.read(themeProvider.notifier).toggleTheme();
                          },
                          isToggle: true,
                        ),
                        const Divider(),
                        const SizedBox(height: 50),
                        Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomButton(
                                  size: 200,
                                  boxColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainer,
                                  textColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  border: 1,
                                  vertSize: 50,
                                  tSize: 16,
                                  onTap: () async {
                                    await authServices.signOut();
                                  },
                                  title: 'Logout',
                                ),
                              ),
                              const Text(
                                'Version 0.11.14',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const Text(
                                'Terms of Service',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
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
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'ReadBeeEmail',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
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

class TabletProfilePage extends ConsumerWidget {
  const TabletProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authServices = ref.watch(authServicesProvider);
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
                            const ProfileGeneralOption(
                              size: 22,
                              title: 'Show Assistant',
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: InkWell(
                                  onTap: () async {
                                    await authServices.signOut();
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
