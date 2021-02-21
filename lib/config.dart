
// String mapKey = "AIzaSyCqQYZF8vuFn4onUkWeFq2GY12Trv47r1sivar";
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drive_app/models/all_users.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyAXhk1498g3ORPHcP6Wytkouh0Mn28obVo";

User firebaseUser;

Users userCurrentInfo;

User currentFirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;
