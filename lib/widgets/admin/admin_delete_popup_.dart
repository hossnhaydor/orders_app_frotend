import 'package:flutter/material.dart';

class AdminPopUp extends StatefulWidget {
  final String title;
  final Function(BuildContext, int) delete;
  const AdminPopUp({super.key, required this.title, required this.delete});

  @override
  State<AdminPopUp> createState() => _AdminPopUpState();
}

class _AdminPopUpState extends State<AdminPopUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('delete ${widget.title}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'id'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ${widget.title} id';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final id = int.parse(_idController.text);
              widget.delete(context, id);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
