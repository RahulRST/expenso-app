import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
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

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.title});

  final String title;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Username: ${snapshot.data['username']}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Name: ${snapshot.data['name']}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Address: ${snapshot.data['address']}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Contact: ${snapshot.data['contact']}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        } else {
          print(snapshot);
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
