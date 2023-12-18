// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum ChatMessageRole { user, assistant }

class ChatMessage {
  ChatMessageRole role;
  String content;

  ChatMessage({required this.role, required this.content});

  factory ChatMessage.user(String content) {
    return ChatMessage(
      role: ChatMessageRole.user,
      content: content,
    );
  }

  factory ChatMessage.assistant(String content) {
    return ChatMessage(
      role: ChatMessageRole.assistant,
      content: content,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role.name;
    data['content'] = content;
    return data;
  }
}

class ChatModel {
  String id;
  String name;
  int maxLength;
  int tokenLimit;

  ChatModel({
    required this.id,
    required this.name,
    required this.maxLength,
    required this.tokenLimit,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['maxLength'] = maxLength;
    data['tokenLimit'] = tokenLimit;
    return data;
  }

  factory ChatModel.mistralv3Dot2() {
    return ChatModel(
      id: 'openchat_v3.2_mistral',
      name: 'OpenChat Aura',
      maxLength: 24576,
      tokenLimit: 8192,
    );
  }

  ChatModel copyWith({
    String? id,
    String? name,
    int? maxLength,
    int? tokenLimit,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      maxLength: maxLength ?? this.maxLength,
      tokenLimit: tokenLimit ?? this.tokenLimit,
    );
  }
}

class OpenChatTeamRequest {
  ChatModel model;
  List<ChatMessage> messages;
  double temperature;

  OpenChatTeamRequest({
    required this.model,
    required this.messages,
    required this.temperature,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model'] = model.toMap();
    data['messages'] = messages.map((v) => v.toMap()).toList();
    data['key'] = "";
    data['prompt'] = " ";
    data['temperature'] = temperature;
    return data;
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
