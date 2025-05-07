import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/Bms.dart';
import 'package:flutter_application_1/models/Position.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../services/firebase_api.dart';

class BmsHome extends StatefulWidget {
  const BmsHome({super.key});

  @override
  State<BmsHome> createState() => _BmsHomeState();
}

class _BmsHomeState extends State<BmsHome> with WidgetsBindingObserver {
  List<Position> _gpsData = [];
  List<Bms> _bmsData = [];
  late AppProvider _appProvider;
  bool waitingForResponse = false;
  late int gpsDataLength;
  late LatLng _mapCenter = const LatLng(33.8869, 9.5375);

  late Timer timer = Timer(const Duration(minutes: 2), () {});

  @override
  void initState() {
    super.initState();
    Provider.of<AppProvider>(context, listen: false).initialization();

    WidgetsBinding.instance.addObserver(this);
    // Adding an observer
    setTimer(); // Setting a timer on init
  }

  @override
  void dispose() {
    timer.cancel();
    // Cancelling a timer on dispose
    WidgetsBinding.instance.removeObserver(this); // Removing an observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setTimer();
  }

  void setTimer() async {
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    int delaySeconds = 3;

    timer.cancel();

    // Cancelling previous timer, if there was one, and creating a new one

    timer = Timer.periodic(Duration(seconds: delaySeconds), (t) async {
      // Not sending a request, if waiting for response
      if (!waitingForResponse) {
        waitingForResponse = true;
        await post();

        waitingForResponse = false;
      }
    });
  }

  // Async method returns Future<> object
  Future<void> post() async {
    setState(() {
      gpsDataLength = _gpsData.length;
    });
    initScreen();
    setTimer();
  }

  Future<void> initScreen() async {
    _appProvider = Provider.of<AppProvider>(context, listen: false);
    await _getGpsData().then((value) => {_gpsData = _appProvider.getGpsData()});
    await _getBmsData().then((value) => {_bmsData = _appProvider.getbmsData()});
  }

  Future<List<Position>> _getGpsData() async {
    _gpsData =
        await FireBaseService(
          appProvider: _appProvider,
        ).getGpsDataFromFireBase();
    setState(() {
      _mapCenter = LatLng(_gpsData[0].lat!, _gpsData[0].lng!);
    });
        print("gpsData:${_gpsData}");

    return _gpsData;
  }

  Future<List<Bms>> _getBmsData() async {
    _bmsData =
        await FireBaseService(
          appProvider: _appProvider,
        ).getBmsDataFromFireBase();
    print("bmsData:${_bmsData}");
    return _bmsData;
  }

  late bool isMapCreated = false;

  Widget googleMapUI() {
    _appProvider = Provider.of<AppProvider>(context);

    return Consumer<AppProvider>(
      builder: (consumerContext, model, child) {
        return Column(
          children: [
            Expanded(
              child: Container(child: Column(children: [Text("${_bmsData.length}")])),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    _gpsData = _appProvider.getGpsData();
    _bmsData = _appProvider.getbmsData();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1270E3), Color(0xFF59C2FF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF149cf7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushNamed('/home'),
        ),
        title: const Text("BMS APP"),
      ),

      body: googleMapUI(),
    );
  }
}
