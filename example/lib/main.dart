import 'package:flutter/material.dart';
import 'package:flutter_openchat/flutter_openchat.dart';

ThemeType _themeType = ThemeType();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeType,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: _themeType.brightness,
            ),
            useMaterial3: true,
          ),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('OpenChat example'),
        actions: [
          IconButton(
            onPressed: () {
              if (_themeType.brightness == Brightness.dark) {
                _themeType.setLight();
              } else {
                _themeType.setDark();
              }
            },
            icon: Icon(
              _themeType.isLight ? Icons.nightlight : Icons.sunny,
            ),
          )
        ],
      ),
      body: FlutterOpenChatWidget(
        llm: OpenChatTeamLLM(),
        assetBotAvatar:
            'https://api.dicebear.com/7.x/bottts-neutral/png?seed=Harley&radius=50',
        assetUserAvatar:
            'https://api.dicebear.com/7.x/avataaars-neutral/png?seed=Jack&radius=50',
        backgroundEmpty: const Center(
          child: Text('Hothing over here'),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ThemeType extends ChangeNotifier {
  Brightness brightness = Brightness.light;

  bool get isLight => brightness == Brightness.light;

  void setLight() {
    brightness = Brightness.light;
    notifyListeners();
  }

  void setDark() {
    brightness = Brightness.dark;
    notifyListeners();
  }
}
