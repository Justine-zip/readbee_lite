import 'package:flutter/material.dart';
import 'package:readbee_lite/components/profile_general_option.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  ProfileGeneralOption(title: 'Account', onTap: () {}),
                  ProfileGeneralOption(
                    title: 'Show Assistant',
                    onTap: () {},
                    isToggle: true,
                    value: false,
                  ),
                  ProfileGeneralOption(
                    title: 'Show Transcript',
                    onTap: () {},
                    isToggle: true,
                    value: true,
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
