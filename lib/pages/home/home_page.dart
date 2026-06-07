import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/analytics_provider.dart';
import 'package:readbee_lite/providers/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

class MobileHomePage extends ConsumerStatefulWidget {
  const MobileHomePage({super.key});

  @override
  ConsumerState<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends ConsumerState<MobileHomePage> {
  final GlobalKey nameKey = GlobalKey();
  final GlobalKey readingSpeedKey = GlobalKey();
  final GlobalKey chartKey = GlobalKey();

  Future<void> showShowcase(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final hasShown = prefs.getBool('hasShownHomeShowcase') ?? false;

    if (!hasShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(
          context,
        ).startShowCase([nameKey, readingSpeedKey, chartKey]);
      });

      await prefs.setBool('hasShownHomeShowcase', true);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showShowcase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final readingSpeeds = ref.watch(readingSpeedProvider);
    final filter = ref.watch(analyticsFilterProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileProvider);
          ref.invalidate(readingSpeedProvider);
          ref.invalidate(readingLevelProvider);
          ref.invalidate(comprehensionLevelProvider);

          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Showcase(
                  key: nameKey,
                  title: 'Welcome to ReadBee!',
                  titleTextStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  descTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  description:
                      'This is your username and a motivational quote to keep you inspired.',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileAsync.when(
                          data: (profile) {
                            debugPrint('ProfileName: ${profile?.fullName}');
                            return Text(
                              profile?.fullName ?? 'Guest',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                          loading:
                              () => Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.amber,
                                child: const Text(
                                  'ReadBee',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          error: (e, _) => const Text('Error'),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Every word read is a step toward a brighter mind. Let\'s keep going!',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filter.language ?? 'All Languages'} • '
                      '${filter.yearId ?? 'All Years'} • '
                      '${filter.quarterId ?? 'All Quarters'} • ',
                      style: const TextStyle(fontSize: 12),
                    ),

                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const AnalyticsFilterDialog(),
                        );
                      },
                      icon: const Icon(Icons.filter_alt_outlined, size: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reading Speed',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      readingSpeeds.when(
                        data: (data) {
                          int slow = 0;
                          int fast = 0;
                          int average = 0;
                          int struggling = 0;
                          int nonReader = 0;

                          for (final speed in data) {
                            switch (speed.toLowerCase()) {
                              case 'slow':
                                slow++;
                                break;

                              case 'fast':
                                fast++;
                                break;

                              case 'average':
                                average++;
                                break;

                              case 'struggling':
                                struggling++;
                                break;

                              case 'non-reader':
                                nonReader++;
                                break;
                            }
                          }

                          return Showcase(
                            key: readingSpeedKey,
                            title: 'Reading Speed',
                            description:
                                'This section shows the distribution of reading speeds among students.',
                            titleTextStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            descTextStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 220,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 65,
                                    left:
                                        (MediaQuery.of(context).size.width -
                                            (MediaQuery.of(context).size.width *
                                                .3)) /
                                        2,

                                    child: Image.asset(
                                      'assets/img/BeeLogo.png',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Positioned(
                                    left:
                                        (MediaQuery.of(context).size.width -
                                            (MediaQuery.of(context).size.width *
                                                .3)) /
                                        2,
                                    child: _MobileStatCard(
                                      value: slow.toString(),
                                      label: 'Slow',
                                    ),
                                  ),
                                  Positioned(
                                    top: 55,
                                    left: 50,
                                    child: _MobileStatCard(
                                      value: fast.toString(),
                                      label: 'Fast',
                                    ),
                                  ),
                                  Positioned(
                                    top: 55,
                                    right: 50,
                                    child: _MobileStatCard(
                                      value: nonReader.toString(),
                                      label: 'Non-reader',
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 25,
                                    left: 70,
                                    child: _MobileStatCard(
                                      value: average.toString(),
                                      label: 'Average',
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 25,
                                    right: 70,
                                    child: _MobileStatCard(
                                      value: struggling.toString(),
                                      label: 'Struggling',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },

                        loading: () {
                          return SizedBox(
                            width: double.infinity,
                            height: 220,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left:
                                        (MediaQuery.of(context).size.width -
                                            (MediaQuery.of(context).size.width *
                                                .3)) /
                                        2,
                                    child: const _MobileStatCardShimmer(),
                                  ),
                                  const Positioned(
                                    top: 55,
                                    left: 50,
                                    child: _MobileStatCardShimmer(),
                                  ),
                                  const Positioned(
                                    top: 55,
                                    right: 50,
                                    child: _MobileStatCardShimmer(),
                                  ),
                                  const Positioned(
                                    bottom: 25,
                                    left: 70,
                                    child: _MobileStatCardShimmer(),
                                  ),
                                  const Positioned(
                                    bottom: 25,
                                    right: 70,
                                    child: _MobileStatCardShimmer(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },

                        error: (e, _) => Center(child: Text(e.toString())),
                      ),

                      const SizedBox(height: 20),

                      Showcase(
                        key: chartKey,
                        title: 'Reading & Comprehension Levels',
                        description:
                            'These charts show the distribution of reading and comprehension levels among students. It helps you understand how your students are performing and identify how many need extra support.',
                        titleTextStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        descTextStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 375,
                            maxHeight: 400,
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * .8,
                            child: const Column(
                              children: [
                                Expanded(
                                  child: MobileReadingLevelChartCard(
                                    title: 'Reading Level',
                                  ),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: MobileComprehesionLevelChartCard(
                                    title: 'Comprehension Level',
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}

class _MobileStatCard extends StatelessWidget {
  final String value;
  final String label;

  const _MobileStatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .08,
      width: MediaQuery.of(context).size.width * .175,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Colors.black26),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF4B400),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

class _MobileStatCardShimmer extends StatelessWidget {
  const _MobileStatCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .08,
      width: MediaQuery.of(context).size.width * .175,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Container(color: Colors.white)],
      ),
    );
  }
}

class MobileReadingLevelChartCard extends ConsumerWidget {
  final String title;

  const MobileReadingLevelChartCard({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingLevels = ref.watch(readingLevelProvider);

    return Container(
      height: MediaQuery.of(context).size.height * .3,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(blurRadius: 2, offset: Offset(0, 1), color: Colors.black26),
        ],
      ),
      child: readingLevels.when(
        data: (data) {
          int frustration = 0;
          int instructional = 0;
          int independent = 0;

          for (final level in data) {
            switch (level.toLowerCase()) {
              case 'frustration':
                frustration++;
                break;

              case 'instructional':
                instructional++;
                break;

              case 'independent':
                independent++;
                break;
            }
          }

          final maxValue = [
            frustration,
            instructional,
            independent,
            50,
          ].reduce((a, b) => a > b ? a : b);

          Widget buildBar(int value, Color color) {
            final height =
                (value / maxValue) * (MediaQuery.of(context).size.height * .16);

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 30,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: Stack(
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MobileYAxisLabel('50'),
                        _MobileYAxisLabel('30'),
                        _MobileYAxisLabel('15'),
                        _MobileYAxisLabel('0'),
                      ],
                    ),

                    Positioned.fill(
                      left: 30,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(frustration, Colors.red),

                              const SizedBox(height: 10),

                              const Text(
                                'Frustration',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(instructional, Colors.orange),

                              const SizedBox(height: 10),

                              const Text(
                                'Instructional',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(independent, Colors.green),

                              const SizedBox(height: 10),

                              const Text(
                                'Independent',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },

        loading:
            () => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),

        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class MobileComprehesionLevelChartCard extends ConsumerWidget {
  final String title;

  const MobileComprehesionLevelChartCard({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comprehensionLevels = ref.watch(comprehensionLevelProvider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Colors.black26,
          ),
        ],
      ),
      child: comprehensionLevels.when(
        data: (data) {
          int frustration = 0;
          int instructional = 0;
          int independent = 0;

          for (final level in data) {
            switch (level.toLowerCase()) {
              case 'frustration':
                frustration++;
                break;
              case 'instructional':
                instructional++;
                break;
              case 'independent':
                independent++;
                break;
            }
          }

          final maxValue = [
            frustration,
            instructional,
            independent,
            50,
          ].reduce((a, b) => a > b ? a : b);

          Widget buildBar(int value, Color color) {
            final height =
                (value / maxValue) * (MediaQuery.of(context).size.height * .16);

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 30,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Stack(
                  children: [
                    // Y-axis labels
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MobileYAxisLabel('50'),
                        _MobileYAxisLabel('30'),
                        _MobileYAxisLabel('15'),
                        _MobileYAxisLabel('0'),
                      ],
                    ),

                    // Bars + X labels
                    Positioned.fill(
                      left: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(frustration, Colors.red),
                              const SizedBox(height: 10),
                              const Text(
                                'Frustration',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(instructional, Colors.orange),
                              const SizedBox(height: 10),
                              const Text(
                                'Instructional',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(independent, Colors.green),
                              const SizedBox(height: 10),
                              const Text(
                                'Independent',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },

        loading:
            () => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class _MobileYAxisLabel extends StatelessWidget {
  final String text;

  const _MobileYAxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontSize: 10)),
      ),
    );
  }
}

class TabletHomePage extends ConsumerStatefulWidget {
  const TabletHomePage({super.key});

  @override
  ConsumerState<TabletHomePage> createState() => _TabletHomePageState();
}

class _TabletHomePageState extends ConsumerState<TabletHomePage> {
  final GlobalKey nameKey = GlobalKey();
  final GlobalKey readingSpeedKey = GlobalKey();
  final GlobalKey chartKey = GlobalKey();

  Future<void> showShowcase(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final hasShown = prefs.getBool('hasShownHomeShowcase') ?? false;

    if (!hasShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(
          context,
        ).startShowCase([nameKey, readingSpeedKey, chartKey]);
      });

      await prefs.setBool('hasShownHomeShowcase', true);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showShowcase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final readingSpeeds = ref.watch(readingSpeedProvider);
    final filter = ref.watch(analyticsFilterProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileProvider);
          ref.invalidate(readingSpeedProvider);
          ref.invalidate(readingLevelProvider);
          ref.invalidate(comprehensionLevelProvider);

          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Showcase(
                  key: nameKey,
                  title: 'Welcome to ReadBee!',
                  description:
                      'This is your username and a motivational quote to keep you inspired.',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileAsync.when(
                          data: (profile) {
                            debugPrint('ProfileName: ${profile?.fullName}');
                            return Text(
                              profile?.fullName ?? 'Guest',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                          loading:
                              () => Shimmer.fromColors(
                                baseColor: Colors.white,
                                highlightColor: Colors.amber,
                                child: const Text(
                                  'ReadBee',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          error: (e, _) => const Text('Error'),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Every word read is a step toward a brighter mind. Let\'s keep going!',
                          style: TextStyle(color: Colors.white70, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filter.language ?? 'All Languages'} • '
                      '${filter.yearId ?? 'All Years'} • '
                      '${filter.quarterId ?? 'All Quarters'} • ',
                      style: const TextStyle(fontSize: 24),
                    ),

                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const AnalyticsFilterDialog(),
                        );
                      },
                      icon: const Icon(Icons.filter_alt_outlined),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reading Speed',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      readingSpeeds.when(
                        data: (data) {
                          int slow = 0;
                          int fast = 0;
                          int average = 0;
                          int struggling = 0;
                          int nonReader = 0;

                          for (final speed in data) {
                            switch (speed.toLowerCase()) {
                              case 'slow':
                                slow++;
                                break;

                              case 'fast':
                                fast++;
                                break;

                              case 'average':
                                average++;
                                break;

                              case 'struggling':
                                struggling++;
                                break;

                              case 'non-reader':
                                nonReader++;
                                break;
                            }
                          }

                          return Showcase(
                            key: readingSpeedKey,
                            title: 'Reading Speed',
                            description:
                                'This section shows the distribution of reading speeds among students.',
                            child: Row(
                              children: [
                                Expanded(
                                  child: _TabletStatCard(
                                    value: slow.toString(),
                                    label: 'Slow',
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: _TabletStatCard(
                                    value: fast.toString(),
                                    label: 'Fast',
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: _TabletStatCard(
                                    value: struggling.toString(),
                                    label: 'Struggling',
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: _TabletStatCard(
                                    value: average.toString(),
                                    label: 'Average',
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: _TabletStatCard(
                                    value: nonReader.toString(),
                                    label: 'Non-reader',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                        loading: () {
                          return Row(
                            children: List.generate(5, (index) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: index == 4 ? 0 : 14,
                                  ),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      height:
                                          MediaQuery.of(context).size.height *
                                          .2,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 40,
                                            color: Colors.white,
                                          ),
                                          const Spacer(),
                                          Container(
                                            height: 12,
                                            width: 60,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },

                        error: (e, _) => Center(child: Text(e.toString())),
                      ),

                      const SizedBox(height: 20),

                      Showcase(
                        key: chartKey,
                        title: 'Reading & Comprehension Levels',
                        description:
                            'These charts show the distribution of reading and comprehension levels among students. It helps you understand how your students are performing and identify those who may need extra support.',
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .3,
                          child: const Row(
                            children: [
                              Expanded(
                                child: TabletReadingLevelChartCard(
                                  title: 'Reading Level',
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: TabletComprehesionLevelChartCard(
                                  title: 'Comprehension Level',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabletStatCard extends StatelessWidget {
  final String value;
  final String label;

  const _TabletStatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF4B400),
              fontSize: 68,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class TabletReadingLevelChartCard extends ConsumerWidget {
  final String title;

  const TabletReadingLevelChartCard({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingLevels = ref.watch(readingLevelProvider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Colors.black26,
          ),
        ],
      ),
      child: readingLevels.when(
        data: (data) {
          int frustration = 0;
          int instructional = 0;
          int independent = 0;

          for (final level in data) {
            switch (level.toLowerCase()) {
              case 'frustration':
                frustration++;
                break;

              case 'instructional':
                instructional++;
                break;

              case 'independent':
                independent++;
                break;
            }
          }

          final maxValue = [
            frustration,
            instructional,
            independent,
            50,
          ].reduce((a, b) => a > b ? a : b);

          Widget buildBar(int value, Color color) {
            final height =
                (value / maxValue) * (MediaQuery.of(context).size.height * .16);

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 60,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Stack(
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _TabletYAxisLabel('50'),
                        _TabletYAxisLabel('30'),
                        _TabletYAxisLabel('15'),
                        _TabletYAxisLabel('0'),
                      ],
                    ),

                    Positioned.fill(
                      left: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(frustration, Colors.red),

                              const SizedBox(height: 10),

                              const Text(
                                'Frustration',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(instructional, Colors.orange),

                              const SizedBox(height: 10),

                              const Text(
                                'Instructional',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(independent, Colors.green),

                              const SizedBox(height: 10),

                              const Text(
                                'Independent',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },

        loading:
            () => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),

        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class TabletComprehesionLevelChartCard extends ConsumerWidget {
  final String title;

  const TabletComprehesionLevelChartCard({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comprehensionLevels = ref.watch(comprehensionLevelProvider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Colors.black26,
          ),
        ],
      ),
      child: comprehensionLevels.when(
        data: (data) {
          int frustration = 0;
          int instructional = 0;
          int independent = 0;

          for (final level in data) {
            switch (level.toLowerCase()) {
              case 'frustration':
                frustration++;
                break;
              case 'instructional':
                instructional++;
                break;
              case 'independent':
                independent++;
                break;
            }
          }

          final maxValue = [
            frustration,
            instructional,
            independent,
            50,
          ].reduce((a, b) => a > b ? a : b);

          Widget buildBar(int value, Color color) {
            final height =
                (value / maxValue) * (MediaQuery.of(context).size.height * .16);

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 60,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Stack(
                  children: [
                    // Y-axis labels
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _TabletYAxisLabel('50'),
                        _TabletYAxisLabel('30'),
                        _TabletYAxisLabel('15'),
                        _TabletYAxisLabel('0'),
                      ],
                    ),

                    // Bars + X labels
                    Positioned.fill(
                      left: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(frustration, Colors.red),
                              const SizedBox(height: 10),
                              const Text(
                                'Frustration',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(instructional, Colors.orange),
                              const SizedBox(height: 10),
                              const Text(
                                'Instructional',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildBar(independent, Colors.green),
                              const SizedBox(height: 10),
                              const Text(
                                'Independent',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },

        loading:
            () => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class _TabletYAxisLabel extends StatelessWidget {
  final String text;

  const _TabletYAxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}

class AnalyticsFilterDialog extends ConsumerWidget {
  const AnalyticsFilterDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(analyticsFilterProvider);

    final years = ref.watch(schoolYearsProvider);
    final quarters = ref.watch(quartersProvider);
    final gradeLevels = ref.watch(gradeLevelsProvider);
    final languages = ref.watch(languagesProvider);

    return AlertDialog(
      title: const Text('Analytics Filters'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              languages.when(
                data: (data) {
                  return DropdownButtonFormField<String>(
                    initialValue: filter.language,
                    decoration: const InputDecoration(labelText: 'Language'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Languages'),
                      ),

                      ...data.map(
                        (e) => DropdownMenuItem(value: e, child: Text(e)),
                      ),
                    ],
                    onChanged: (value) {
                      ref.read(analyticsFilterProvider.notifier).state =
                          value == null
                              ? filter.copyWith(clearLanguage: true)
                              : filter.copyWith(language: value);
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),

              const SizedBox(height: 20),

              years.when(
                data: (data) {
                  return DropdownButtonFormField<String>(
                    initialValue: filter.yearId,
                    decoration: const InputDecoration(labelText: 'School Year'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Years'),
                      ),

                      ...data.map<DropdownMenuItem<String>>((e) {
                        final startYear = DateTime.parse(e['start_date']).year;

                        final endYear = DateTime.parse(e['end_date']).year;

                        return DropdownMenuItem<String>(
                          value: e['year_id'],
                          child: Text('$startYear-$endYear'),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      ref.read(analyticsFilterProvider.notifier).state =
                          value == null
                              ? filter.copyWith(clearYearId: true)
                              : filter.copyWith(yearId: value);
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),

              const SizedBox(height: 20),

              quarters.when(
                data: (data) {
                  return DropdownButtonFormField<int>(
                    initialValue: filter.quarterId,
                    decoration: const InputDecoration(labelText: 'Quarter'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Quarters'),
                      ),

                      ...data.map(
                        (e) => DropdownMenuItem(
                          value: e['quarter_id'],
                          child: Text(e['quarter_number']),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      ref.read(analyticsFilterProvider.notifier).state =
                          value == null
                              ? filter.copyWith(clearQuarterId: true)
                              : filter.copyWith(quarterId: value);
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),

              const SizedBox(height: 20),

              gradeLevels.when(
                data: (data) {
                  return DropdownButtonFormField<String>(
                    initialValue: filter.gradeLevelId,
                    decoration: const InputDecoration(labelText: 'Grade Level'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Grade Levels'),
                      ),

                      ...data.map(
                        (e) => DropdownMenuItem(
                          value: e['grade_level_id'],
                          child: Text('Grade ${e['grade_number']}'),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      ref.read(analyticsFilterProvider.notifier).state =
                          value == null
                              ? filter.copyWith(clearGradeLevelId: true)
                              : filter.copyWith(gradeLevelId: value);
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            ref.read(analyticsFilterProvider.notifier).state =
                const AnalyticsFilter();

            Navigator.pop(context);
          },
          child: const Text('Clear'),
        ),

        ElevatedButton(
          onPressed: () {
            ref.invalidate(readingSpeedProvider);
            ref.invalidate(readingLevelProvider);
            ref.invalidate(comprehensionLevelProvider);

            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
