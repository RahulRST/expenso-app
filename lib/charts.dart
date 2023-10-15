import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

final storage = LocalStorage("secure_storage");

class MyChartPage extends StatefulWidget {
  const MyChartPage({Key? key}) : super(key: key);

  @override
  State<MyChartPage> createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  final List<ChartData> _chartData = [];
  final List<ChartData> _incomeData = [];
  final List<ChartData> _expenseData = [];
  final List<num> _income = [];
  final List<num> _expense = [];

  bool loading = true;

  void fetchData() async {
    await http
        .get(Uri.parse("http://localhost:5500/api/fetch/analytics"), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${storage.getItem('token')}'
    }).then((value) {
      const JsonDecoder decoder = JsonDecoder();
      final dynamic income = decoder.convert(value.body)['incomes'];
      final dynamic expense = decoder.convert(value.body)['expenses'];
      double totalIncome = 0;
      double totalExpense = 0;
      income.forEach((element) {
        String name = element['source']['name'];
        double amount = element['amount'].toDouble();
        totalIncome += amount;
        _income.add(amount);
        _incomeData
            .add(ChartData(name, amount, const Color.fromRGBO(0, 255, 0, 1)));
      });
      expense.forEach((element) {
        String name = element['category']['name'];
        double amount = element['amount'].toDouble();
        totalExpense += amount;
        _expense.add(amount);
        _expenseData
            .add(ChartData(name, amount, const Color.fromRGBO(255, 0, 0, 1)));
      });
      _chartData.add(
          ChartData('Income', totalIncome, const Color.fromRGBO(0, 255, 0, 1)));
      _chartData.add(ChartData(
          'Expense', totalExpense, const Color.fromRGBO(255, 0, 0, 1)));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      // print(error);
      // print(stackTrace);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error Fetching Data")));
    });
  }

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    super.initState();
    // _chartData = <ChartData>[
    //   ChartData('Income', 10000, const Color.fromRGBO(0, 255, 0, 1)),
    //   ChartData('Expense', 5000, const Color.fromRGBO(255, 0, 0, 1)),
    // ];
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: SfCircularChart(
                      title: ChartTitle(text: 'Income vs Expense'),
                      legend: const Legend(isVisible: true),
                      series: <CircularSeries>[
                        DoughnutSeries<ChartData, String>(
                            dataSource: _chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            pointColorMapper: (ChartData data, _) => data.color,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside))
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const CircularProgressIndicator(),
    ));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
