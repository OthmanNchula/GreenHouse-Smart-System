class UserModel {
  String id;
  String username;
  String email;
  String phonenumber;

  UserModel({required this.id, required this.username, required this.email, required this.phonenumber});

  // Factory method to create a UserModel from a Firestore document
  factory UserModel.fromDocument(Map<String, dynamic> doc, String docId) {
    return UserModel(
      id: docId,
      username: doc['username'] ?? '',
      email: doc['email'] ?? '',
      phonenumber: doc['phonenumber'] ?? '',
    );
  }

  // Method to convert a UserModel to a map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'phonenumber': phonenumber,
    };
  }
}
