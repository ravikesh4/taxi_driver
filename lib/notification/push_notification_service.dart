import 'dart:io';

import 'package:drive_app/config.dart';
import 'package:drive_app/main.dart';
import 'package:drive_app/models/rideDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize() async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // getRideRequestId(message);
        retrieveRideRequestInfo(getRideRequestId(message));
        // _showItemDialog(message);
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // getRideRequestId(message);
        retrieveRideRequestInfo(getRideRequestId(message));
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // getRideRequestId(message);
        retrieveRideRequestInfo(getRideRequestId(message));
        // _navigateToItemDetail(message);
      },
    );
  }

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();
    print("this is token ${token}");
    driversRef.child(currentFirebaseUser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId;
    if(Platform.isAndroid) {
      // print('ride request id');
      rideRequestId = message['data']['ride_request_id'];
    } else {
      rideRequestId = message['ride_request_id'];
    }

    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId) {
    newRequestsRef.child(rideRequestId).once().then((DataSnapshot datasnapshot) {
      if (datasnapshot.value != null) {
        double pickUpLocationLat = double.parse(datasnapshot.value['pickup']['latitude'].toString());
        double pickUpLocationLng = double.parse(datasnapshot.value['pickup']['longitude'].toString());
        String pickUpAddress = datasnapshot.value['pickup_address'].toString();


        double dropOffLocationLat = double.parse(datasnapshot.value['dropoff']['latitude'].toString());
        double dropOffLocationLng = double.parse(datasnapshot.value['dropoff']['longitude'].toString());
        String dropOffAddress = datasnapshot.value['dropoff_address'].toString();

        String paymentMethod = datasnapshot.value['payment_method'].toString();

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;

        print('info ${rideDetails.pickup_address}');
        print('drop ${rideDetails.dropoff_address}');
        print('info ${rideDetails.payment_method}');

      }
    });
  }

}