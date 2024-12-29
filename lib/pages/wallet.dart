import 'package:flutter/material.dart';
import 'package:orders/api/services/auth_service.dart';
import 'package:orders/models/User.dart';
import 'package:orders/providers/token.dart';
import 'package:orders/providers/user.dart';
import 'package:provider/provider.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _password;
  bool loading = false;
  Map<String, dynamic> _errors = {
    "amount": "",
    "password": "",
  };

  double _getUserWallet(context) {
    User? user = Provider.of<UserProvider>(context).user;
    return user!.ammount;
  }

  void _submit(context) async {
    if (!_formKey.currentState!.validate()) return;

    final apiService = AuthService();
    try {
      setState(() {
        loading = true;
        _errors = {};
      });
      final token = Provider.of<TokenProvider>(context, listen: false).token;
      final res = await apiService.addToWallet(
        token,
        _amountController.text,
        _passwordController.text,
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
      Provider.of<UserProvider>(context, listen: false)
          .increaseAmmount(double.parse(_amountController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("ammount added successfully"),
        ),
      );
    } catch (e) {
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
                'Wallet',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '${_getUserWallet(context)} \$',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _amountController,
                error: _errors['ammount'],
                label: "ammount",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final numValue = num.tryParse(value);
                  if (numValue == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
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
        onPressed: () => {_submit(context)},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Add to Wallet',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
