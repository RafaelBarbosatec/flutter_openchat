import 'package:flutter_test/flutter_test.dart';

import 'flutter_openchat_widget_robot.dart';

void main() {
  testWidgets('Should show screen empty', (tester) async {
    final robot = FlutterOpenChatWidgetRobot(tester);
    await robot.configure();
    await robot.assetFlutterOpenChatWidgetEmpty();
  });

  testWidgets('Should show screen with initial prompt', (tester) async {
    final robot = FlutterOpenChatWidgetRobot(tester);
    await robot.configure(initialPrompt: 'initial');
    await robot.awaitForAnimations();
    await robot.assetFlutterOpenChatWidgetWithInitialPrompt();
  });

  testWidgets('Should show screen with msgs', (tester) async {
    final robot = FlutterOpenChatWidgetRobot(tester);
    await robot.configure();
    await robot.enterText();
    await robot.tapSend();
    await robot.awaitForAnimations();
    await robot.assetFlutterOpenChatWidgetWithMsg();
  });
}
