import 'package:flutter/material.dart';
import 'package:orders/api/services/auth_service.dart';
import 'package:orders/pages/signin.dart';
import 'package:orders/providers/cart.dart';
import 'package:orders/providers/token.dart';
import 'package:orders/providers/wlist_ids.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  Map<String, dynamic> _errors = {
    "message": "",
  };

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final apiService = AuthService();
    try {
      setState(() {
        loading = true;
        _errors = {
          "message": "",
        };
      });
      final res = await apiService.login(
          _phoneController.text, _passwordController.text);
      setState(() {
        loading = false;
      });
      print(res);
      if (res['error'] != null) {
        if (res['message'] != null) {
          setState(() {
            _errors = {"message": res['message']};
          });
          return;
        }
        throw ();
      }

      // ignore: use_build_context_synchronously
      Provider.of<UserProvider>(context, listen: false).setUser(res['user']);
      // ignore: use_build_context_synchronously
      Provider.of<TokenProvider>(context, listen: false).login(res['token']);

      // ignore: use_build_context_synchronously
      Provider.of<WishListIdsProvider>(context, listen: false)
          .getIds(res['token']);
      // ignore: use_build_context_synchronously
      Provider.of<CartIdsProvider>(context, listen: false).getIds(res['token']);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
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
            child: Column(
              children: [
                _buildFormContainer(),
                const SizedBox(height: 10),
                loading
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
              ],
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
                'Login Here',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneController,
                label: "Phone Number",
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter phone number'
                    : null,
              ),
              _buildTextField(
                controller: _passwordController,
                error: _errors['message'],
                label: "Password",
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 20),
              _buildCreateAccountPrompt(),
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
              error != null && error.isNotEmpty
                  ? Flexible(
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCreateAccountPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.black),
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignIn(),
              ),
            );
          },
          child: const Text(
            'Create Account',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
