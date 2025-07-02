import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EcoEarApp());
}

class EcoEarApp extends StatefulWidget {
  @override
  State<EcoEarApp> createState() => _EcoEarAppState();
}

class _EcoEarAppState extends State<EcoEarApp> with WidgetsBindingObserver {
  // theme
  bool _isDark = false;
  // lifecycle
  AppLifecycleState _state = AppLifecycleState.resumed;
  // notifications
  final _notif = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
    _initNotifications();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isDark = prefs.getBool('darkMode') ?? false);
  }

  Future<void> _saveTheme(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', v);
  }

  Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notif.initialize(InitializationSettings(android: android));
  }

  void _sendStateNotification(String msg) {
    const androidDetails = AndroidNotificationDetails(
      'ecoseg',
      'EcoEar',
      importance: Importance.high,
    );
    _notif.show(
      0,
      'EcoEar Status',
      msg,
      NotificationDetails(android: androidDetails),
      payload: 'state',
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState newState) {
    super.didChangeAppLifecycleState(newState);
    setState(() => _state = newState);

    // when going background/inactive, fire a notification
    if (newState == AppLifecycleState.inactive ||
        newState == AppLifecycleState.paused) {
      List<String> msgs = [
        'Still listening… 🤫',
        'EcoEar’s on pause! 🌱',
        'We’re here when you return! 🐸',
      ];
      _sendStateNotification(msgs[Random().nextInt(msgs.length)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoEar',
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(
        isDark: _isDark,
        onToggleTheme: (v) {
          _saveTheme(v);
          setState(() => _isDark = v);
        },
        lifecycle: _state,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onToggleTheme;
  final AppLifecycleState lifecycle;

  const HomePage({
    required this.isDark,
    required this.onToggleTheme,
    required this.lifecycle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // persistent top banner
      body: Column(
        children: [
          NotificationBanner(state: lifecycle),
          Expanded(
            child: Stack(
              children: [
                // Layered cards
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Layered Card #1'),
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 40,
                  right: 40,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Layered Card #2'),
                    ),
                  ),
                ),
                // waveform placeholder
                Center(child: Text('🎶 Waveform here 🎶')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) =>
              SettingsModal(isDark: isDark, onToggle: onToggleTheme),
        ),
      ),
    );
  }
}

class NotificationBanner extends StatefulWidget {
  final AppLifecycleState state;
  const NotificationBanner({required this.state});
  @override
  _NotificationBannerState createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctr;
  @override
  void initState() {
    super.initState();
    _ctr = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _showHide();
  }

  @override
  void didUpdateWidget(covariant NotificationBanner old) {
    super.didUpdateWidget(old);
    _showHide();
  }

  void _showHide() {
    if (widget.state == AppLifecycleState.resumed)
      _ctr.forward();
    else
      _ctr.reverse();
  }

  @override
  Widget build(BuildContext context) {
    String msg;
    Color color;
    switch (widget.state) {
      case AppLifecycleState.resumed:
        msg = 'EcoEar is active';
        color = Colors.green;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        msg = 'EcoEar in background';
        color = Colors.orange;
        break;
      default:
        msg = 'EcoEar stopped';
        color = Colors.grey;
    }
    return SizeTransition(
      sizeFactor: _ctr,
      axisAlignment: -1,
      child: Container(
        color: color,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // your circular logo
            Image.asset('assets/images/logo_curved.png', width: 32, height: 32),
            SizedBox(width: 12),
            Text(msg, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }
}

class SettingsModal extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onToggle;
  SettingsModal({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    // dummy UID for demo
    String uid = FirebaseFirestore.instance.app.options.appId;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Settings & Feedback', style: TextStyle(fontSize: 18)),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDark,
            onChanged: onToggle,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('User ID'),
            subtitle: Text(uid),
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Send Feedback'),
            onTap: () {
              // TODO: wire feedback form
            },
          ),
          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text('Call Streak'),
            subtitle: Text('🔥 5 days!'),
          ),
        ],
      ),
    );
  }
}
