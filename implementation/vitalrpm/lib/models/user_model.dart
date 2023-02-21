import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String documentId;
  String userId;
  String userType;
  String name;
  String email;
  String mobile;
  int genderId;
  DateTime? dateOfBirth;
  String country;
  String? address;
  Timestamp? registrationDate;

  UserModel({
    this.documentId = "",
    this.userId = "",
    this.userType = "",
    this.name = "",
    this.email = "",
    this.mobile = "",
    this.genderId = 0,
    this.country = "",
  });
}
