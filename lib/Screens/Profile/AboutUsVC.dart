import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Screens/Profile/ProfileVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/AuthHandler.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsVC extends StatefulWidget {
  final String title;

  const AboutUsVC({super.key, required this.title});

  @override
  State<AboutUsVC> createState() => _AboutUsVCState();
}

class _AboutUsVCState extends State<AboutUsVC> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        backgroundColor: Colors.white,
        body: const SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Empowering Your Health Journey",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
              child: Text('     Welcome to Diab-Gulzar, your dedicated partner in managing and enhancing your overall well-being. Our app is meticulously crafted to assist individuals in monitoring and maintaining their blood sugar levels, medications, food intake, physical activity, steps, blood pressure, HbA1c, water consumption, weight logs, and lab test results.')
            ),
            Padding(
              padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Our Mission:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                child: Text('     At Diab-Gulzar, we are committed to empowering individuals living with diabetes and those on a journey towards better health. We believe in providing a comprehensive platform that not only tracks essential health metrics but also offers valuable insights and support for making informed lifestyle choices.')
            ),
            Padding(
              padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Key Features:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                child: SizedBox(
                    child: Column(
                      children: [
                         UnorderedListItemBold(
                            bold: "Blood Sugar Management:",
                            remaining: "Effortlessly track and analyze your blood sugar readings to better understand patterns and trends.",
                             NumberIn: '1', urlString: '', link: ''),
                        UnorderedListItemBold(
                            bold: "Medication Monitoring:",
                            remaining: "Never miss a dose with our medication tracking feature, ensuring you stay on top of your prescribed regimen.",
                            NumberIn: '2', urlString: '', link: ''),
                        UnorderedListItemBold(
                            bold: "Nutrition Tracker:",
                            remaining: "Log your daily meals and snacks to gain insights into how your diet impacts your health and blood sugar levels.",
                            NumberIn: '3', urlString: '', link: ''),
                        UnorderedListItemBold(
                            bold: "Activity and Steps Counter:",
                            remaining: "Monitor your physical activity and daily steps, promoting an active and healthy lifestyle.",
                            NumberIn: '4', urlString: '', link: ''),
                        UnorderedListItemBold(
                            bold: "Blood Pressure Monitoring:",
                            remaining: "Keep tabs on your blood pressure readings to maintain cardiovascular health.",
                            NumberIn: '5', urlString: '', link: ''),
                        UnorderedListItemBold(
                            bold: "HbA1c Tracking:",
                            remaining: "Track your HbA1c levels over time to assess long-term blood sugar control.",
                            NumberIn: '6', urlString: '', link: ''),
                        UnorderedListItemBold(
                            bold: "Hydration Tracker:",
                            remaining: "Stay hydrated by recording your daily water intake, a crucial aspect of overall health.",
                            NumberIn: '7', urlString: '', link: ''),
                        UnorderedListItemBold(
                            bold: "Weight Log:",
                            remaining: "Keep track of your weight changes, aiding in weight management and overall health improvement.",
                            NumberIn: '8', urlString: '', link: ''),
                        UnorderedListItemBold(
                            bold: "Lab Test Results:",
                            remaining: "Easily input and review your lab test results, fostering proactive health management.",
                            NumberIn: '9', urlString: '', link: ''),
                      ],
                    ))),
            Padding(
              padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Contact Us:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                child: SizedBox(
                    child: Column(
                      children: [
                        UnorderedListItemBold(
                            bold: "Phone:",
                            remaining: "",
                            NumberIn: '', urlString: 'tel://+919746007604', link: '+91 9746007604'),
                        UnorderedListItemBold(
                            bold: "Email:",
                            remaining: "",
                            NumberIn: '', urlString: 'mailto://gulzar.nabeel@gmail.com', link: 'gulzar.nabeel@gmail.com'),
                      ],
                    ))),
            Padding(
              padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Location:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 0,bottom: 15,left: 15,right: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text('Visit us at our office in')])
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text(
                    'Gulzar, Kannankadavu,\nKappad Post, Chemmancherry Via,\nKozhikode-673304,\nKerala, India.',
                    style: TextStyle(fontWeight: FontWeight.bold))])),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: SizedBox(
                    child: Column(
                  children: [
                    UnorderedListItemBold(NumberIn: '',bold: '',remaining: '\nYou can find our exact location on the map', link: ' here\n\n',urlString: 'https://maps.app.goo.gl/BeF5u3xgcfnNr6uC7',)
                  ],
                ))),
            Padding(
                padding: EdgeInsets.only(top: 0,bottom: 15,left: 15,right: 15),
                child: Text('Join the Diab-Gulzar community today and take charge of your health journey. We are here to support and guide you every step of the way. Your health is our priority!',maxLines: 10,)
            )
          ]),
        ));
  }
}

class UnorderedListItemBold extends StatelessWidget {

  final String NumberIn;
  final String bold;
  final String remaining;
  final String urlString;
  final String link;
  const UnorderedListItemBold({ Key? key, required this.NumberIn, required this.bold,  required this.remaining, required this.urlString, required this.link }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("${NumberIn} "),
        Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: bold,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: ' ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                      remaining),
                  TextSpan(
                    text: link, style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()..onTap = () async {
                      if (await canLaunch(urlString)){
                        await launch(urlString);
                      } else {
                        // can't launch url
                      }
                    },
                  )
                ],
              ),
            )),
      ],
    );
  }
}

// class LinkText extends StatelessWidget {
//   final String BeforeText;
//   final String Link;
//   final String AfterText;
//   final String urlString;
//
//   const LinkText(
//       {Key? key,
//       required this.BeforeText,
//       required this.Link,
//       required this.AfterText, required this.urlString})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text("${BeforeText} "),
//         Expanded(
//             child: RichText(
//           text: TextSpan(
//             children: <TextSpan>[
//               TextSpan(
//                   text: Link, style: TextStyle(color: Colors.blue),
//                 recognizer: TapGestureRecognizer()..onTap = () async {
//                   if (await canLaunch(urlString)){
//                   await launch(urlString);
//                   } else {
//                   // can't launch url
//                   }
//                 },
//               ),
//               TextSpan(
//                   text: ' ', style: TextStyle(fontWeight: FontWeight.bold)),
//               TextSpan(text: AfterText),
//             ],
//           ),
//         )),
//       ],
//     );
//   }
// }