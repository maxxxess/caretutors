// lib/splash/splash_screen.dart
import 'package:caretutors/providers/auth_provider.dart';
import 'package:caretutors/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLaunched = prefs.getBool('hasLaunched') ?? false;

    if (!hasLaunched) {
      await prefs.setBool('hasLaunched', true);
      // Show splash for a few seconds
      await Future.delayed(Duration(seconds: 5));
    }

    // Navigate based on auth state
    ref.read(goRouterProvider).go(ref.read(authStateProvider).value != null ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitFadingCircle(
            color: Colors.black,
            size: 150.0,
          ),
      ),
    );
  }
}
