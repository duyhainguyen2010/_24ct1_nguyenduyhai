import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CNPM-DAU',
      home: Scaffold(
        appBar: AppBar(title: const Text('CNPM-DAU')),
        body: const Center(
          child: Text(
            'Chào bạn khóa 24CT\nđến với học phần CNPM-DAU',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
