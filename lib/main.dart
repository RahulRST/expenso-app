import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home.dart';
import 'login.dart';
import 'register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: "/", pageBuilder: (context, state) {
        return const MaterialPage(
          child: MyLoginPage(title: "Login"),
        );
      }),
      GoRoute(path: "/register", pageBuilder: (context, state) {
        return const MaterialPage(
          child: MyRegisterPage(title: "Register"),
        );
      }),
      GoRoute(
        path: "/home",
      pageBuilder: (context, state) {
        return const MaterialPage(
          child: MyHomePage(title: "Flutter App"),
      );}
      )
    ]
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
