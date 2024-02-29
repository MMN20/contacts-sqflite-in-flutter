import 'package:contacts_sqflite_crud/models/contact.dart';
import 'package:contacts_sqflite_crud/models/country.dart';
import 'package:contacts_sqflite_crud/providers/contact_data.dart';
import 'package:contacts_sqflite_crud/providers/country_data.dart';
import 'package:contacts_sqflite_crud/widgets/mytextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditContact extends StatefulWidget {
  const AddEditContact({super.key, required this.contact});
  final Contact contact;
  @override
  State<AddEditContact> createState() => _AddEditContactState();
}

class _AddEditContactState extends State<AddEditContact> {
  String? selectedVal;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dofController = TextEditingController();

  List<DropdownMenuItem<String>>? _countriesForDropDownMenu(
      List<Country>? countries) {
    if (countries == null) {
      return null;
    }
    return countries.map((e) {
      return DropdownMenuItem<String>(
          value: e.countryName, child: Text(e.countryName));
    }).toList();
  }

  _initialControllers() {
    nameController.text = widget.contact.name;
    emailController.text = widget.contact.email ?? '';
    phoneController.text = widget.contact.phone;
    addressController.text = widget.contact.address;
    dofController.text = Contact.getFormattedDate(widget.contact.dateOfBirth);
    selectedVal = widget.contact.country.countryName;
  }

  @override
  void initState() {
    super.initState();
    if (widget.contact.ID != -1) {
      _initialControllers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              MyTextField(
                controller: nameController,
                hintText: 'Name',
              ),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
              ),
              MyTextField(
                controller: phoneController,
                hintText: 'Phone',
              ),
              MyTextField(
                controller: addressController,
                hintText: 'Address',
              ),
              MyTextField(
                controller: dofController,
                hintText: 'yyyy-mm-dd',
              ),
              Consumer<CountryData>(
                builder: (context, value, child) {
                  return DropdownButton<String>(
                      value: selectedVal,
                      items: _countriesForDropDownMenu(value.countries),
                      onChanged: (newValue) {
                        selectedVal = newValue;
                        setState(() {});
                      });
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 10),
                  onPressed: () async {
                    if (selectedVal == null) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Please choose a country'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'))
                              ],
                            );
                          });

                      return;
                    }

                    if (dofController.text.isEmpty ||
                        DateTime.tryParse(dofController.text) == null) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Please enter a valid date'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'))
                              ],
                            );
                          });
                      return;
                    }

                    widget.contact.name = nameController.text;
                    widget.contact.email = emailController.text;
                    widget.contact.phone = phoneController.text;
                    widget.contact.address = addressController.text;
                    widget.contact.dateOfBirth =
                        DateTime.parse(dofController.text);
                    Country? c = await Country.findCountryByName(selectedVal!);
                    widget.contact.country = c!;
                    bool addNew = false;
                    if (widget.contact.ID == -1) {
                      addNew = true;
                    }

                    if (await widget.contact.save()) {
                      print('Saved successfully');
                      if (addNew) {
                        Provider.of<ContactData>(context, listen: false)
                            .addAContact(widget.contact);
                      } else {
                        Provider.of<ContactData>(context, listen: false)
                            .refresh();
                      }
                    }
                  },
                  child: Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
