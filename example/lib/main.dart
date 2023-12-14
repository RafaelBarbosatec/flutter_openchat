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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          // brightness: Brightness.dark,
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('OpenChat Team example'),
      ),
      body: FlutterOpenChatWidget(
        // llm: OpenChatCloudLLMProvider(token: 'sVN9oFjcsZOsHuO3YZaG'),
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
