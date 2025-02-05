import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orders/api/services/auth_service.dart';
import 'package:orders/pages/signup.dart';
import 'package:orders/providers/token.dart';
import 'package:orders/providers/user.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _image;
  String? _password;
  bool loading = false;
  bool isAdmin = false; // Checkbox state
  Map<String, dynamic> _errors = {
    "email": "",
    "name": "",
    "password": "",
    "location": ""
  };

  Future<void> _storeToken(String token) async {
    try {
      var box = Hive.box('mybox');
      await box.put('token', token);
      // ignore: empty_catches
    } catch (err) {}
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final apiService = AuthService();
    try {
      setState(() {
        loading = true;
        _errors = {
          "email": "",
        };
      });
      final res = await apiService.register(
        _nameController.text,
        _passwordController.text,
        _confirmPasswordController.text,
        _phoneController.text,
        _locationController.text,
        isAdmin, // Send the admin state
      );
      setState(() {
        loading = false;
      });
      if (res['error'] != null) {
        if (res['errors'] != null) {
          setState(() {
            _errors = res['errors'];
          });
          return;
        }
        throw ();
      }
      await _storeToken(res['token']);
      // ignore: use_build_context_synchronously
      Provider.of<UserProvider>(context, listen: false).setUser(res['user']);
      // ignore: use_build_context_synchronously
      Provider.of<TokenProvider>(context, listen: false).login(res['token']);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
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
                'Create Account',
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
                controller: _passwordController,
                error: _errors['password'],
                label: "Password",
                obscureText: true,
                onChanged: (value) => _password = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter password' : null,
              ),
              _buildTextField(
                controller: _confirmPasswordController,
                error: _errors['name'],
                label: "Confirm Password",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm your password";
                  } else if (value != _password) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _locationController,
                error: _errors['location'],
                label: "Location",
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your location'
                    : null,
              ),
              Row(
                children: [
                  Checkbox(
                    value: isAdmin,
                    onChanged: (value) {
                      setState(() {
                        isAdmin = value!;
                      });
                    },
                  ),
                  const Text('Admin'),
                ],
              ),
              TextButton(
                onPressed: () {
                  _pickImage();
                },
                child: const Text('Pick Image'),
              ),
              _image != null
                  ? Image.file(
                      _image!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(height: 0),
              const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 20),
              _buildSignInPrompt(),
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
          'Sign Up',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSignInPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.black),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (e) => const SignUp()),
            );
          },
          child: const Text(
            'Sign In',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
      });
      print("no image error");
      print(image!.path);
    } catch (err) {
      print(err);
    }
  }
}
