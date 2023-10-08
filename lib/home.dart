import 'package:expenso/profile.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

final storage = LocalStorage("secure_storage");

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.notifications)),
                Tab(icon: Icon(Icons.person)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.home),
              Icon(Icons.notifications),
              MyProfilePage()
            ],
          ),
        ),
      ),
    );
  }
}
