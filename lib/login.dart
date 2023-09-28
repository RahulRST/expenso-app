import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final pass = TextEditingController();
  final storage = LocalStorage("secure_storage");
  void _login() async {
    if (_formKey.currentState!.validate()) {
      await http
          .post(Uri.parse("http://localhost:5500/api/auth/login"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'username': username.text,
                'password': pass.text
              }))
          .then((res) async => {
                if (res.statusCode == 200)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged in')),
                    ),
                    await storage.setItem('token',jsonDecode(res.body)["token"]),
                    context.go("/home")
                  }
                else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error Logging in')),
                    )
                  }
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Username",
                        ),
                        controller: username,
                        style: MaterialStateTextStyle.resolveWith((states) {
                          return const TextStyle(
                            color: Colors.black,
                          );
                        }),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a username";
                          }
                          return null;
                        },
                      )),
                ),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                        // height: 100,
                        width: 200,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Password",
                          ),
                          controller: pass,
                          style: MaterialStateTextStyle.resolveWith((states) {
                            return const TextStyle(
                              color: Colors.black,
                            );
                          }),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password";
                            }
                            return null;
                          },
                        ))),
                FloatingActionButton(
                  onPressed: _login,
                  tooltip: 'Login',
                  child: const Icon(Icons.login),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Text("New user?")),
                TextButton(
                  onPressed: () {
                    context.go("/register");
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateColor.resolveWith((states) {
                      return Colors.teal;
                    }),
                  ),
                  child: const Text("Register"),
                ),
              ],
            )),
      ),
    );
  }
}
