import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_openchat/flutter_openchat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
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
      ),
      body: FlutterOpenChatWidget(
        llm: OpenChatTeamLLMProvider(),
        assetBootAvatar:
            'https://api.dicebear.com/7.x/bottts-neutral/png?seed=${Random().nextInt(1000)}&radius=50',
        assetUserAvatar:
            'https://api.dicebear.com/7.x/avataaars-neutral/png?seed=${Random().nextInt(1000)}&radius=50',
        backgroundEmpty: const Center(
          child: Text('Hothing over here'),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
