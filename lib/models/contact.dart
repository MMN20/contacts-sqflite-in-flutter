import 'package:contacts_sqflite_crud/data_access/database.dart';
import 'package:contacts_sqflite_crud/models/country.dart';

enum _Mode { Add, Update }

class Contact {
  int ID;
  String name;
  String? email;
  String phone;
  String address;
  DateTime dateOfBirth;
  Country country;

  _Mode _mode;

  Contact()
      : ID = -1,
        name = '',
        phone = '',
        address = '',
        dateOfBirth = DateTime.parse('1970-01-01'),
        country = Country(),
        _mode = _Mode.Add;

  Contact._(
      {required this.ID,
      required this.name,
      this.email,
      required this.phone,
      required this.address,
      required this.dateOfBirth,
      required this.country})
      : _mode = _Mode.Add;

  static Future<List<Contact>> getAllContacts() async {
    SqlDB sqlDB = SqlDB();
    List<Map<String, dynamic>> data =
        await sqlDB.readData('select * from contacts');
    List<Contact> items = [];
    for (Map<String, dynamic> item in data) {
      DateTime dof = DateTime.parse(item['DateOfBirth']);
      Country? country = await Country.findCountryByID(item['CountryID']);
      items.add(Contact._(
          ID: item['ID'],
          name: item['Name'],
          email: item['Email'],
          phone: item['Phone'],
          address: item['Address'],
          dateOfBirth: dof,
          country: country!));
    }
    return items;
  }

  static Future<Contact?> findByID(int id) async {
    SqlDB sqlDB = SqlDB();
    List<Map<String, dynamic>> data = await sqlDB
        .readData('select * from contacts where ID = ?', [id.toString()]);

    if (data.isNotEmpty) {
      Map<String, dynamic> item = data[0];
      DateTime dof = DateTime.parse(item['DateOfBirth']);
      Country? country = await Country.findCountryByID(item['CountryID']);
      return Contact._(
          ID: item['ID'],
          name: item['Name'],
          email: item['Email'],
          phone: item['Phone'],
          address: item['Address'],
          dateOfBirth: dof,
          country: country!);
    }
    return null;
  }

  static Future<bool> deleteByID(int id) async {
    SqlDB sqlDB = SqlDB();
    return ((await sqlDB
            .delete('delete from contacts where ID = ?', [id.toString()])) >
        0);
  }

  static String getFormattedDate(DateTime dt) {
    String month = dt.month.toString().length < 2
        ? '0' + dt.month.toString()
        : dt.month.toString();

    String day = dt.day.toString().length < 2
        ? '0' + dt.day.toString()
        : dt.day.toString();

    String s = '${dt.year}-$month-$day';
    return s;
  }

  Future<bool> insert() async {
    SqlDB sqlDB = SqlDB();
    String dof = getFormattedDate(dateOfBirth);
    int res = await sqlDB.insert('''
      insert into contacts (Name,Email,Phone,Address,DateOfBirth,CountryID) 
      values (?,?,?,?,?,?)
           ''', [name, email, phone, address, dof, country.id.toString()]);
    if (res > 0) {
      ID = res;
      _mode = _Mode.Update;
    }
    return res > 0;
  }

  Future<bool> update() async {
    SqlDB sqlDB = SqlDB();
    String dof = getFormattedDate(dateOfBirth);
    int res = await sqlDB.update(
        'update contacts set Name = ?,Email = ?,Phone = ?,Address = ?,DateOfBirth = ?,CountryID = ? where ID = ?',
        [
          name,
          email,
          phone,
          address,
          dof,
          country.id.toString(),
          ID.toString()
        ]);
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
