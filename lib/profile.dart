import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

final storage = LocalStorage("secure_storage");

Future fetchProfile() async {
  final res = await http.get(Uri.parse('http://localhost:5500/api/user'),
      headers: <String, String>{
        'Authorization': 'Bearer ${storage.getItem('token')}'
      });
  return jsonDecode(res.body)["data"];
}

class Profile {
  final String username;
  final String name;
  final String address;
  final String contact;

  const Profile({
    required this.username,
    required this.name,
    required this.address,
    required this.contact,
  });
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String username;
  final String address;
  final String contact;
  final IconData avatar;

  const ProfileCard({super.key, 
    required this.name,
    required this.username,
    required this.address,
    required this.contact,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 40.0,
          // backgroundImage: NetworkImage(avatarUrl),
          child: Icon(avatar),
        ),
        const SizedBox(height: 16.0),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          username,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          address,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          contact,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        )
      ],
    );
  }
}

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  void handleLogout() async {
    await storage.clear();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(fontSize: 20),
            ),
          );
        } else if (snapshot.hasData) {
          return Center(
              child: Container(
                  margin: const EdgeInsets.all(16.0),
                  // elevation: 4.0,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ProfileCard(
                              name: snapshot.data["name"],
                              username: snapshot.data["username"],
                              address: snapshot.data["address"],
                              contact: snapshot.data["contact"],
                              avatar: Icons.person,
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: handleLogout,
                              child: const Text('Logout'),
                            ),
                          ]))));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
