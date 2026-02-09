import 'package:flutter/material.dart';
import 'package:readbee_lite/pages/record_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
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
            Center(
              child: Text(
                'M A T E R I A L',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
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
            Center(
              child: Text(
                'P R O F I L E',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(12),
            child: const TabBar(
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
      ),
    );
  }
}
