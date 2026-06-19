import 'package:flutter/material.dart';
import 'package:readbee_lite/components/prompt_box.dart';
import 'package:readbee_lite/views/event/event_page.dart';
import 'package:readbee_lite/views/home/home_page.dart';
import 'package:readbee_lite/views/profile/profile_page.dart';
import 'package:readbee_lite/views/reading_material/reading_material_page.dart';
import 'package:readbee_lite/views/record/record_page.dart';
import 'package:showcaseview/showcaseview.dart';

class MobileMainLayout extends StatefulWidget {
  final int? initialIndex;
  const MobileMainLayout({super.key, this.initialIndex = 0});

  @override
  State<MobileMainLayout> createState() => _MobileMainLayoutState();
}

class _MobileMainLayoutState extends State<MobileMainLayout> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Layout: Mobilexs');
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showDialog(
          context: context,
          builder:
              (context) => PromptBox(
                title: 'Are you sure you want to Exit?',
                onConfirm: () => debugPrint('Exited'),
              ),
        );
      },
      child: ShowCaseWidget(
        builder:
            (context) => DefaultTabController(
              initialIndex: widget.initialIndex ?? 0,
              length: 5,
              child: Stack(
                children: [
                  Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.surface,

                    body: const TabBarView(
                      children: [
                        MobileHomePage(),
                        MobileRecordPage(),
                        MobileReadingMaterialPage(),
                        MobileEventPage(),
                        MobileProfilePage(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 30,
                    left: 30,
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        labelColor: Colors.amber,
                        unselectedLabelColor:
                            Theme.of(context).colorScheme.secondary,
                        indicatorColor: Theme.of(context).colorScheme.surface,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: const [
                          Tab(icon: Icon(Icons.home)),
                          Tab(icon: Icon(Icons.file_copy_rounded)),
                          Tab(icon: Icon(Icons.book_online_rounded)),
                          Tab(icon: Icon(Icons.calendar_month_rounded)),
                          Tab(icon: Icon(Icons.person_2_rounded)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

class TabletMainLayout extends StatefulWidget {
  final int? initialIndex;

  const TabletMainLayout({super.key, this.initialIndex = 0});

  @override
  State<TabletMainLayout> createState() => _TabletMainLayoutState();
}

class _TabletMainLayoutState extends State<TabletMainLayout> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Layout: Tablet');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showDialog(
          context: context,
          builder:
              (context) => PromptBox(
                title: 'Are you sure you want to Exit?',
                onConfirm: () => debugPrint('Exited'),
              ),
        );
      },
      child: ShowCaseWidget(
        builder:
            (context) => DefaultTabController(
              length: 5,
              initialIndex: widget.initialIndex ?? 0,
              child: Stack(
                children: [
                  Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.surface,

                    body: const TabBarView(
                      children: [
                        TabletHomePage(),
                        TabletRecordPage(),
                        TabletReadingMaterialPage(),
                        TabletEventPage(),
                        TabletProfilePage(),
                      ],
                    ),
                  ),
                  Positioned(
                    //top: 30,
                    bottom: 30,
                    left: 250,
                    right: 250,
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          labelColor: Colors.amber,
                          unselectedLabelColor:
                              Theme.of(context).colorScheme.secondary,
                          indicatorColor: Theme.of(context).colorScheme.surface,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: const [
                            Tab(icon: Icon(Icons.home)),
                            Tab(icon: Icon(Icons.file_copy_rounded)),
                            Tab(icon: Icon(Icons.book_online_rounded)),
                            Tab(icon: Icon(Icons.calendar_month_rounded)),
                            Tab(icon: Icon(Icons.person_2_rounded)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
