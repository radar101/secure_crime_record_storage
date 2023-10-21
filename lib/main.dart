import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminar_blockchain/crime_service.dart';
import 'package:seminar_blockchain/filebase.dart';
import 'package:seminar_blockchain/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CrimeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes dApp',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: FileBaseService(),
    );
  }
}
