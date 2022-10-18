import 'package:flutter/material.dart';

class GlobalService extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState>? globalServiceKey() {
    return _scaffoldKey;
  }
}
