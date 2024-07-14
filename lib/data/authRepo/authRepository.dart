import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

abstract class AuthRepository {
  User? get currentUser;
  Future<User?> login(String email, String password);
  Future<User?> signup(String username, String email, String password, String phonenumber);
  void logout();
  Future<UserModel?> fetchUserData(String uid);
}