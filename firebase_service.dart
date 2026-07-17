import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oran_ride/models/user_model.dart';

class FirebaseService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Stream of current user state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with Email & Password (Algerian Oran Context)
  Future<UserModel?> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
    String vehicleType = '',
    String vehicleModel = '',
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      UserModel newUser = UserModel(
        uid: cred.user!.uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
        isVerified: role == 'rider', // Riders are auto-vetted; drivers need document checks
        vehicleType: vehicleType,
        vehicleModel: vehicleModel,
      );

      await _db.collection('users').doc(cred.user!.uid).set(newUser.toMap());
      _currentUser = newUser;
      notifyListeners();
      return newUser;
    } catch (e) {
      debugPrint("Auth Error: ${e.toString()}");
      rethrow;
    }
  }

  // Login
  Future<UserModel?> loginUser(String email, String password) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    DocumentSnapshot snap = await _db.collection('users').doc(cred.user!.uid).get();
    
    if (snap.exists) {
      _currentUser = UserModel.fromMap(snap.data() as Map<String, dynamic>);
      notifyListeners();
      return _currentUser;
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
