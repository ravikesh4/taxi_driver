import 'dart:async';

import 'package:drive_app/config.dart';
import 'package:drive_app/main.dart';
import 'package:drive_app/notification/push_notification_service.dart';
import 'package:drive_app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainTabPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _MainTabPageState createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController newGoogleMapController;

  Position currentPosition;

  var geoLocator = Geolocator();

  String driverStatusText = 'Offline';

  Color driverStatusColor = Colors.black;

  bool isDriverAvailable = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDriverInfo();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
    new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address =
    // await AssistantMethods.searchCoordinateAddress(position, context);
    // print("This is your address $address");
  }

  void getCurrentDriverInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize();
    pushNotificationService.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: MainTabPage._kGooglePlex,
          mapToolbarEnabled: true,
          // zoomGesturesEnabled: true,
          // zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),

        // online and offline driver
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),

        Positioned(
          top: 60.0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: RaisedButton(onPressed: () {
                  // displayRequestRideContainer();
                  if(isDriverAvailable != true) {
                    makeDriverOnlineNow();
                    getLocationLiveUpdates();

                    setState(() {
                      driverStatusColor = Colors.green;
                      driverStatusText = 'Online';
                      isDriverAvailable = true;
                    });
                    displayToastMessage('Your are online now', context);
                  } else {
                    makeDriverOfflineNow();
                    setState(() {
                      driverStatusColor = Colors.black;
                      driverStatusText = 'Offline';
                      isDriverAvailable = false;
                    });
                    displayToastMessage('Your are offline now', context);
                  }
                },
                  color: driverStatusColor,
                  child: Row(
                    children: [
                      Text( driverStatusText, style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
                      ),),
                      Icon(Icons.phone_android, color: Colors.white, size: 26,),
                    ],
                  ),

                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void makeDriverOnlineNow() async{

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    rideRequestRef.onValue.listen((event) {

    });
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((position) {
      currentPosition = position;
      if(isDriverAvailable == true) {
        Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOfflineNow() {

      Geofire.removeLocation(currentFirebaseUser.uid);
      rideRequestRef.onDisconnect();
      rideRequestRef.remove();
      rideRequestRef = null;

  }
}
