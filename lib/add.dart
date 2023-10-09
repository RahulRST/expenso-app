import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

final storage = LocalStorage("secure_storage");

class MyAddPage extends StatefulWidget {
  const MyAddPage({Key? key}) : super(key: key);

  @override
  State<MyAddPage> createState() => _MyAddPageState();
}

class _MyAddPageState extends State<MyAddPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        AddIncome(),
        AddExpense(),
      ])),
    );
  }
}

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final amount = TextEditingController();
  final category = TextEditingController();
  final description = TextEditingController();
  late DateTime date;

  void handleIncome() async {
    await http
        .post(Uri.parse("http://localhost:5500/api/track/addincome"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${storage.getItem('token')}'
            },
            body: jsonEncode({
              'amount': amount.text,
              'category': category.text,
              'description': description.text,
              'date': date
            }))
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Income added"))))
        .onError((error, stackTrace) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error Adding Income")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Add Income",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            width: 150,
            child: TextFormField(
              controller: amount,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            )),
        const SizedBox(width: 30),
        SizedBox(
            width: 150,
            child: TextFormField(
              controller: category,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ))
      ]),
      const SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            width: 150,
            child: TextFormField(
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            )),
        const SizedBox(width: 30),
        SizedBox(
            width: 150,
            child: InputDatePickerFormField(
                firstDate: DateTime.now(),
                lastDate: DateTime(2099),
                acceptEmptyDate: false,
                initialDate: DateTime.now(),
                onDateSaved: (date) {
                  setState(() {
                    this.date = date;
                  });
                },
                )
              ),
      ]),
      const SizedBox(height: 30),
      ElevatedButton(onPressed: handleIncome, child: const Text("Add"))
    ]);
  }
}

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final amount = TextEditingController();
  final category = TextEditingController();
  final description = TextEditingController();
  late DateTime date;
  void handleExpense() async {
    await http
        .post(Uri.parse("http://localhost:5500/api/track/addexpense"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${storage.getItem('token')}'
            },
            body: jsonEncode({
              'amount': amount.text,
              'category': category.text,
              'description': description.text,
              'date': date
            }))
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Expense added"))))
        .onError((error, stackTrace) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error Adding Expense")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Add Expense",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            width: 150,
            child: TextFormField(
              controller: amount,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            )),
        const SizedBox(width: 30),
        SizedBox(
            width: 150,
            child: TextFormField(
              controller: category,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ))
      ]),
      const SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            width: 150,
            child: TextFormField(
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            )),
        const SizedBox(width: 30),
        SizedBox(
            width: 150,
            child: InputDatePickerFormField(
                firstDate: DateTime.now(),
                lastDate: DateTime(2099),
                acceptEmptyDate: false,
                initialDate: DateTime.now(),
                onDateSaved: (date) {
                  setState(() {
                    this.date = date;
                  });
                },
                )
              ),
      ]),
      const SizedBox(height: 30),
      ElevatedButton(onPressed: handleExpense, child: const Text("Add"))
    ]);
  }
}
