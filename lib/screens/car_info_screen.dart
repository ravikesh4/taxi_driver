
import 'package:drive_app/config.dart';
import 'package:drive_app/main.dart';
import 'package:drive_app/screens/main_screen.dart';
import 'package:drive_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CarInfoScreen extends StatelessWidget {

  TextEditingController carModelController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController carColorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 22,),
            Image.asset('assets/images/logo.png', width: 300, height: 250,),
            Padding(padding: EdgeInsets.fromLTRB(22, 22, 22, 32),
            child: Column(
              children: [
                SizedBox(height: 12,),
                Text("Enter car details", style: TextStyle(fontSize: 24),),
                SizedBox(height: 24,),
                TextField(
                  controller: carModelController,
                  decoration: InputDecoration(
                    labelText: 'Car Model',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 15
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: carNumberController,
                  decoration: InputDecoration(
                    labelText: 'Car Number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: carColorController,
                  decoration: InputDecoration(
                    labelText: 'Car Color',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
                SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: RaisedButton(onPressed: () {
                    // displayRequestRideContainer();
                    if(carModelController.text.isEmpty) {
                      displayToastMessage('Car model required.', context);
                    } else if(carNumberController.text.isEmpty) {
                      displayToastMessage('Car number required.', context);
                    } else if(carColorController.text.isEmpty) {
                      displayToastMessage('Car color required.', context);
                    } else {
                      saveDriverCarInfo(context);
                    }

                  },
                    child: Row(
                      children: [
                        Text('Next', style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
                        ),),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 26,),
                      ],
                    ),

                  ),
                ),
              ],
            ),
            ),
          ],
        ),
      )),
    );
  }

  void saveDriverCarInfo(context) {
    String userId = currentFirebaseUser.uid;

    Map carInfoMap = {
      "car_color": carColorController.text,
      "car_number": carNumberController.text,
      "car_model": carModelController.text,
    };

    driversRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(),));
  }
}
