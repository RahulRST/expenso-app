import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

final storage = LocalStorage("secure_storage");

Future fetchNotifications() async {
  final res = await http.get(
      Uri.parse('http://localhost:5500/api/fetch/notifications'),
      headers: <String, String>{
        'Authorization': 'Bearer ${storage.getItem('token')}'
      });
  return jsonDecode(res.body)["data"];
}

class Notifications {
  final String id;
  final String message;
  final DateTime date;

  const Notifications({
    required this.id,
    required this.message,
    required this.date,
  });
}

class MyNotificationPage extends StatefulWidget {
  const MyNotificationPage({super.key});

  @override
  State<MyNotificationPage> createState() => _MyNotificationPageState();
}

class _MyNotificationPageState extends State<MyNotificationPage> {

  void handleAddNotification() async {
    // await http.post(Uri.parse("http://localhost:5500/api/add/notification"),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'Authorization': 'Bearer ${storage.getItem('token')}'
    //     },
    //     body: jsonEncode(<String, String>{
    //       'message': "Hello World",
    //     }));
    print('added');
    context.go("/home");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Notifications notification = Notifications(
                    id: snapshot.data[index]["id"],
                    message: snapshot.data[index]["message"],
                    date: DateTime.parse(snapshot.data[index]["date"]),
                  );
                  return Center(
                      child: SizedBox(
                          width: 200.0,
                          height: 150.0,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(notification.message),
                                  const SizedBox(height: 10),
                                  Text(notification.date
                                      .toString()
                                      .split(" ")[0])
                                ],
                              )))));
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    insetPadding: const EdgeInsets.all(15.0),
                    title: const Text("Add Notification"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Message",
                          ),
                          // controller: message,
                        ),
                        const SizedBox(height: 30),
                        InputDatePickerFormField(firstDate: DateTime.now(), lastDate: DateTime(2099), acceptEmptyDate: false, initialDate: DateTime.now())
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        // onPressed: handleAddNotification,
                        onPressed: () {
                          handleAddNotification();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Add"),
                      )
                    ],
                  );
                });
          },
          child: const Icon(Icons.add),
        ));
  }
}
