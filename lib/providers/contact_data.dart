import 'package:contacts_sqflite_crud/data_access/database.dart';
import 'package:contacts_sqflite_crud/models/contact.dart';
import 'package:contacts_sqflite_crud/models/country.dart';
import 'package:flutter/material.dart';

class ContactData extends ChangeNotifier {
  late List<Contact> contacts;
//  late List<Country> countries;
  bool isInitalized = false;

  Future<void> initialContacts() async {
    contacts = await Contact.getAllContacts();
    //  countries = await Country.getAllCountries();
    isInitalized = true;
    notifyListeners();
  }

  void addAContact(Contact contact) {
    contacts.add(contact);
    notifyListeners();
  }

  void removeContact(Contact contact) {
    contacts.remove(contact);
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  ContactData() {
    initialContacts();
  }
}
