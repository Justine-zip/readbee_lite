import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/pages/main_page.dart';
import 'package:readbee_lite/pages/startup/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileSplashScreenPage extends StatefulWidget {
  const MobileSplashScreenPage({super.key});

  @override
  State<MobileSplashScreenPage> createState() => _MobileSplashScreenPageState();
}

class _MobileSplashScreenPageState extends State<MobileSplashScreenPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isWhiteScreen = false;
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _controller.forward();
    });

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;

      setState(() {
        _isWhiteScreen = true;
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;

        setState(() {
          _showLogo = true;
        });

        Future.delayed(const Duration(seconds: 3), () async {
          if (!mounted) return;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hasShownOnBoarding', false);

          final hasShown = prefs.getBool('hasShownOnBoarding') ?? false;

          Widget nextPage =
              hasShown ? const MainPage() : const MobileOnboardingPage();

          Navigator.pushReplacement(
            context,
            PageAnimationTransition(
              page: nextPage,
              pageAnimationType: RightToLeftFadedTransition(),
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isWhiteScreen
              ? Container(
                color: Colors.white,
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    opacity: _showLogo ? 1 : 0,
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/splashscreen/ReadBee_Logo-NoBg.png',
                        width: 250,
                      ),
                    ),
                  ),
                ),
              )
              : Stack(
                children: [
                  Container(color: Colors.amber),
                  Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _controller.value * 30,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class TabletSplashScreenPage extends StatefulWidget {
  const TabletSplashScreenPage({super.key});

  @override
  State<TabletSplashScreenPage> createState() => _TabletSplashScreenPageState();
}

class _TabletSplashScreenPageState extends State<TabletSplashScreenPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isWhiteScreen = false;
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _controller.forward();
    });

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;

      setState(() {
        _isWhiteScreen = true;
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;

        setState(() {
          _showLogo = true;
        });

        Future.delayed(const Duration(seconds: 3), () async {
          if (!mounted) return;

          final prefs = await SharedPreferences.getInstance();
          final hasShown = prefs.getBool('hasShownOnBoarding') ?? false;

          Widget nextPage =
              hasShown ? const MainPage() : const TabletOnboardingPage();

          Navigator.pushReplacement(
            context,
            PageAnimationTransition(
              page: nextPage,
              pageAnimationType: RightToLeftFadedTransition(),
            ),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isWhiteScreen
              ? Container(
                color: Colors.white,
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    opacity: _showLogo ? 1 : 0,
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/splashscreen/ReadBee_Logo-NoBg.png',
                        width: 450,
                      ),
                    ),
                  ),
                ),
              )
              : Stack(
                children: [
                  Container(color: Colors.amber),
                  Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _controller.value * 50,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
