import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FormattedStringWithLink extends StatelessWidget {
  final String NumberIn;
  final String bold;
  final String remaining;
  final String urlString;
  final String link;

  const FormattedStringWithLink(
      {Key? key,
      required this.NumberIn,
      required this.bold,
      required this.remaining,
      required this.urlString,
      required this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("${NumberIn} "),
        Expanded(
            child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: bold, style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: remaining),
              TextSpan(
                text: link,
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (await canLaunch(urlString)) {
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
