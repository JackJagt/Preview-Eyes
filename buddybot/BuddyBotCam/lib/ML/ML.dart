import 'dart:convert';

import 'package:buddy_bot_cam/VisionDetectorViews/face_detector_view.dart';
import 'package:flutter/material.dart';
import 'package:teachable/teachable.dart';
 

class ML extends StatefulWidget {
  late final String title;

  @override
  _MLState createState() => _MLState();

}

class _MLState extends State<ML> {
  int pose1 = 0; // percentage answer 1
  int pose2 = 0; // percentage answer 2
  int pose3 = 0; // percentage of the most true answer

  String label = "Loading"; // waiting until ML loaded

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Your answer")),
        body: Stack(
          children: [
            Container(
                child: Column(children: <Widget>[
              Expanded(
                child: Container(
                  child: Teachable(
                    path: "pose/index.html", // path  to model ml
                    results: (res) {
                      var resp = jsonDecode(res);

                      setState(() {
                        pose1 = (resp['Ja'] * 100.0).round(); //percentage answer 1
                        pose2 = (resp['Niks'] * 100.0).round(); //percentage answer 2

                        // if the value of pose 1 (yes) is greater than pose 2 (nothing) and the answer is therefore yes
                        if (pose1 > pose2) {
                          pose3 = pose1;
                          label = "Yes";

                          //go back to FaceDetectorView if the answer is yes
                          //Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => FaceDetectorView()),
                          );
                        }

                        // if the answer is nothing or no
                        else{
                          pose3 = pose2;
                          label = "Nothing";
                        }
                      });
                    },
                  ),
                ),
              ),
            ])),

            // print the answer
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {

                              Navigator.pop(context);
                            },
                            child: const Text('Start Event'),
                          ),
                         //ext(
                           //ose3.toString(),
                            //yle: TextStyle(
                           // color: Colors.white,
                           //,
                        //),
                        ]
                      ),
                    ],
                  )),
            )
          ],
        ));
  }

}
