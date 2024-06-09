import 'package:erpmobile/Routing/app_router.dart';
import 'package:erpmobile/Routing/router_names.dart';
import 'package:erpmobile/Services/account_servie.dart';
import 'package:erpmobile/Services/authe_service.dart';
import 'package:erpmobile/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JWT Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: goRouter,
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  Future<bool> isAuthenticated() async {
    final auth = AuthService();
    var resutl = await auth.isAuthenticated();
    print("resutl is " + resutl.toString());
    return resutl;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen();
          } else {
            return LogIn();
          }
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await AuthService().Logout();
                context.goNamed(RouterNames.login);
              },
              child: const Text('Logout'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                var result = await Accountservie().getUserDetails();

                print('result is  $result');
              },
              child: const Text('fetuh details'),
            ),
          ),
        ],
      ),
    );
  }
}
