import 'package:contacts_sqflite_crud/data_access/database.dart';
import 'package:contacts_sqflite_crud/models/country.dart';
import 'package:contacts_sqflite_crud/providers/contact_data.dart';
import 'package:contacts_sqflite_crud/providers/country_data.dart';
import 'package:contacts_sqflite_crud/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => ContactData()),
        ChangeNotifierProvider(create: (c) => CountryData()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
/// add contact functionality which is by adding the add screen 
/// make a provider to add the contacts list to make it global and perform operations on it
/// 
