import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/profile_provider.dart';
import 'package:readbee_lite/providers/analytics_provider.dart';
import 'package:shimmer/shimmer.dart';

class TabletHomePage extends ConsumerStatefulWidget {
  const TabletHomePage({super.key});

  @override
  ConsumerState<TabletHomePage> createState() => _TabletHomePageState();
}

class _TabletHomePageState extends ConsumerState<TabletHomePage> {
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
                Container(
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
                              child: Text(
                                'ReadBee',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        error: (e, _) => const Text('Error'),
                      ),
                      SizedBox(height: 8),
                      const Text(
                        'Every word read is a step toward a brighter mind. Let\'s keep going!',
                        style: TextStyle(color: Colors.white70, fontSize: 24),
                      ),
                    ],
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
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black54,
                      ),
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
                      Text(
                        'Reading Speed',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black54,
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

                          return Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  value: slow.toString(),
                                  label: 'Slow',
                                ),
                              ),
                              const SizedBox(width: 14),

                              Expanded(
                                child: _StatCard(
                                  value: fast.toString(),
                                  label: 'Fast',
                                ),
                              ),
                              const SizedBox(width: 14),

                              Expanded(
                                child: _StatCard(
                                  value: struggling.toString(),
                                  label: 'Struggling',
                                ),
                              ),
                              const SizedBox(width: 14),

                              Expanded(
                                child: _StatCard(
                                  value: average.toString(),
                                  label: 'Average',
                                ),
                              ),
                              const SizedBox(width: 14),

                              Expanded(
                                child: _StatCard(
                                  value: nonReader.toString(),
                                  label: 'Non-reader',
                                ),
                              ),
                            ],
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

                      SizedBox(
                        height: MediaQuery.of(context).size.height * .3,
                        child: Row(
                          children: const [
                            Expanded(
                              child: ReadingLevelChartCard(
                                title: 'Reading Level',
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: ComprehesionLevelChartCard(
                                title: 'Comprehension Level',
                              ),
                            ),
                          ],
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

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            style: const TextStyle(
              fontSize: 28,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ReadingLevelChartCard extends ConsumerWidget {
  final String title;

  const ReadingLevelChartCard({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingLevels = ref.watch(readingLevelProvider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            15,
          ].reduce((a, b) => a > b ? a : b);

          Widget buildBar(int value, Color color) {
            final height =
                (value / maxValue) * (MediaQuery.of(context).size.height * .16);

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
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
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _YAxisLabel('15'),
                        _YAxisLabel('10'),
                        _YAxisLabel('5'),
                        _YAxisLabel('0'),
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
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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

class ComprehesionLevelChartCard extends ConsumerWidget {
  final String title;

  const ComprehesionLevelChartCard({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comprehensionLevels = ref.watch(comprehensionLevelProvider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            15,
          ].reduce((a, b) => a > b ? a : b);

          Widget buildBar(int value, Color color) {
            final height =
                (value / maxValue) * (MediaQuery.of(context).size.height * .16);

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
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
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Stack(
                  children: [
                    // Y-axis labels
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _YAxisLabel('15'),
                        _YAxisLabel('10'),
                        _YAxisLabel('5'),
                        _YAxisLabel('0'),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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

class _YAxisLabel extends StatelessWidget {
  final String text;

  const _YAxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black45),
      ),
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
      backgroundColor: Colors.white,
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              languages.when(
                data: (data) {
                  return DropdownButtonFormField<String>(
                    value: filter.language,
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
                    value: filter.yearId,
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
                    value: filter.quarterId,
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
                    value: filter.gradeLevelId,
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
