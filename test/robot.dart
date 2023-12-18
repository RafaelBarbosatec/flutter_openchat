import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

abstract class Robot {
  String _currentRouteName = '/';
  static const deviseSizeDefault = Size(1440, 2560);
  final WidgetTester tester;
  late NavigatorObserver navigatorObserver;

  Robot(this.tester) {
    registerFallbackValue(
      MaterialPageRoute<Widget>(builder: (_) => Container()),
    );
    navigatorObserver = NavigatorObserverMock();
  }

  Future<void> widgetSetup(
    Widget widget, {
    Duration? awaitAnimation,
    Size? sizeScreen,
  }) async {
    tester.view.physicalSize = sizeScreen ?? deviseSizeDefault;
    await tester.pumpWidget(
      MaterialApp(
        home: widget,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [navigatorObserver],
        onGenerateRoute: (settings) {
          _currentRouteName = settings.name ?? '';
          return MaterialPageRoute<Widget>(
            builder: (_) => Container(),
            settings: settings,
          );
        },
      ),
    );

    await awaitForAnimations(duration: awaitAnimation);
  }

  Future<void> awaitForAnimations({Duration? duration}) async {
    try {
      await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 300));
    } catch (e) {
      await tester.pump(duration);
    }
  }

  Future takeSnapshot(String filename) {
    return expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('./golden_files/$filename.png'),
    );
  }

  void assetNavigatorPush(String routeName) {
    expect(_currentRouteName, routeName);
  }
}
