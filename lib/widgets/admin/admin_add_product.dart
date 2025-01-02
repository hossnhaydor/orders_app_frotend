import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/api/services/product_service.dart';

class AdminAddProduct extends StatefulWidget {
  const AdminAddProduct({super.key});

  @override
  State<AdminAddProduct> createState() => _AdminAddProductState();
}

class _AdminAddProductState extends State<AdminAddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _store = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _stock = TextEditingController();
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
    final ProductService = ProductServices();
    try {
      setState(() {
        loading = true;
        _errors = {};
      });
      final res = await ProductService.addProduct(
        token,
        _nameController.text,
        _store.text,
        _stock.text,
        _price.text,
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
        const SnackBar(content: Text("Product added successfully")),
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
                'Add Product',
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
                label: "Name",
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter product name' : null,
              ),
              _buildTextField(
                controller: _store,
                error: _errors['store_id'],
                label: "Store id",
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter Store Id' : null,
              ),
              _buildTextField(
                controller: _price,
                error: _errors['price'],
                label: "Price",
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter Price' : null,
              ),
              _buildTextField(
                controller: _stock,
                error: _errors['stock'],
                label: "Stock",
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter Stock' : null,
              ),
              _buildTextField(
                controller: _description,
                error: _errors['description'],
                label: "description",
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter Description' : null,
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
          'Add Product',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
