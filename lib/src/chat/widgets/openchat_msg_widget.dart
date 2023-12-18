// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_openchat/flutter_openchat.dart';
import 'package:flutter_openchat/src/chat/widgets/msg_widget_default.dart';

class OpenChatMsgWidget extends StatefulWidget {
  final ChatMessage message;
  final MarkdownConfig? markdownConfig;
  final String? assetUserAvatar;
  final String? assetBootAvatar;
  final VoidCallback? tryAgain;
  final OpenChatItemMessageBuilder? builder;
  const OpenChatMsgWidget({
    super.key,
    required this.message,
    this.markdownConfig,
    this.assetUserAvatar,
    this.assetBootAvatar,
    this.tryAgain,
    this.builder,
  });

  @override
  State<OpenChatMsgWidget> createState() => OpenChatMsgWidgetState();
}

class OpenChatMsgWidgetState extends State<OpenChatMsgWidget> {
  late OpenChatItemMessageState state;

  @override
  void initState() {
    state = OpenChatItemMessageState(
      text: widget.message.content,
      error: false,
      role: widget.message.role,
      assetBotAvatar: widget.assetBootAvatar,
      assetUserAvatar: widget.assetUserAvatar,
      markdownConfig: widget.markdownConfig,
    );
    super.initState();
  }

  Widget _builderDefault(context, state, tryAgain) => MsgWidgetDefault(
        state: state,
        onTryAgain: tryAgain,
      );

  @override
  Widget build(BuildContext context) {
    return widget.builder?.call(context, state, _tryAgain) ??
        _builderDefault(context, state, _tryAgain);
  }

  void _tryAgain() {
    setState(() {
      state = state.copyWith(error: false);
      widget.tryAgain?.call();
    });
  }

  void updateText(String text) {
    setState(() {
      state = state.copyWith(text: text);
    });
  }

  void onError() {
    setState(() {
      state = state.copyWith(error: true);
    });
  }
}

class OpenChatItemMessageState {
  final String text;
  final bool error;
  final ChatMessageRole role;
  final MarkdownConfig? markdownConfig;
  final String? assetUserAvatar;
  final String? assetBotAvatar;

  bool get isLoading =>
      text.isEmpty && role == ChatMessageRole.assistant && !error;

  OpenChatItemMessageState({
    required this.text,
    required this.error,
    required this.role,
    this.markdownConfig,
    this.assetUserAvatar,
    this.assetBotAvatar,
  });

  OpenChatItemMessageState copyWith({
    String? text,
    bool? error,
    ChatMessageRole? role,
    MarkdownConfig? markdownConfig,
    String? assetUserAvatar,
    String? assetBootAvatar,
  }) {
    return OpenChatItemMessageState(
      text: text ?? this.text,
      error: error ?? this.error,
      role: role ?? this.role,
      markdownConfig: markdownConfig ?? this.markdownConfig,
      assetUserAvatar: assetUserAvatar ?? this.assetUserAvatar,
      assetBotAvatar: assetBootAvatar ?? assetBotAvatar,
    );
  }
}
