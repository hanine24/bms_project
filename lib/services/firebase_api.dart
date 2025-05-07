import 'dart:convert';
import 'dart:developer';

import 'package:flutter_application_1/models/Bms.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/Position.dart';
import '../providers/app_provider.dart';

class FireBaseService {
  final AppProvider appProvider;
  final fireBaseClient = http.Client();
  FireBaseService({required this.appProvider});

  Future<List<Position>> getGpsDataFromFireBase({counter = 0}) async {
    http.Response? response;

    try {
      response = await fireBaseClient.get(
        Uri.parse(
          "https://bmsapp-b3476-default-rtdb.europe-west1.firebasedatabase.app/gps_data/-OPe0uhOPIuJxk88izYU.json",
        ),
      );

      final position = <Position>[];

      var data = json.decode(response.body);

      for (var item in data.keys) {
        var e = Position(lat: data[item]['lat'], lng: data[item]['lng']);

        position.add(e);
      }

      appProvider.setGpsData(position);
      return position;

      //    appProvider.setTrips(_trips);
    } catch (e) {
      if (counter < 10) {
        counter += 1;
        return getGpsDataFromFireBase(counter: counter);
      } else {
        List<Position> oldList = appProvider.getGpsData();
        return oldList;
      }
    }
  }

  Future<List<Bms>> getBmsDataFromFireBase({counter = 0}) async {
    http.Response? response;
    try {
      response = await fireBaseClient.get(
        Uri.parse(
          "https://bmsapp-b3476-default-rtdb.europe-west1.firebasedatabase.app/bms_data/-OPe14hGrnZnQazME6MH.json",
        ),
      );

      final bms = <Bms>[];

      var data = json.decode(response.body);

      for (var item in data.keys) {
            print(" data temp:${data[item]}");

        var e = Bms(
          temp: data[item]['temp'],
          tension: data[item]['tension'],
          courant: data[item]['courant'],
          soc: data[item]['soc'],
        );

        bms.add(e);
      }
    print("enter to get bms data");

      appProvider.setBmsData(bms);
      return bms;

      //    appProvider.setTrips(_trips);
    } catch (e) {
      if (counter < 10) {
        counter += 1;
        return getBmsDataFromFireBase(counter: counter);
      } else {
        List<Bms> oldList = appProvider.getbmsData();
        return oldList;
      }
    }
  }
}
