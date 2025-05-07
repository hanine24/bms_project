
import '../models/Bms.dart';
import '../models/Position.dart';
import '../services/firebase_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;

class AppProvider with ChangeNotifier {
  List<Position> _gpsData = [];
  List<Bms> _bmsData = [];

  initialization() async {
    await FireBaseService(appProvider: this).getGpsDataFromFireBase();
    await FireBaseService(appProvider: this).getBmsDataFromFireBase();
  }

  setGpsData(gpsData) {
    _gpsData = gpsData;
    notifyListeners();
  }

  setBmsData(bmsData) {
    _bmsData = bmsData;
    notifyListeners();
  }

  List<Position> getGpsData() => _gpsData;
    List<Bms> getbmsData() => _bmsData;

}
