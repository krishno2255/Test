import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(const PhoneInfoApp());
}

class PhoneInfoApp extends StatelessWidget {
  const PhoneInfoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Info',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String> deviceInfo = {};
  int batteryLevel = 0;
  String connectivity = '';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    final battery = Battery();
    final level = await battery.batteryLevel;
    final connectivityResult = await Connectivity().checkConnectivity();

    setState(() {
      deviceInfo = {
        'Model': androidInfo.model,
        'Brand': androidInfo.brand,
        'Android': androidInfo.version.release,
        'SDK': androidInfo.version.sdkInt.toString(),
        'Board': androidInfo.board,
        'Hardware': androidInfo.hardware,
        'Manufacturer': androidInfo.manufacturer,
      };
      batteryLevel = level;
      connectivity = connectivityResult.toString().split('.').last;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Phone Info',
            style: TextStyle(
                color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _glassCard('🔋 Battery', '$batteryLevel%', Colors.greenAccent),
            _glassCard('📶 Network', connectivity, Colors.cyanAccent),
            ...deviceInfo.entries.map((e) =>
                _glassCard(e.key, e.value, Colors.purpleAccent)),
          ],
        ),
      ),
    );
  }

  Widget _glassCard(String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
