import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UserDetails {
  String? name;
  String? phoneNumber;
  GeoPoint? location;
}

class UserData{
  static UserData instance = UserData._internal();
  final UserDetails currentUser = UserDetails();

  factory UserData() {
    return instance;
  }

  UserData._internal();

  Future<void> uploadUserDetails(String phoneNumber) async {
    await _firestore.collection('users').doc(phoneNumber).set({
      'name': currentUser.name,
      'phoneNumber': currentUser.phoneNumber,
      'location' : currentUser.location,
    });
  }

  Future<void> fetchUserDetails(String phoneNumber) async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(phoneNumber)
          .get();

      if (userDoc.exists) {
        currentUser.name = userDoc['name'];
        currentUser.phoneNumber = userDoc['phoneNumber'];
        currentUser.location = userDoc['location'];
      }
    }
  }
}