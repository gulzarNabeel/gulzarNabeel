

import 'package:diabetes/Usables/Utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final hamburgerMenu = Drawer(
  child: ListView(
    children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text(
          "${Utility().getUserData().name.isEmpty ? "User" : Utility().getUserData().name}",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w700,
            fontFamily: "Roboto",
            fontStyle: FontStyle.italic,
          ),
        ),
        accountEmail: Text("From: ${DateFormat('hh:mm a, dd/MM/yyyy').format(Utility().getUserData().creationDate)}",
            style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
                fontSize: 16.0)),
        currentAccountPicture: GestureDetector(
          onTap: (){

          },
          child: ClipOval(
            child: Utility().getUserData().profilePictureUrl.length > 0 ? Image.network(Utility().getUserData().profilePictureUrl) : Image(image: AssetImage('Assets/appicon.png')),
          ),
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/blue_bar.jpg"))),
      ),
      ListTile(
          title: Text(
            "Version Number: 0.21",
            style: TextStyle(
              color: Colors.red[400],
              fontWeight: FontWeight.w700,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
            ),
          ),
          trailing: Icon(Icons.done)),
      ListTile(
          title: Text(
            "Log out",
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w700,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
            ),
          ),
          trailing: Icon(Icons.offline_bolt),
          onTap: () => print('')),
      Divider(),
      ListTile(
        title: Text(
          "Close",
          style: TextStyle(
            color: Colors.grey[400],
            fontWeight: FontWeight.w700,
            fontFamily: "Roboto",
            fontStyle: FontStyle.normal,
          ),
        ),
        trailing: Icon(Icons.cancel),
        onTap: (){

        },
      ),
      // connectToRetailer
    ],
  ),
);