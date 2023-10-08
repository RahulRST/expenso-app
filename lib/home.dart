import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

final storage = LocalStorage("secure_storage");

Future fetchUser() async {
  final res = await http
      .get(Uri.parse('http://localhost:5500/api/user'), headers: <String, String>{
        'Authorization': 'Bearer ${storage.getItem('token')}'
        });
  return jsonDecode(res.body)["data"];
}

class User {
  final String username;
  final String name;
  final String address;
  final String contact;

  const User({
    required this.username,
    required this.name,
    required this.address,
    required this.contact,
  });

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     username: json['username'] as String,
  //     name: json['name'] as String,
  //     address: json['address'] as String,
  //     contact: json['contact'] as String,
  //   );
  // }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(fontSize: 20),
              ),
            );
          } else if (snapshot.hasData) {
            print(snapshot.data);
            return UserList(user: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
    ));
  }
}

class UserList extends StatelessWidget {
  const UserList({Key? key, required this.user}) : super(key: key);

  final user;

  @override
  Widget build(BuildContext context) {
        return ListTile(
          title: Text(user["name"]),
          subtitle: Text(user["username"]),
          leading: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
          ),
        );
  }
}