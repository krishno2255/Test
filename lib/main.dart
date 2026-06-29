import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:math';

void main() => runApp(const PhoneInfoApp());

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
  String model = '-', android = '-', processor = '-';
  String brand = '-', manufacturer = '-';
  int battery = 0;
  String network = '-';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final di = DeviceInfoPlugin();
    final a = await di.androidInfo;
    final b = await Battery().batteryLevel;
    final c = await Connectivity().checkConnectivity();
    setState(() {
      model = a.model;
      android = 'Android ${a.version.release}';
      processor = a.hardware;
      brand = a.brand;
      manufacturer = a.manufacturer;
      battery = b;
      network = c.toString().split('.').last;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _deviceCard(),
                    const SizedBox(height: 12),
                    _ramCard(),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: _storageCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _networkCard()),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: _gpuCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _imeiCard()),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: _systemCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _sensorCard()),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: Colors.white70),
          const Text('Phone Info',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1)),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.info_outline,
                color: Colors.cyanAccent, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _deviceCard() {
    return _glass(
      color: Colors.blueAccent,
      child: Row(
        children: [
          _circleChart(battery / 100, '${battery}%', Colors.cyanAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Model', model),
                _label('Android', android),
                _label('Processor', processor),
              ],
            ),
          ),
          const Icon(Icons.phone_android,
              color: Colors.cyanAccent, size: 28),
        ],
      ),
    );
  }

  Widget _ramCard() {
    return _glass(
      color: Colors.purpleAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _circleChart(0.8, '80%', Colors.pinkAccent),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RAM',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    SizedBox(height: 8),
                    _NeonBar(value: 0.8, color: Colors.purpleAccent),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _pieChart(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _storageCard() {
    return _glass(
      color: Colors.cyanAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Storage',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Icon(Icons.storage, color: Colors.cyanAccent, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          const _MiniLineChart(),
        ],
      ),
    );
  }

  Widget _networkCard() {
    return _glass(
      color: Colors.purpleAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('50%',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          const Text('Temperature',
              style: TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.wifi, color: Colors.cyanAccent, size: 20),
              const SizedBox(width: 8),
              Text(network,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gpuCard() {
    return _glass(
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('GPU',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Screen resolution',
              style: TextStyle(color: Colors.white54, fontSize: 11)),
          const Text('Refresh Rate',
              style: TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('S366',
                style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _imeiCard() {
    return _glass(
      color: Colors.cyanAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('IMEI',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Icon(Icons.block, color: Colors.redAccent, size: 16),
            ],
          ),
          const Text('Network speed',
              style: TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.phone_android, color: Colors.cyanAccent, size: 18),
              Icon(Icons.vibration, color: Colors.cyanAccent, size: 18),
              Icon(Icons.wifi, color: Colors.cyanAccent, size: 18),
              Icon(Icons.bluetooth, color: Colors.cyanAccent, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _systemCard() {
    return _glass(
      color: Colors.cyanAccent,
      isGlow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System',
              style: TextStyle(
                  color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
          const Text('Inventory',
              style: TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 4),
          Text(manufacturer,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text(brand,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.memory, color: Colors.cyanAccent, size: 20),
              Icon(Icons.circle_outlined, color: Colors.cyanAccent, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sensorCard() {
    return _glass(
      color: Colors.purpleAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sensor',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Icon(Icons.sensors, color: Colors.purpleAccent, size: 16),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Mobile/Signal strength',
              style: TextStyle(color: Colors.white54, fontSize: 10)),
          const Text('System status',
              style: TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.power, color: Colors.purpleAccent, size: 18),
              Icon(Icons.bolt, color: Colors.purpleAccent, size: 18),
              Icon(Icons.signal_cellular_alt,
                  color: Colors.purpleAccent, size: 18),
              Icon(Icons.swap_horiz, color: Colors.purpleAccent, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: '$k: ',
                style: const TextStyle(
                    color: Colors.white54, fontSize: 12)),
            TextSpan(
                text: v,
                style: const TextStyle(
                    color: Colors.white, fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _circleChart(double value, String label, Color color) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(64, 64),
            painter: _CirclePainter(value, color),
          ),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _pieChart() {
    return SizedBox(
      width: 56,
      height: 56,
      child: CustomPaint(
        painter: _PiePainter(),
      ),
    );
  }
}

Widget _glass({
  required Widget child,
  required Color color,
  bool isGlow = false,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withOpacity(0.04),
      border: Border.all(color: color.withOpacity(0.25), width: 1),
      boxShadow: isGlow
          ? [BoxShadow(color: color.withOpacity(0.25), blurRadius: 20)]
          : [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10)],
    ),
    child: child,
  );
}

class _NeonBar extends StatelessWidget {
  final double value;
  final Color color;
  const _NeonBar({required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 8,
        backgroundColor: Colors.white10,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}

class _MiniLineChart extends StatelessWidget {
  const _MiniLineChart();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CustomPaint(painter: _LinePainter()),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double value;
  final Color color;
  _CirclePainter(this.value, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = Colors.white10
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    final fg = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2 - 3, bg);
    canvas.drawArc(
      Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2 - 3),
      -pi / 2,
      2 * pi * value,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}

class _PiePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Colors.cyanAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.orangeAccent,
    ];
    final sweeps = [0.35, 0.25, 0.25, 0.15];
    double start = -pi / 2;
    for (int i = 0; i < colors.length; i++) {
      final p = Paint()..color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2),
        start,
        2 * pi * sweeps[i],
        true,
        p,
      );
      start += 2 * pi * sweeps[i];
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path();
    final points = [0.8, 0.4, 0.6, 0.3, 0.5, 0.2, 0.7];
    for (int i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height * (1 - points[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.cyanAccent.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(_) => false;
}
