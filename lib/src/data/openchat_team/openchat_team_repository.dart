import 'dart:async';
import 'dart:convert';

import 'package:flutter_openchat/src/data/openchat_team/model/openchat_team_request.dart';
import 'package:http/http.dart' as http;

class OpenChatTeamRepository {
  final Uri uri;
  final double temperature;
  final ChatModel model;
  final http.Client client;
  final Map<String, String>? header;

  OpenChatTeamRepository({
    required this.uri,
    required this.temperature,
    required this.model,
    required this.client,
    this.header,
  });

  Future<({Future<String> data, StreamSubscription subscription})> send(
    List<ChatMessage> messages, {
    Function(String data)? onListen,
  }) async {
    Completer<String> completer = Completer();
    final List<int> bytes = [];
    final request = http.Request('POST', uri);
    request.body = OpenChatTeamRequest(
      messages: messages,
      model: model,
      temperature: temperature,
    ).toJson();
    request.headers.addAll(
      {
        'Content-Type': 'application/json',
        ...(header ?? {}),
      },
    );
    final response = await client.send(request);
    if (response.statusCode != 200) {
      throw Exception('Is not possible get a response');
    }
    final sub = response.stream.listen((value) {
      bytes.addAll(value);
      onListen?.call(utf8.decode(bytes));
    });
    sub.onDone(() {
      completer.complete(utf8.decode(bytes));
    });
    sub.onError((e) {
      completer.completeError(e);
    });
    return (data: completer.future, subscription: sub);
  }
}
