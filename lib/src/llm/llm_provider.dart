import 'package:flutter_openchat/src/data/openchat_team/model/openchat_team_request.dart';

export 'openchat_cloud_llm_provider.dart';
export 'openchat_team_llm_provider.dart';

abstract class LLMProvider {
  Future<String> prompt(String prompt,
      {void Function(String saying)? onListen});
  void stopGenerate();
}

abstract class LLMChatProvider extends LLMProvider {
  Future<String> chat(
    List<ChatMessage> messages, {
    void Function(String saying)? onListen,
  });
}
