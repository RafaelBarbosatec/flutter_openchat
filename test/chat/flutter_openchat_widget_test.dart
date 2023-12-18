import 'package:flutter_test/flutter_test.dart';

import 'flutter_openchat_widget_robot.dart';

void main() {
  testWidgets('Should show screen empty', (tester) async {
    final robot = FlutterOpenChatWidgetRobot(tester);
    await robot.configure();
    await robot.awaitForAnimations();
    await robot.assetFlutterOpenChatWidgetEmpty();
  });

  testWidgets('Should show screen with msgs', (tester) async {
    final robot = FlutterOpenChatWidgetRobot(tester);
    await robot.configure();
    await robot.awaitForAnimations();
    await robot.enterText();
    await robot.tapSend();
    await robot.awaitForAnimations();
    await robot.assetFlutterOpenChatWidgetWithMsg();
  });
}
