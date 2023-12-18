import 'package:flutter/material.dart';
import 'package:flutter_openchat/flutter_openchat.dart';
import 'package:flutter_openchat/src/chat/widgets/openchat_input_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../robot.dart';

class LLMPromptMock extends Mock implements LLMPrompt {}

class FlutterOpenChatWidgetRobot extends Robot {
  late LLMPrompt _llm;
  FlutterOpenChatWidgetRobot(super.tester) {
    _llm = LLMPromptMock();
  }

  Future configure() {
    _confMock();
    return widgetSetup(
      Scaffold(
        body: FlutterOpenChatWidget(llm: _llm),
      ),
    );
  }

  Future enterText() async {
    await tester.enterText(
      find.byKey(OpenchatInputWidget.INPUT_KEY),
      'Who are you?',
    );
    await tester.pumpAndSettle();
  }

  Future tapSend() async {
    await tester.tap(
      find.byKey(OpenchatInputWidget.INPUT_BUTTON_KEY),
    );
    await tester.pumpAndSettle();
  }

  void _confMock() {
    when(() => _llm.prompt(any())).thenAnswer((invocation) {
      return Future.value('Hello, I am FlutterOpenChat');
    });
  }

  Future assetFlutterOpenChatWidgetEmpty() =>
      takeSnapshot('FlutterOpenChatWidget_empty');
  Future assetFlutterOpenChatWidgetWithMsg() =>
      takeSnapshot('FlutterOpenChatWidget_with_msg');
}
