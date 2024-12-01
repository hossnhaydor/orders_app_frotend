import 'package:flutter/material.dart';

class User {
  final String name;
  final int id;
  final String image;
  final String phoneNumber;
  final String location;
  User({required this.id,required this.name,required this.name})
}

class UserProvider extends ChangeNotifier {}
