// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_openchat/flutter_openchat.dart';
import 'package:flutter_openchat/src/chat/flutter_openchat_controller.dart';
import 'package:flutter_openchat/src/chat/widgets/openchat_input_widget.dart';
import 'package:flutter_openchat/src/chat/widgets/openchat_msg_widget.dart';

class FlutterOpenChatWidget extends StatefulWidget {
  final LLMProvider llm;
  final OpenChatInputBuilder? inputBuilder;
  final OpenChatItemMessageBuilder? msgBuilder;
  final EdgeInsetsGeometry? chatPadding;
  final MarkdownConfig? markdownConfig;
  final String? initialPrompt;
  final String? assetUserAvatar;
  final String? assetBotAvatar;
  final Widget? background;
  final Widget? backgroundEmpty;
  final ValueChanged<OpenChatWidgetState>? onChangeState;
  const FlutterOpenChatWidget({
    super.key,
    required this.llm,
    this.inputBuilder,
    this.msgBuilder,
    this.chatPadding,
    this.markdownConfig,
    this.initialPrompt,
    this.assetUserAvatar,
    this.assetBotAvatar,
    this.background,
    this.backgroundEmpty,
    this.onChangeState,
  });

  @override
  State<FlutterOpenChatWidget> createState() => _FlutterOpenChatWidgetState();
}

class _FlutterOpenChatWidgetState extends State<FlutterOpenChatWidget> {
  static const _defaultPagging = EdgeInsets.only(bottom: 16, top: 16);
  GlobalKey<OpenChatMsgWidgetState>? _lastAssistantMsg;
  OpenChatInputBuilder get _defaultInputBuilder => (state, submit) {
        return OpenchatInputWidget(
          submit: submit,
          enabled: !state.saying && !state.loading,
          saying: state.saying,
        );
      };

  late FlutterOpenChatController _controller;

  @override
  void initState() {
    _controller = FlutterOpenChatController(widget.llm);
    if (widget.initialPrompt != null) {
      send(widget.initialPrompt!, isInitialPrompt: true);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, snapshot) {
        widget.onChangeState?.call(_controller.state);
        return Stack(
          fit: StackFit.expand,
          children: [
            widget.background ?? const SizedBox.shrink(),
            if (_controller.chat.isEmpty)
              widget.backgroundEmpty ?? const SizedBox.shrink(),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _controller.chat.length,
                    reverse: true,
                    padding: widget.chatPadding ?? _defaultPagging,
                    itemBuilder: (context, index) {
                      final item = _controller.chat.reversed.elementAt(index);
                      return OpenChatMsgWidget(
                        key: index == 0 ? _lastAssistantMsg : UniqueKey(),
                        message: item,
                        markdownConfig: widget.markdownConfig,
                        assetBootAvatar: widget.assetBotAvatar,
                        assetUserAvatar: widget.assetUserAvatar,
                        tryAgain: _onTryAgain,
                        builder: widget.msgBuilder,
                      );
                    },
                  ),
                ),
                widget.inputBuilder?.call(_controller.state, _submit) ??
                    _defaultInputBuilder(_controller.state, _submit),
              ],
            ),
          ],
        );
      },
    );
  }

  void _submit(String value) {
    if (value.isEmpty) return;
    send(value);
  }

  void send(String value, {bool isInitialPrompt = false}) {
    _lastAssistantMsg = GlobalKey();
    _controller.send(
      value,
      _onSaying,
      _onError,
      isInitialPrompt: isInitialPrompt,
    );
  }

  void _onError() {
    _lastAssistantMsg?.currentState?.onError();
  }

  void _onSaying(String text) {
    _lastAssistantMsg?.currentState?.updateText(text);
  }

  void _onTryAgain() {
    _controller.tryAgain(
      _onSaying,
      _onError,
    );
  }
}

typedef OpenChatInputBuilder = Widget Function(
  OpenChatWidgetState state,
  ValueChanged<String> submit,
);

typedef OpenChatItemMessageBuilder = Widget Function(
  BuildContext context,
  OpenChatItemMessageState state,
  VoidCallback tryAgain,
);

class OpenChatWidgetState {
  final bool saying;
  final bool loading;
  final bool error;

  OpenChatWidgetState({
    this.saying = false,
    this.loading = false,
    this.error = false,
  });

  OpenChatWidgetState copyWith({
    bool? saying,
    bool? loading,
    bool? error,
  }) {
    return OpenChatWidgetState(
      saying: saying ?? this.saying,
      loading: loading ?? this.loading,
      error: error ?? false,
    );
  }
}
