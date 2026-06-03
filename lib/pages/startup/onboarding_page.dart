import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late SharedPreferences prefs;
  Future<void> showOnBoarding(BuildContext context) async {
    final hasShown = prefs.getBool('hasShownOnBoarding') ?? false;

    if (hasShown) {
      Navigator.pushReplacement(
        context,
        PageAnimationTransition(
          page: const MainPage(),
          pageAnimationType: RightToLeftFadedTransition(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();

      await showOnBoarding(context);
    });
  }

  void _onDone(BuildContext context) async {
    await prefs.setBool('hasShownOnBoarding', true);

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      PageAnimationTransition(
        page: const MainPage(),
        pageAnimationType: RightToLeftFadedTransition(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        globalHeader: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/splashscreen/ReadBee_Logo-NoBg.png',
                width: 300,
              ),
            ),
          ),
        ),

        bodyPadding: const EdgeInsets.only(top: 350),

        pages: [
          PageViewModel(
            title: "Welcome to ReadBee",
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              bodyTextStyle: TextStyle(fontSize: 24, color: Colors.black87),
            ),
            body:
                "Discover engaging reading materials designed for every learner.",
            image: Image.asset(
              'assets/img/Intro_Book.jpg',
              height: 350,
              width: 350,
              fit: BoxFit.contain,
            ),
          ),
          PageViewModel(
            title: "Track Progress",
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              bodyTextStyle: TextStyle(fontSize: 24, color: Colors.black87),
            ),
            body:
                "Monitor reading achievements and improve comprehension skills.",
            image: Center(
              child: Image.asset(
                'assets/img/Intro_Dashboard.png',
                height: 350,
                width: 350,
                fit: BoxFit.contain,
              ),
            ),
          ),
          PageViewModel(
            title: "Start Learning",
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              bodyTextStyle: TextStyle(fontSize: 24, color: Colors.black87),
            ),
            body:
                "Explore stories, lessons, and activities tailored to your level.",
            image: Center(
              child: Image.asset(
                'assets/img/Intro_Mic.png',
                height: 350,
                width: 350,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],

        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Icon(Icons.arrow_forward),
        done: const Text(
          "Get Started",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        onDone: () => _onDone(context),
        onSkip: () => _onDone(context),

        dotsDecorator: DotsDecorator(
          activeColor: Colors.amber,
          size: const Size(10, 10),
          activeSize: const Size(24, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
