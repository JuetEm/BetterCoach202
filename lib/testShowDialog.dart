import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_project/action_service.dart';
import 'package:web_project/globalWidgetDashboard.dart';
import 'package:web_project/sign_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
  Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(actions: []),
        body: Container(
          padding: EdgeInsets.all(32),
          child: ElevatedButton(
            child: Text('Open Dialog'),
            onPressed: (() {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Your Name"),
                  content: TextField(
                    decoration: InputDecoration(hintText: 'Enter'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: Text('submit'),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      );
}
