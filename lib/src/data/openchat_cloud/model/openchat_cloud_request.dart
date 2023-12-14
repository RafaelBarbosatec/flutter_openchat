// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OpenChatCloudRequest {
  final String content;

  OpenChatCloudRequest({required this.content});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': 'user',
      'type': 'text',
      'content': content,
    };
  }

  String toJson() => json.encode(toMap());
}
