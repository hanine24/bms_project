import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMS Daly Smart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          secondary: Colors.orangeAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(221, 172, 20, 20),
          foregroundColor: Colors.white,
          elevation: 5,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 20, color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      _isLoading = true;
    });

    // Simuler une connexion
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Navigation vers la page principale
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BMSDalyHome()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Icon(
                Icons.battery_full,
                size: 80,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                "BMS Daly Smart",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('CONNEXION', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Naviguer vers une page de récupération de mot de passe
                },
                child: const Text(
                  'Mot de passe oublié?',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BMSDalyHome extends StatefulWidget {
  const BMSDalyHome({Key? key}) : super(key: key);

  @override
  _BMSDalyHomeState createState() => _BMSDalyHomeState();
}

class _BMSDalyHomeState extends State<BMSDalyHome> {
  int _currentIndex = 0;
  String _username = "Utilisateur";

  final List<Widget> _pages = [
    const BatteryDashboard(),
    const BatteryHistory(),
    const GPSPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Row(
        children: [
          Icon(Icons.battery_full, color: Colors.white),
          SizedBox(width: 8),
          Text("BMS Daly", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.info, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BatteryDetails()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Alerte de Notification"),
                  content: const Text("C'est une notification de test."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Fermer"),
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            _showUserProfileDialog(context);
          },
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          _showMenuDialog(context);
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "Historique"),
        BottomNavigationBarItem(icon: Icon(Icons.gps_fixed), label: "GPS"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Paramètres"),
      ],
    );
  }

  void _showUserProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Profil de $_username"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text("$_username", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              const Text("BMS Daly Smart - Utilisateur")
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fermer"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text("Déconnexion"),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Êtes-vous sûr de vouloir vous déconnecter?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Retourner à l'écran de connexion
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text("Déconnexion"),
            ),
          ],
        );
      },
    );
  }

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Menu"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('Profil: $_username'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showUserProfileDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Paramètres'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('À propos'),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: "BMS Daly Smart",
                      applicationVersion: "1.0.0",
                      applicationIcon: const Icon(Icons.battery_full, size: 40),
                      children: [const Text("Application de gestion de batterie BMS Daly")],
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _confirmLogout(context);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Le reste des classes reste inchangé mais est inclus pour compléter le code

class BatteryDashboard extends StatefulWidget {
  const BatteryDashboard({Key? key}) : super(key: key);

  @override
  State<BatteryDashboard> createState() => _BatteryDashboardState();
}

class _BatteryDashboardState extends State<BatteryDashboard> {
  final Random random = Random();

