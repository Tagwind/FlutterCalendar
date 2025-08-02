import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;

import '../data/app_database.dart';
import '../providers/database_provider.dart';

class AddProfileForm extends StatefulWidget {
  @override
  _AddProfileFormState createState() => _AddProfileFormState();
}

class _AddProfileFormState extends State<AddProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final db = context.read<DatabaseProvider>().db;
      await db.usersDao.insertUser(UsersCompanion(
        name: drift.Value(_nameController.text),
      ));
      Navigator.pop(context); // Close dialog
      setState(() {}); // Refresh settings screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(  // ← Flutter's Column will now work fine
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add New Profile",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Profile Name'),
              validator: (value) => value == null || value.isEmpty ? 'Enter a name' : null,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                ElevatedButton(onPressed: _submit, child: Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
