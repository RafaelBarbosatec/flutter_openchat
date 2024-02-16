import 'package:flutter_openchat/src/data/openchat_team/model/openchat_team_request.dart';

export 'openchat_team_llm.dart';

abstract class LLMProvider<T> {
  void stopGenerate();
}

abstract class LLMPrompt<T> extends LLMProvider {
  Future<T> prompt(
    String prompt, {
    void Function(String saying)? onListen,
  });
}

abstract class LLMChat extends LLMPrompt<String> {
  Future<String> chat(
    List<ChatMessage> messages, {
    void Function(String saying)? onListen,
  });
}
