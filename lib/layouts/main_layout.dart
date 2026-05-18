import 'package:flutter/material.dart';
import 'package:readbee_lite/components/prompt_box.dart';
import 'package:readbee_lite/pages/event/event_page.dart';
import 'package:readbee_lite/pages/profile/profile_page.dart';
import 'package:readbee_lite/pages/reading_material/reading_material_page.dart';
import 'package:readbee_lite/pages/record/record_page.dart';

class MobileMainLayout extends StatefulWidget {
  const MobileMainLayout({super.key});

  @override
  State<MobileMainLayout> createState() => _MobileMainLayoutState();
}

class _MobileMainLayoutState extends State<MobileMainLayout> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Layout: Mobile');
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
      child: DefaultTabController(
        length: 5,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,

              body: const TabBarView(
                children: [
                  Center(
                    child: Text(
                      'H O M E',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  RecordPage(),
                  MobileReadingMaterialPage(),
                  Center(
                    child: Text(
                      'E V E N T',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
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
                  unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                  indicatorColor: Theme.of(context).colorScheme.surface,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
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
      child: DefaultTabController(
        length: 5,
        initialIndex: widget.initialIndex ?? 0,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,

              body: const TabBarView(
                children: [
                  Center(
                    child: Text(
                      'H O M E',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  RecordPage(),
                  TabletReadingMaterialPage(),
                  EventPage(),
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
                    tabs: [
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
    );
  }
}
