import 'package:contacts_sqflite_crud/data_access/database.dart';

enum _Mode { Add, Update }

class Country {
  int id;
  String countryName;
  int code;
  String phoneCode;

  _Mode _mode;

  Country()
      : id = -1,
        countryName = '',
        code = -1,
        phoneCode = '',
        _mode = _Mode.Add;

  Country._(
      {required this.id,
      required this.code,
      required this.countryName,
      required this.phoneCode})
      : _mode = _Mode.Update;

  static Future<List<Country>> getAllCountries() async {
    SqlDB sqlDB = SqlDB();
    List<Map<String, dynamic>> maps =
        await sqlDB.readData('select * from Countries');
    List<Country> countries = [];
    for (var map in maps) {
      countries.add(Country._(
          id: map['ID'],
          countryName: map['CountryName'],
          code: map['Code'],
          phoneCode: map['PhoneCode']));
    }
    return countries;
  }

  static Future<Country?> findCountryByID(int id) async {
    SqlDB sqlDB = SqlDB();
    List<Map<String, dynamic>> data = await sqlDB
        .readData('select * from countries where ID = ?', [id.toString()]);
    if (data.isNotEmpty) {
      return Country._(
          id: data[0]['ID'],
          countryName: data[0]['CountryName'],
          code: data[0]['Code'],
          phoneCode: data[0]['PhoneCode']);
    }
    return null;
  }

  static Future<bool> deleteByID(int id) async {
    SqlDB sqlDB = SqlDB();
    int res = await sqlDB
        .delete('delete from countries where id = ?', [id.toString()]);
    return res > 0;
  }

  static Future<Country?> findCountryByName(String name) async {
    SqlDB sqlDB = SqlDB();
    List<Map<String, dynamic>> data = await sqlDB
        .readData('select * from countries where CountryName = ?', [name]);
    if (data.isNotEmpty) {
      return Country._(
          id: data[0]['ID'],
          countryName: data[0]['CountryName'],
          code: data[0]['Code'],
          phoneCode: data[0]['PhoneCode']);
    }
    return null;
  }

  Future<bool> insert() async {
    SqlDB sqlDB = SqlDB();
    int res = await sqlDB.insert(
        'insert into countries (CountryName,Code,PhoneCode) values (?,?,?)',
        [countryName, code.toString(), phoneCode]);
    if (res > 0) {
      id = res;
      _mode = _Mode.Update;
      return true;
    }
    return false;
  }

  Future<bool> update() async {
    SqlDB sqlDB = SqlDB();
    int res = await sqlDB.insert(
        'update countries set CountryName = ? , Code = ? , PhoneCode = ?',
        [countryName, code.toString(), phoneCode]);
    return res > 0;
  }

  Future<bool> save() async {
    switch (_mode) {
      case _Mode.Add:
        {
          return await insert();
        }
      case _Mode.Update:
        {
          return await update();
        }
    }
  }
}
