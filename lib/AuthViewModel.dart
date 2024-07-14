import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/resource.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Resource<User?> _authState = Resource.loading();
  Resource<User?> get authState => _authState;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _authState = Resource.success(userCredential.user);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _authState = Resource.failure(e);
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _authState = Resource.failure(e as Exception);
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String email, String password, String phoneNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateProfile(displayName: phoneNumber); // Use displayName for storing phone number
      _authState = Resource.success(userCredential.user);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _authState = Resource.failure(e);
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _authState = Resource.failure(e as Exception);
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    await _firebaseAuth.signOut();
    _authState = Resource.success(null);
    notifyListeners();
  }
}
