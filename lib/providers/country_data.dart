import 'package:contacts_sqflite_crud/models/country.dart';
import 'package:flutter/material.dart';

class CountryData extends ChangeNotifier {
  List<Country>? countries;

  Future<void> initialCountries() async {
    countries = await Country.getAllCountries();
    notifyListeners();
  }

  CountryData() {
    initialCountries();
  }
}
