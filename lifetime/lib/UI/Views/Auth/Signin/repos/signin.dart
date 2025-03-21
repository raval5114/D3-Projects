import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lifetime/Data/Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences prefs;
  Signin() {
    initPrefs();
  }
  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        debugPrint("Sign-in   Success: ${userCredential.user?.email}");
        DocumentSnapshot doc =
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .get();

        if (doc.exists) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
          debugPrint("User Data: $userData");

          userModel = UserModel.fromMap(userData);
          debugPrint("User");
          prefs.setString('email', email);
          prefs.setString('password', password);
        } else {
          debugPrint("No user data found in Firestore.");
        }

        return true;
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      switch (e.code) {
        case 'invalid-email':
          errorMsg = "The email address is not valid.";
          break;
        case 'user-disabled':
          errorMsg = "This user has been disabled.";
          break;
        case 'user-not-found':
          errorMsg = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMsg = "Incorrect password.";
          break;
        case 'too-many-requests':
          errorMsg = "Too many failed attempts. Try again later.";
          break;
        case 'network-request-failed':
          errorMsg = "Network error. Check your connection.";
          break;
        default:
          errorMsg = "Sign-in failed: ${e.message}";
      }
      debugPrint("Sign-in Error: $errorMsg");
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception("Sign-in failed: $e");
    }
    return false;
  }

  /// Logs out the user from Firebase and clears stored login credentials.
  Future<void> signOut() async {
    try {
      await _auth.signOut(); // Sign out from Firebase
      userModel.clear();
      await prefs.clear(); // Clear stored login data
      debugPrint("User successfully logged out.");
    } catch (e) {
      debugPrint("Logout Error: $e");
      throw Exception("Logout failed: $e");
    }
  }
}
