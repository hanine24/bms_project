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
    _gpsData = await FireBaseService(
      appProvider: _appProvider,
    ).getGpsDataFromFireBase();
    setState(() {
      _mapCenter = LatLng(_gpsData[0].lat!, _gpsData[0].lng!);
    });
    print("gpsData:${_gpsData}");

    return _gpsData;
  }

  Future<List<Bms>> _getBmsData() async {
    _bmsData = await FireBaseService(
      appProvider: _appProvider,
    ).getBmsDataFromFireBase();
    print("bmsData:${_bmsData}");
    return _bmsData;
  }

  late bool isMapCreated = false;
Widget googleMapUI() {
  _appProvider = Provider.of<AppProvider>(context);
  final bms = _bmsData.isNotEmpty ? _bmsData[0] : Bms(soc: 0, temp: 0, courant: 0, tension: 0);
  final gps = _gpsData.isNotEmpty ? _gpsData[0] : Position(lat: 0.0, lng: 0.0);

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "BMS Realtime Data",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.battery_charging_full, color: Colors.blue),
                title: const Text("State of Charge (SOC)"),
                trailing: Text("${bms.soc}%"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.thermostat, color: Colors.red),
                title: const Text("Temperature"),
                trailing: Text("${bms.temp} °C"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.orange),
                title: const Text("Current"),
                trailing: Text("${bms.courant} A"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.power, color: Colors.green),
                title: const Text("Voltage"),
                trailing: Text("${bms.tension} V"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "GPS Location",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.purple),
                title: const Text("Latitude"),
                trailing: Text("${gps.lat}"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.location_searching, color: Colors.purpleAccent),
                title: const Text("Longitude"),
                trailing: Text("${gps.lng}"),
              ),
            ],
          ),
        ),
      ],
    ),
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
              colors: [Color.fromARGB(255, 247, 132, 1), Color.fromARGB(255, 219, 5, 5)],
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
