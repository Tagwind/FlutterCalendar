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
  final _emailController = TextEditingController();

  final List<Color> availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.indigo,
    Colors.teal,
    Colors.yellow,
  ];

  Color? _selectedColor;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final colorString = _selectedColor != null
          ? '#${_selectedColor!.value.toRadixString(16).padLeft(8, '0')}'
          : null;
      await context.read<DatabaseProvider>().db.usersDao.insertUser(UsersCompanion(
        name: drift.Value(_nameController.text),
        email: drift.Value(_nameController.text),
        profileColor: drift.Value(colorString),
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
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Address'),
              validator: (value) => value == null || value.isEmpty ? 'Enter an email' : null,
            ),
            SizedBox(height: 20),
            Text('Select Profile Color'),
            SizedBox(height: 8),
            _buildColorPicker(),

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


  Widget _buildColorPicker() {
    return Wrap(
      spacing: 10,
      children: availableColors.map((color) {
        final isSelected = color == _selectedColor;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: CircleAvatar(
            radius: isSelected ? 24 : 20,
            backgroundColor: color,
            child: isSelected
                ? Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }

}


