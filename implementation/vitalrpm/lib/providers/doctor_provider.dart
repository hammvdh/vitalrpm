import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorProvider extends ChangeNotifier {
  static Stream getMyPatientsAsStream(doctorId) {
    return FirebaseFirestore.instance
        .collection('usermaster')
        .where('userType', isEqualTo: 'Patient')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots();
  }

  static Stream getAllPatientsAsStream(doctorId) {
    return FirebaseFirestore.instance
        .collection('usermaster')
        .where('userType', isEqualTo: 'Patient')
        .where('doctorId', isEqualTo: null)
        .snapshots();
  }
}
