import 'dart:ffi';
import 'package:carease/Database/badges.dart';
import 'package:carease/Database/worker_roles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class WorkerDetails {
  String name = "";
  String phoneNumber = "";
  String shopName = "";
  GeoPoint shopLocation = GeoPoint(0, 0);
  String shopOpenTime = "";
  String shopCloseTime = "";
  List<bool> workingDays = [true,true,true,true,true,true,true];
  List<BadgeDetails>? badges = [];
  double currentRating = 0.1;
  bool activeStatus = true;
  int profileViewsCount = 0;
  List<WorkerRoles>? servicesProvided = [];
}

class WorkerData{
  static WorkerData instance = WorkerData._internal();
  final WorkerDetails currentWorker = WorkerDetails();

  factory WorkerData() {
    return instance;
  }

  WorkerData._internal();

  Future<void> uploadWorkerDetails() async {
    await _firestore.collection('workers').doc(currentWorker.phoneNumber).set({
      'name': currentWorker.name,
      'phoneNumber': currentWorker.phoneNumber,
      'shopName' : currentWorker.shopName,
      'shopLocation' : currentWorker.shopLocation,
      'shopOpenTime' : currentWorker.shopOpenTime,
      'shopCloseTime' : currentWorker.shopCloseTime,
      'workingDays' : currentWorker.workingDays,
    });
  }

  Future<void> fetchWorkerDetails() async{

  }
}