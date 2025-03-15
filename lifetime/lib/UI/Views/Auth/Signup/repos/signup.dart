import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Signup {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    String username,
    String dob,
  ) async {
    try {
      // Create user with email & password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        // Store additional user data in Firestore
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": user.email,
          "username": username,
          "firstName": firstName,
          "lastName": lastName,
          "dob": dob,
          "createdAt": FieldValue.serverTimestamp(),
        });

        debugPrint("Sign-up Success: ${user.email}");
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("This email is already registered. Please log in.");
      } else if (e.code == 'invalid-email') {
        throw Exception("Invalid email format. Please enter a valid email.");
      } else if (e.code == 'weak-password') {
        throw Exception("Your password is too weak. Use a stronger password.");
      } else if (e.code == 'operation-not-allowed') {
        throw Exception("Email/password sign-up is disabled. Contact support.");
      } else {
        throw Exception("FirebaseAuth Error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected Error: $e");
    }
  }
}
