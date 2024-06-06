import 'package:erpmobile/Services/AutheService.dart';
import 'package:erpmobile/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JWT Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationWrapper(),
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
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AuthService().Logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AuthenticationWrapper()),
            );
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
