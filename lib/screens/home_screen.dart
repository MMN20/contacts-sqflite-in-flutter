import 'package:contacts_sqflite_crud/data_access/database.dart';
import 'package:contacts_sqflite_crud/models/contact.dart';
import 'package:contacts_sqflite_crud/models/country.dart';
import 'package:contacts_sqflite_crud/providers/contact_data.dart';
import 'package:contacts_sqflite_crud/screens/add_edit_contact.dart';
import 'package:contacts_sqflite_crud/widgets/contacts_list.dart';
import 'package:contacts_sqflite_crud/widgets/my_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              myModalBottomSheet(context, Contact());
            }),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<ContactData>(
            builder: (context, value, child) {
              return value.isInitalized
                  ? ContactsList(contacts: value.contacts)
                  : Center(child: Text('...'));
            },
          ),
        ));
  }
}