  double batteryVoltage = 48.5;
  double batteryCurrent = 0.0;
  double batteryPower = 0.0;
  double batterySoC = 50.0;
  double batterySoH = 95.0;
  double batteryTemperature = 32.0;
  int chargeCycles = 100;
  bool isBalanced = false;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    _simulateBatteryData();

    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      _simulateBatteryData();
    });
  }

  void _simulateBatteryData() {
    setState(() {
      batteryCurrent = random.nextDouble() * 10;
      batteryPower = batteryVoltage * batteryCurrent;
      batterySoC = (batterySoC - random.nextDouble()).clamp(0, 100);
      batteryTemperature = 30 + random.nextDouble() * 10;
      chargeCycles = 100 + random.nextInt(400);
      isBalanced = random.nextBool();

      if (batterySoC < 20) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLowBatteryAlert(context);
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Tableau de bord Batterie"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.electrical_services, color: Colors.redAccent, size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Statistiques Générales",
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                      ),
                      Text(
                        "Mis à jour en temps réel",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildPieChart("État de Charge (SoC)", batterySoC, Colors.green),
            const SizedBox(height: 16),
            _buildPieChart("État de Santé (SoH)", batterySoH, Colors.orange),
            const SizedBox(height: 16),
            _buildLineChart("Tension (V)", batteryVoltage),
            const SizedBox(height: 16),
            _buildLineChart("Courant (A)", batteryCurrent),
            const SizedBox(height: 16),
            _buildInfoCard("Puissance", "${batteryPower.toStringAsFixed(2)} W", Icons.power, Colors.green),
            _buildInfoCard("Température", "${batteryTemperature.toStringAsFixed(1)} °C", Icons.thermostat, Colors.redAccent),
            _buildInfoCard("Cycles de charge", "$chargeCycles", Icons.replay, Colors.purple),
            _buildInfoCard("Équilibrage", isBalanced ? "Actif" : "Inactif", Icons.equalizer, isBalanced ? Colors.green : Colors.red),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Actualiser manuellement les données
          _simulateBatteryData();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Données actualisées"),
              duration: Duration(seconds: 1),
            ),
          );
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildPieChart(String title, double value, Color color) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: value,
                      color: color,
                      title: "${value.toInt()}%",
                      radius: 80,
                      titleStyle: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: 100 - value,
                      color: Colors.grey[700]!,
                      title: '',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(String title, double currentValue) {
    List<FlSpot> dummyData = List.generate(
      10,
      (index) => FlSpot(index.toDouble(), currentValue + random.nextDouble() * 2 - 1),
    );

    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dummyData,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Color.fromARGB(255, 87, 96, 111)],
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        trailing: Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showLowBatteryAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Alerte Batterie Faible", style: TextStyle(color: Colors.white)),
          content: const Text(
            "L'état de charge de la batterie est inférieur à 20%. Veuillez la charger.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fermer", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}

class BatteryHistory extends StatelessWidget {
  const BatteryHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Historique des données de batterie",
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

class GPSPage extends StatelessWidget {
  const GPSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Page GPS",
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.redAccent),
              title: const Text("Compte Utilisateur", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Gérer vos informations de profil", style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.redAccent),
              title: const Text("Notifications", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Gérer les alertes et notifications", style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.battery_alert, color: Colors.redAccent),
              title: const Text("Paramètres BMS", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Configurer les seuils d'alerte", style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.bluetooth, color: Colors.redAccent),
              title: const Text("Connexion", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Gérer les connexions Bluetooth", style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.redAccent),
              title: const Text("Langue", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Changer la langue de l'application", style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Déconnexion", style: TextStyle(color: Colors.red)),
              onTap: () {
                // Déconnexion et retour à l'écran de connexion
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BatteryDetails extends StatelessWidget {
  const BatteryDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la Batterie"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "BMS Daly Smart 48V",
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            _buildDetailCard(
              title: "Informations Générales",
              icon: Icons.battery_charging_full,
              items: const [
                "Type : BMS Daly Smart",
                "Tension nominale : 48V (13S)",
                "Courant nominal : 60A / 100A (selon version)",
                "Type de batterie : Lithium-ion / LiFePO4",
              ],
            ),

            _buildDetailCard(
              title: "Fonctions de Protection",
              icon: Icons.shield,
              items: const [
                "Protection contre la surcharge",
                "Protection contre la décharge profonde",
                "Protection contre les surintensités",
                "Protection contre les courts-circuits",
                "Protection thermique (haute et basse température)",
              ],
            ),

            _buildDetailCard(
              title: "Équilibrage de Cellules",
              icon: Icons.equalizer,
              items: const [
                "Type : Actif / Passif",
                "Équilibrage automatique en charge",
                "Équilibrage à partir de : 4.18V (selon modèle)",
                "Courant d'équilibrage : 30mA à 100mA",
              ],
            ),

            _buildDetailCard(
              title: "Communication",
              icon: Icons.wifi_tethering,
              items: const [
                "Interface : UART / RS485 / CAN (selon version)",
                "Protocoles : Modbus RTU, Daly Smart BMS Protocol",
                "App mobile disponible (Bluetooth avec module optionnel)",
              ],
            ),

            _buildDetailCard(
              title: "Température et Conditions",
              icon: Icons.thermostat,
              items: const [
                "Température de fonctionnement : -20°C à +70°C",
                "Capteurs de température intégrés",
              ],
            ),

            _buildDetailCard(
              title: "Durabilité et Fiabilité",
              icon: Icons.autorenew,
              items: const [
                "Cycles de charge supportés : >2000 cycles (selon la batterie)",
                "Matériaux : PCB haute qualité avec revêtement anti-humidité",
                "Certifications : CE, RoHS",
              ],
            ),

            _buildDetailCard(
              title: "Caractéristiques Physiques",
              icon: Icons.design_services,
              items: const [
                "Dimensions : 100mm x 60mm x 15mm (selon version)",
                "Poids : Environ 200g",
              ],
            ),

            _buildDetailCard(
              title: "Applications",
              icon: Icons.electric_scooter,
              items: const [
                "Trottinettes électriques",
                "Scooters / Motos électriques",
                "Systèmes solaires hors réseau",
                "Stockage d'énergie domestique",
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required String title, required IconData icon, required List<String> items}) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.redAccent),
                const SizedBox(width: 10),
                Text(
  title,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
              ],
            ),
            const SizedBox(height: 10),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}