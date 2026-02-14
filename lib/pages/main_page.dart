import 'package:flutter/material.dart';
import 'package:readbee_lite/components/prompt_box.dart';
import 'package:readbee_lite/pages/profile_page.dart';
import 'package:readbee_lite/pages/reading_material_page.dart';
import 'package:readbee_lite/pages/record_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Colors.white,

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
                color: Colors.white,
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  labelColor: Colors.amber,
                  unselectedLabelColor: Colors.black38,
                  indicatorColor: Colors.white,
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
