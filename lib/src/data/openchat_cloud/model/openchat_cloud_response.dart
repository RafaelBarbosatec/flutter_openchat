// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OpenChatCloudResponse {
  final String type;
  final OpenChatCloudResponseResponse response;

  OpenChatCloudResponse({required this.type, required this.response});

  factory OpenChatCloudResponse.fromMap(Map<String, dynamic> map) {
    return OpenChatCloudResponse(
      type: map['type'] as String,
      response: OpenChatCloudResponseResponse.fromMap(
          map['response'] as Map<String, dynamic>),
    );
  }

  factory OpenChatCloudResponse.fromJson(String source) =>
      OpenChatCloudResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => response.text;
}

class OpenChatCloudResponseResponse {
  final String text;

  OpenChatCloudResponseResponse({required this.text});

  factory OpenChatCloudResponseResponse.fromMap(Map<String, dynamic> map) {
    return OpenChatCloudResponseResponse(
      text: map['text'] as String,
    );
  }

  factory OpenChatCloudResponseResponse.fromJson(String source) =>
      OpenChatCloudResponseResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
