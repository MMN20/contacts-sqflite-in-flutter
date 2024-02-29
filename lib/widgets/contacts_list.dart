import 'package:contacts_sqflite_crud/models/contact.dart';
import 'package:contacts_sqflite_crud/models/country.dart';
import 'package:contacts_sqflite_crud/widgets/my_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key, required this.contacts});
  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        Contact contact = contacts[index];
        return Card(
            elevation: 10,
            child: ListTile(
              title: Text('${contact.name} - ${contact.country.countryName}'),
              subtitle: Text(
                  '${contact.phone} - ${Contact.getFormattedDate(contact.dateOfBirth)}'),
              trailing: IconButton(
                  onPressed: () {
                    Contact.deleteByID(contact.ID);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              onTap: () {
                myModalBottomSheet(context, contact);
              },
            ));
      },
    );
  }
}
