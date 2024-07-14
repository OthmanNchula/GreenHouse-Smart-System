import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import 'authRepository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<User?> signup(String username, String email, String phonenumber ,String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(username);
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
          'phonenumber': phonenumber,
        });
      }
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void logout() {
    _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }
}
