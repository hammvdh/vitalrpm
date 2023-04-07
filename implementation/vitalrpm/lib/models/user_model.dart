import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String documentId;
  String userId;
  String userType;
  String firstName;
  String lastName;
  String email;
  String mobileNo;
  int genderId;
  DateTime? dateOfBirth;
  String country;
  String? address;
  Timestamp? registrationDate;
  String? doctor;
  String? doctorId;

  UserModel({
    this.documentId = "",
    this.userId = "",
    this.userType = "Patient",
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.mobileNo = "",
    this.genderId = 0,
    this.country = "",
  });
}
