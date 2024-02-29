import 'package:contacts_sqflite_crud/models/contact.dart';
import 'package:contacts_sqflite_crud/screens/add_edit_contact.dart';
import 'package:flutter/material.dart';

void myModalBottomSheet(BuildContext context, Contact contact) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (c) => AddEditContact(
            contact: contact,
          ));
}
