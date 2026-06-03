import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/core/services/auth_services.dart';
import 'package:readbee_lite/layouts/main_layout.dart';

class TabletLoginPage extends StatefulWidget {
  const TabletLoginPage({super.key});

  @override
  State<TabletLoginPage> createState() => _TabletLoginPageState();
}

class _TabletLoginPageState extends State<TabletLoginPage> {
  AuthServices supabase = AuthServices();
  bool _obscurePassword = true;
  bool _isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late final AssetImage _loadingGif;

  @override
  void initState() {
    super.initState();
    _loadingGif = const AssetImage('assets/splashscreen/LoadingBee.gif');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(_loadingGif, context);
    });
  }

  @override
  void dispose() {
    _loadingGif.evict();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final minimumDelay = Future.delayed(const Duration(seconds: 1));
      final loginFuture = supabase.signInWithEmailPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final results = await Future.wait([loginFuture, minimumDelay]);
      final response = results[0];

      if (response.user != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TabletMainLayout(initialIndex: 0),
            ),
          );
        }
      } else {
        throw Exception('No user found.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid login credentials')),
        );
      }
      print('Login failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Center(
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.375,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Email', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 70,
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          hintText: 'ex: guest@gmail.com',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Password', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 70,
                      child: TextField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: '********',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (_) {}),
                        const Text(
                          'Remember me',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomButton(onTap: _handleLogin, title: 'Login'),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 45,
                    //   child: ElevatedButton(
                    //     onPressed: _handleLogin,
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.amber,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //     ),
                    //     child: const Text('Login'),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Image(
                  image: _loadingGif,
                  width: 200,
                  height: 200,
                  gaplessPlayback: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
