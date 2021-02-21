import 'package:flutter/material.dart';
import 'package:drive_app/models/address.dart';

class AppData extends ChangeNotifier{

  Address pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }

}
