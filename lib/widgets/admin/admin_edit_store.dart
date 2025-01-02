import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/api/services/store_service.dart';

class AdminEditStore extends StatefulWidget {
  const AdminEditStore({super.key});
  @override
  State<AdminEditStore> createState() => _AdminEditStoreState();
}

class _AdminEditStoreState extends State<AdminEditStore> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _image_url = TextEditingController();

  bool loading = false;
  bool isAdmin = false; // Checkbox state
  Map<String, dynamic> _errors = {};

  Future<String?> getToken() async {
    var box = Hive.box('myBox'); // Open the box
    String? token = box.get('token'); // Retrieve the token with the key 'token'
    return token;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    String? token = await getToken();
    final storeService = StoreService();
    try {
      setState(() {
        loading = true;
        _errors = {};
      });
      final res = await storeService.editStore(
        token,
        _idController.text,
        _nameController.text,
        _location.text,
        _type.text,
        _number.text,
        _description.text,
        _image_url.text, // Send the admin state
      );
      setState(() {
        loading = false;
      });
      if (res['error'] != null) {
        if (res['errors'] != null) {
          setState(() {
            _errors = res['errors'];
          });
        }
        throw ();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Store edited successfully")),
      );
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Check your network")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFormContainer(),
                  const SizedBox(
                    height: 10,
                  ),
                  loading ? const CircularProgressIndicator() : const Text('')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Edit Store',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _idController,
                error: _errors['id'],
                label: "Store Id",
              ),
              _buildTextField(
                controller: _nameController,
                error: _errors['name'],
                label: "Name",
              ),
              _buildTextField(
                controller: _location,
                error: _errors['location'],
                label: "location",
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _type,
                error: _errors['type'],
                label: "type",
              ),
              _buildTextField(
                controller: _number,
                error: _errors['number'],
                label: "number",
              ),
              _buildTextField(
                controller: _description,
                error: _errors['description'],
                label: "description",
              ),
              _buildTextField(
                controller: _image_url,
                error: _errors['image'],
                label: "image",
              ),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? error,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            obscuringCharacter: '*',
            keyboardType: keyboardType,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              label: Text(label),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              error != null
                  ? Flexible(
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : const Text(''),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Add Store',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
