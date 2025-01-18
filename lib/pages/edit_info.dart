import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:orders/api/services/auth_service.dart';
import 'package:orders/providers/user.dart';
import 'package:provider/provider.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({super.key});

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool loading = false;
  Map<String, dynamic> _errors = {"name": "", "phone": "", "location": ""};

  Future<String?> getToken() async {
    var box = Hive.box('myBox');
    String? token = box.get('token');
    return token;
  }


  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final token =  await getToken();
    final apiService = AuthService();
    try {
      setState(() {
        loading = true;
        _errors = {
          "email": "",
        };
      });
      final res = await apiService.changeUserInfo(
        token,
        _nameController.text,
        _phoneController.text,
        _locationController.text,
      );
      print(res['error']);
      setState(() {
        loading = false;
      });
      if (res['error'] != null) {
        if (res['errors'] != null) {
          setState(() {
            _errors = res['errors'];
          });
        }
        setState(() {
          loading = false;
        });
        // Handle error (e.g., show dialog or snackbar)
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("check your network")),
        );
        return;
      }
      // print(res['token']);

      // ignore: use_build_context_synchronously
      Provider.of<UserProvider>(context, listen: false).setUser(res['user']);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
      // Handle error (e.g., show dialog or snackbar)
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("check your network")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: const [],
      ),
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
                'Update Info',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nameController,
                error: _errors['name'],
                label: "User Name",
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter user name' : null,
              ),
              _buildTextField(
                controller: _phoneController,
                error: _errors['phone'],
                label: "Phone Number",
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter phone number'
                    : null,
              ),
              _buildTextField(
                controller: _locationController,
                error: _errors['location'],
                label: "Location",
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your location'
                    : null,
              ),
              const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 20),
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
          'Submit',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
