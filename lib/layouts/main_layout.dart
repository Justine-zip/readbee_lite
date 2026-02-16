import 'package:flutter/material.dart';
import 'package:readbee_lite/components/prompt_box.dart';
import 'package:readbee_lite/pages/profile_page.dart';
import 'package:readbee_lite/pages/reading_material_page.dart';
import 'package:readbee_lite/pages/record_page.dart';

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
                  ReadingMaterialPage(),
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
                  ProfilePage(),
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
  const TabletMainLayout({super.key});

  @override
  State<TabletMainLayout> createState() => _TabletMainLayoutState();
}

class _TabletMainLayoutState extends State<TabletMainLayout> {
  int selectedIndex = 0;

  final pages = const [ReadingMaterialPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    debugPrint('Layout: Tablet');

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected:
                (index) => setState(() => selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.book),
                label: Text("Books"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text("Profile"),
              ),
            ],
          ),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
