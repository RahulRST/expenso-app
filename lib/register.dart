import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final username = TextEditingController();
  final address = TextEditingController();
  final contact = TextEditingController();
  final pass = TextEditingController();
  void _register() async {
    if (_formKey.currentState!.validate()) {
      await http
          .post(Uri.parse("http://localhost:5500/api/auth/register"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'name': name.text,
                'username': username.text,
                'address': address.text,
                'contact': contact.text,
                'password': pass.text
              }))
          .then((res) => {
                if (res.statusCode == 200)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registered')),
                    ),
                    context.go("/")
                  }
                else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error Registering')),
                    )
                  }
              })
          .onError((error, stackTrace) => {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Error Registering')),
                // )
              });
    }
    // context.go("/");
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Name",
                              ),
                              controller: name,
                              style:
                                  MaterialStateTextStyle.resolveWith((states) {
                                return const TextStyle(
                                  color: Colors.black,
                                );
                              }),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a name";
                                }
                                return null;
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Username",
                              ),
                              controller: username,
                              style:
                                  MaterialStateTextStyle.resolveWith((states) {
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
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Address",
                              ),
                              controller: address,
                              style:
                                  MaterialStateTextStyle.resolveWith((states) {
                                return const TextStyle(
                                  color: Colors.black,
                                );
                              }),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter an address";
                                }
                                return null;
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Contact",
                              ),
                              controller: contact,
                              style:
                                  MaterialStateTextStyle.resolveWith((states) {
                                return const TextStyle(
                                  color: Colors.black,
                                );
                              }),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a contact number";
                                }
                                return null;
                              },
                            )),
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                              // height: 100,
                              width: 200,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                ),
                                obscureText: true,
                                controller: pass,
                                style: MaterialStateTextStyle.resolveWith(
                                    (states) {
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
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                              // height: 100,
                              width: 200,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Confirm Password",
                                ),
                                obscureText: true,
                                style: MaterialStateTextStyle.resolveWith(
                                    (states) {
                                  return const TextStyle(
                                    color: Colors.black,
                                  );
                                }),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a password";
                                  } else if (value != pass.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                              )))
                    ]),
                FloatingActionButton(
                  onPressed: _register,
                  tooltip: 'Register',
                  child: const Icon(Icons.app_registration),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: TextButton(
                      onPressed: () {
                        context.go("/");
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateColor.resolveWith((states) {
                          return Colors.teal;
                        }),
                      ),
                      child: const Text("Go Back"),
                    )),
              ],
            )),
      ),
    );
  }
}
