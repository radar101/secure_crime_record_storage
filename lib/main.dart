import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminar_blockchain/service/crime_service.dart';
import 'package:seminar_blockchain/screens/home.dart';

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
      home: HomeScreen(),
    );
  }
}
