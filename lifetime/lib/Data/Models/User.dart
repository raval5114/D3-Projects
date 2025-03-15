import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String firstName;
  late String lastName;
  late String username;
  late String email;
  late String lifeExpectancyYears;
  late Timestamp createdAt;
  late DateTime dob;

  UserModel() {}
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'lifeExpectancyYears': lifeExpectancyYears,
      'createdAt': createdAt.toDate().toIso8601String(),
      'dob': dob.toIso8601String(),
    };
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    createdAt =
        map['createdAt'] is Timestamp
            ? map['createdAt'] as Timestamp
            : Timestamp.now();
    firstName = map['firstName'];
    lastName = map['lastName'];
    username = map['username'];
    email = map['email'];
    lifeExpectancyYears = map['lifeExpectancy']?.toString() ?? '50';
    dob = (map['dob'] != null ? DateTime.tryParse(map['dob']) : null)!;
  }

  void clear() {
    uid = '';
    firstName = '';
    lastName = '';
    username = '';
    email = '';
    lifeExpectancyYears = '50';
    createdAt = Timestamp.now();
    dob = DateTime(2000); // Default DOB
  }
}

UserModel userModel = UserModel();
