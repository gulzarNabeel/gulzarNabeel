import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Screens/Profile/ProfileVC.dart';
import 'package:diabetes/Screens/TabBar/AccountVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/AuthHandler.dart';
import 'package:diabetes/Usables/FormattedStringWithLink.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DataContentVC extends StatefulWidget {
  final String title;
  final OptionAccount option;

  const DataContentVC({super.key, required this.title, required this.option});

  @override
  State<DataContentVC> createState() => _DataContentVCState();
}

class _DataContentVCState extends State<DataContentVC> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    print(widget.option);
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        backgroundColor: Colors.white,
        body: widget.option == OptionAccount.AboutUs ? AboutUsBody() : widget.option == OptionAccount.TermsAndConditions ? TermsAndConditionBody() : widget.option == OptionAccount.PrivacyAndPolicy ? PrivacyAndPolicyBody() : HelpBody());
  }
}

class AboutUsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
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
                    FormattedStringWithLink(
                        bold: "Blood Sugar Management:",
                        remaining: "Effortlessly track and analyze your blood sugar readings to better understand patterns and trends.",
                        NumberIn: '1', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Medication Monitoring:",
                        remaining: "Never miss a dose with our medication tracking feature, ensuring you stay on top of your prescribed regimen.",
                        NumberIn: '2', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Nutrition Tracker:",
                        remaining: "Log your daily meals and snacks to gain insights into how your diet impacts your health and blood sugar levels.",
                        NumberIn: '3', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Activity and Steps Counter:",
                        remaining: "Monitor your physical activity and daily steps, promoting an active and healthy lifestyle.",
                        NumberIn: '4', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Blood Pressure Monitoring:",
                        remaining: "Keep tabs on your blood pressure readings to maintain cardiovascular health.",
                        NumberIn: '5', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "HbA1c Tracking:",
                        remaining: "Track your HbA1c levels over time to assess long-term blood sugar control.",
                        NumberIn: '6', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Hydration Tracker:",
                        remaining: "Stay hydrated by recording your daily water intake, a crucial aspect of overall health.",
                        NumberIn: '7', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Weight Log:",
                        remaining: "Keep track of your weight changes, aiding in weight management and overall health improvement.",
                        NumberIn: '8', urlString: '', link: ''),
                    FormattedStringWithLink(
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
                    FormattedStringWithLink(
                        bold: "Phone:",
                        remaining: "",
                        NumberIn: '', urlString: 'tel://+919746007604', link: '+91 9746007604'),
                    FormattedStringWithLink(
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
                    FormattedStringWithLink(NumberIn: '',bold: '',remaining: '\nYou can find our exact location on the map', link: ' here\n\n',urlString: 'https://maps.app.goo.gl/BeF5u3xgcfnNr6uC7',)
                  ],
                ))),
        Padding(
            padding: EdgeInsets.only(top: 0,bottom: 15,left: 15,right: 15),
            child: Text('Join the Diab-Gulzar community today and take charge of your health journey. We are here to support and guide you every step of the way. Your health is our priority!\n\n\n',maxLines: 10,)
        )
      ]),
    );
  }
}

class TermsAndConditionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("1. Acceptance of Terms",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('By accessing or using the Diab-Gulzar mobile application, you agree to comply with and be bound by these Terms and Conditions. If you do not agree with any part of these terms, you may not use the App.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("2. Health Information Disclaimer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('The App provides tools for managing health details related to diabetes, including blood sugar, blood pressure, weight, food, water intake, HbA1c, lab tests, and medication. The information provided by the App is for general informational purposes only and should not be considered as medical advice. Consult with your healthcare provider for personalized advice.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("3. User Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('You may be required to create a user account to access certain features of the App. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("4. Privacy and Data Security",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('We take your privacy seriously. Please review our Privacy Policy for information on how we collect, use, and protect your personal information.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("5. User Responsibilities",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('a. You agree to provide accurate and complete information when using the App.\nb. You are solely responsible for the use of the App and any consequences that result from it.\nc. Do not share your account credentials with others.\nd. Report any unauthorized use of your account immediately.')
                 ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("6. Medical Emergencies",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('The App is not a substitute for professional medical advice, diagnosis, or treatment. In case of a medical emergency, contact your healthcare provider or emergency services.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("7. App Updates and Changes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('We may update or change the features of the App from time to time. You agree to accept these updates as part of your use of the App.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("8. Termination of Access",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('We reserve the right to terminate or suspend your access to the App without prior notice for any reason, including violation of these terms.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("9. Limitation of Liability",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('To the maximum extent permitted by law, the App provider shall not be liable for any direct, indirect, incidental, special, or consequential damages resulting from the use or inability to use the App.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("10. Governing Law",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('These terms and conditions are governed by and construed in accordance with the laws of India.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("11. Contact Information",
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
                    FormattedStringWithLink(
                        bold: "",
                        remaining: 'For any questions or concerns regarding these terms, please contact us at ',
                        NumberIn: '', urlString: 'tel://+919746007604', link: '+91 9746007604'),
                    FormattedStringWithLink(
                        bold: "",
                        remaining: 'or ',
                        NumberIn: '', urlString: 'mailto://gulzar.nabeel@gmail.com', link: 'gulzar.nabeel@gmail.com'),
                  ],
                ))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('\n\nBy using the Diab-Gulzar App, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions.\n\nLast updated: 01/01/2024\n\n\n'
            ))
      ]),
    );
  }
}

class PrivacyAndPolicyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(children: [
        Padding(
            padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Text('Last Updated: 01/01/2024')])
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("1. Introduction",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('Diab-Gulzar is committed to protecting the privacy and security of your personal information. This Privacy Policy outlines how we collect, use, and disclose information when you use our mobile application to manage health details related to diabetic control, including but not limited to blood sugar, blood pressure, weight, food, water intake, HbA1c, lab tests, and medication.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("2. Information We Collect",
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
                    FormattedStringWithLink(
                        bold: "Personal Information:",
                        remaining: "\nWe may collect personal information, such as your name, email address, and other information you provide when setting up your account.",
                        NumberIn: 'a.', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Health Information:",
                        remaining: "\nThe App collects and stores health-related information, including blood sugar levels, blood pressure, weight, food and water intake, HbA1c, lab test results, and medication details.",
                        NumberIn: 'b.', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Device Information:",
                        remaining: "We may collect information about the device you use to access the App, such as device type, operating system, and unique device identifiers.",
                        NumberIn: 'c.', urlString: '', link: ''),
                  ],
                ))),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("3. How We Use Your Information",
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
                    FormattedStringWithLink(
                        bold: "Health Management:",
                        remaining: "\nWe use the information you provide to help you manage your health, track progress, and provide personalized insights and recommendations.",
                        NumberIn: 'a.', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Communication:",
                        remaining: "\nWe may use your email address to send you important updates, notifications, and newsletters related to the App.",
                        NumberIn: 'b.', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Research and Analytics:",
                        remaining: "We may anonymize and aggregate data for research and analytical purposes to improve our services and better understand user trends.",
                        NumberIn: 'c.', urlString: '', link: ''),
                  ],
                ))),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("4. Data Sharing and Disclosure",
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
                    FormattedStringWithLink(
                        bold: "Service Providers:",
                        remaining: "\nWe may share your information with third-party service providers who assist us in delivering and improving our services.",
                        NumberIn: 'a.', urlString: '', link: ''),
                    FormattedStringWithLink(
                        bold: "Legal Compliance:",
                        remaining: "\nWe may disclose your information if required by law or in response to a valid legal request.",
                        NumberIn: 'b.', urlString: '', link: '')
                  ],
                ))),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("5. Security",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('We implement reasonable security measures to protect the confidentiality and integrity of your information. However, no data transmission over the internet or method of electronic storage is 100% secure.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("6. Your Choices",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('You have the right to access, correct, or delete your personal information. You can manage your preferences within the App settings.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("7. Changes to this Privacy Policy",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('We reserve the right to update this Privacy Policy at any time. We will notify you of any changes by posting the new Privacy Policy on this page.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("8. Contact Us",
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
                    FormattedStringWithLink(
                        bold: "",
                        remaining: 'If you have any questions or concerns about this Privacy Policy, please contact us at ',
                        NumberIn: '', urlString: 'tel://+919746007604', link: '+91 9746007604'),
                    FormattedStringWithLink(
                        bold: "",
                        remaining: 'or ',
                        NumberIn: '', urlString: 'mailto://gulzar.nabeel@gmail.com', link: 'gulzar.nabeel@gmail.com'),
                  ],
                ))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('\n\n\n'
            ))
      ]),
    );
  }
}

class HelpBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("1. Acceptance of Terms",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('By accessing or using the Diab-Gulzar mobile application, you agree to comply with and be bound by these Terms and Conditions. If you do not agree with any part of these terms, you may not use the App.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("2. Health Information Disclaimer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('The App provides tools for managing health details related to diabetes, including blood sugar, blood pressure, weight, food, water intake, HbA1c, lab tests, and medication. The information provided by the App is for general informational purposes only and should not be considered as medical advice. Consult with your healthcare provider for personalized advice.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("3. User Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('You may be required to create a user account to access certain features of the App. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("4. Privacy and Data Security",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('We take your privacy seriously. Please review our Privacy Policy for information on how we collect, use, and protect your personal information.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("5. User Responsibilities",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('a. You agree to provide accurate and complete information when using the App.\nb. You are solely responsible for the use of the App and any consequences that result from it.\nc. Do not share your account credentials with others.\nd. Report any unauthorized use of your account immediately.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("6. Medical Emergencies",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('The App is not a substitute for professional medical advice, diagnosis, or treatment. In case of a medical emergency, contact your healthcare provider or emergency services.')
        ),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("7. App Updates and Changes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('We may update or change the features of the App from time to time. You agree to accept these updates as part of your use of the App.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("8. Termination of Access",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('We reserve the right to terminate or suspend your access to the App without prior notice for any reason, including violation of these terms.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("9. Limitation of Liability",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('To the maximum extent permitted by law, the App provider shall not be liable for any direct, indirect, incidental, special, or consequential damages resulting from the use or inability to use the App.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("10. Governing Law",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('These terms and conditions are governed by and construed in accordance with the laws of India.'
            )),
        Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("11. Contact Information",
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
                    FormattedStringWithLink(
                        bold: "",
                        remaining: 'For any questions or concerns regarding these terms, please contact us at ',
                        NumberIn: '', urlString: 'tel://+919746007604', link: '+91 9746007604'),
                    FormattedStringWithLink(
                        bold: "",
                        remaining: 'or ',
                        NumberIn: '', urlString: 'mailto://gulzar.nabeel@gmail.com', link: 'gulzar.nabeel@gmail.com'),
                  ],
                ))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
            child: Text('\n\nBy using the Diab-Gulzar App, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions.\n\nLast updated: 01/01/2024\n\n\n'
            ))
      ]),
    );
  }
}
