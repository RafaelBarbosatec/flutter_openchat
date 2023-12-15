import 'dart:async';

import 'package:flutter_openchat/flutter_openchat.dart';
import 'package:flutter_openchat/src/data/openchat_cloud/model/openchat_cloud_response.dart';
import 'package:flutter_openchat/src/data/openchat_cloud/openchat_could_repository.dart';

class OpenChatCloudLLM extends LLMPrompt<OpenChatCloudResponse> {
  static const _urlDefault = 'https://cloud.openchat.so/api/chat/send';
  final String url;
  final String token;
  StreamSubscription? _sub;
  late final OpenChatCouldRepository _repository;
  OpenChatCloudLLM({required this.token, String? url})
      : url = url ?? _urlDefault {
    _repository = OpenChatCouldRepository(
      uri: Uri.parse(this.url),
      token: token,
    );
  }

  @override
  Future<OpenChatCloudResponse> prompt(
    String prompt, {
    void Function(String saying)? onListen,
  }) async {
    final resp = await _repository.send(
      prompt,
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
