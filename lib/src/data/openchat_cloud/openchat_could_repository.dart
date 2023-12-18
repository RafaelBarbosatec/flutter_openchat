import 'dart:async';
import 'dart:convert';

import 'package:flutter_openchat/src/data/openchat_cloud/model/openchat_cloud_request.dart';
import 'package:flutter_openchat/src/data/openchat_cloud/model/openchat_cloud_response.dart';
import 'package:http/http.dart' as http;

class OpenChatCouldRepository {
  final Uri uri;
  final String token;
  final http.Client client;
  final Map<String, String>? header;

  OpenChatCouldRepository({
    required this.uri,
    required this.token,
    required this.client,
    this.header,
  });

  Future<
      ({
        Future<OpenChatCloudResponse> data,
        StreamSubscription subscription
      })> send(
    String prompt, {
    Function(String data)? onListen,
  }) async {
    Completer<OpenChatCloudResponse> completer = Completer();
    final List<int> bytes = [];
    final request = http.Request('POST', uri);
    request.headers.addAll(
      {
        'X-Bot-Token': token,
        'Content-Type': 'application/json',
        ...(header ?? {}),
      },
    );
    request.body = OpenChatCloudRequest(
      content: prompt,
    ).toJson();
    final response = await client.send(request);
    if (response.statusCode != 200) {
      throw Exception('Is not possible get a response');
    }
    final sub = response.stream.listen((value) {
      bytes.addAll(value);
      onListen?.call(utf8.decode(bytes));
    });
    sub.onDone(() {
      completer.complete(OpenChatCloudResponse.fromJson(utf8.decode(bytes)));
    });
    sub.onError((e) {
      completer.completeError(e);
    });
    return (data: completer.future, subscription: sub);
  }
}
