import 'dart:async';
import 'dart:convert';

import 'package:flutter_openchat/src/data/openchat_cloud/model/openchat_cloud_request.dart';
import 'package:http/http.dart' as http;

class OpenChatCouldRepository {
  final Uri uri;
  final String token;
  late final http.Client _client;

  OpenChatCouldRepository({
    required this.uri,
    required this.token,
  }) {
    _client = http.Client();
  }

  Future<({Future<String> data, StreamSubscription subscription})> send(
    String prompt, {
    Function(String data)? onListen,
  }) async {
    Completer<String> completer = Completer();
    final List<int> bytes = [];
    final request = http.Request('POST', uri);
    request.headers.addAll(
      {
        'X-Bot-Token': token,
        'Content-Type': 'application/json',
      },
    );
    request.body = OpenChatCloudRequest(
      content: prompt,
    ).toJson();
    final response = await _client.send(request);
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
