import 'dart:async';

import 'package:flutter_openchat/src/data/openchat_team/openchat_team_repository.dart';
import 'package:flutter_openchat/src/llm/llm_provider.dart';

export 'package:flutter_openchat/src/data/openchat_team/model/openchat_team_request.dart';

class OpenChatTeamLLM implements LLMChat {
  static const _urlDefault = 'https://openchat.team/api/chat';
  final String url;
  final double temperature;
  final ChatModel model;
  late final OpenChatTeamRepository _repository;
  StreamSubscription? _sub;

  OpenChatTeamLLM({
    String? url,
    this.temperature = 0.5,
    ChatModel? model,
  })  : model = model ?? ChatModel.mistralv3Dot2(),
        url = url ?? _urlDefault {
    _repository = OpenChatTeamRepository(
      uri: Uri.parse(this.url),
      model: this.model,
      temperature: temperature,
    );
  }

  @override
  Future<String> prompt(
    String prompt, {
    void Function(String saying)? onListen,
  }) async {
    _sub?.cancel();
    final resp = await _repository.send(
      [ChatMessage.user(prompt)],
      onListen: onListen,
    );
    _sub = resp.subscription;
    return resp.data;
  }

  @override
  Future<String> chat(
    List<ChatMessage> messages, {
    void Function(String saying)? onListen,
  }) async {
    _sub?.cancel();
    final resp = await _repository.send(
      messages,
      onListen: onListen,
    );
    _sub = resp.subscription;
    return resp.data;
  }

  @override
  void stopGenerate() {
    _sub?.cancel();
  }
}
