// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_openchat/src/chat/widgets/msg_widget_default.dart';
import 'package:flutter_openchat/src/llm/llm_provider.dart';
import 'package:markdown_widget/config/configs.dart';

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
  // String text = '';
  // bool error = false;
  // bool get isUser => widget.message.role == ChateMessageRole.user;
  // bool get isLoading => text.isEmpty && !isUser && !error;
  late OpenChatItemMessageState state;
  @override
  void initState() {
    state = OpenChatItemMessageState(
      text: widget.message.content,
      error: false,
      role: widget.message.role,
      assetBootAvatar: widget.assetBootAvatar,
      assetUserAvatar: widget.assetUserAvatar,
      markdownConfig: widget.markdownConfig,
    );
    super.initState();
  }

  void updateText(String text) {
    setState(() {
      state = state.copyWith(text: text);
    });
  }

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

  Widget _builderDefault(context, state, tryAgain) => MsgWidgetDefault(
        state: state,
        onTryAgain: tryAgain,
      );

  void onError() {
    setState(() {
      state = state.copyWith(error: true);
    });
  }
}

class OpenChatItemMessageState {
  final String text;
  final bool error;
  final ChateMessageRole role;
  final MarkdownConfig? markdownConfig;
  final String? assetUserAvatar;
  final String? assetBootAvatar;

  bool get isLoading =>
      text.isEmpty && role == ChateMessageRole.assistant && !error;

  OpenChatItemMessageState({
    required this.text,
    required this.error,
    required this.role,
    this.markdownConfig,
    this.assetUserAvatar,
    this.assetBootAvatar,
  });

  OpenChatItemMessageState copyWith({
    String? text,
    bool? error,
    ChateMessageRole? role,
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
      assetBootAvatar: assetBootAvatar ?? this.assetBootAvatar,
    );
  }
}

typedef OpenChatItemMessageBuilder = Widget Function(
  BuildContext context,
  OpenChatItemMessageState state,
  VoidCallback tryAgain,
);
