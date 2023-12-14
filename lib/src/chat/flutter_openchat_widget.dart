// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_openchat/flutter_openchat.dart';
import 'package:flutter_openchat/src/chat/widgets/openchat_input_widget.dart';
import 'package:flutter_openchat/src/chat/widgets/openchat_msg_widget.dart';

class FlutterOpenChatWidget extends StatefulWidget {
  final LLMProvider llm;
  final OpenChatInputBuilder? inputBuilder;
  final EdgeInsetsGeometry? chatPadding;
  final MarkdownConfig? markdownConfig;
  final String? initialPrompt;
  final String? assetUserAvatar;
  final String? assetBootAvatar;
  final Widget? background;
  final Widget? backgroundEmpty;
  const FlutterOpenChatWidget({
    super.key,
    required this.llm,
    this.inputBuilder,
    this.chatPadding,
    this.markdownConfig,
    this.initialPrompt,
    this.assetUserAvatar,
    this.assetBootAvatar,
    this.background,
    this.backgroundEmpty,
  });

  @override
  State<FlutterOpenChatWidget> createState() => _FlutterOpenChatWidgetState();
}

class _FlutterOpenChatWidgetState extends State<FlutterOpenChatWidget> {
  OpenChatWidgetState state = OpenChatWidgetState();
  List<ChatMessage> chat = [];
  bool isLLMChat = false;
  GlobalKey<OpenChatMsgWidgetState>? _lastAssistantMsg;

  LLMChatProvider get llmChatProvider => widget.llm as LLMChatProvider;
  LLMProvider get llmProvider => widget.llm;

  OpenChatInputBuilder get _defaultInputBuilder => (state, submit) {
        return OpenchatInputWidget(
          submit: submit,
          enabled: !state.saying && !state.loading,
        );
      };

  @override
  void initState() {
    isLLMChat = widget.llm is LLMChatProvider;
    if (widget.initialPrompt != null) {
      send(initialMsg: ChatMessage.user(widget.initialPrompt!));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.background ?? const SizedBox.shrink(),
        if (chat.isEmpty) widget.backgroundEmpty ?? const SizedBox.shrink(),
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chat.length,
                reverse: true,
                padding: widget.chatPadding ??
                    const EdgeInsets.only(
                      bottom: 16,
                      top: 16,
                    ),
                itemBuilder: (context, index) {
                  final item = chat.reversed.elementAt(index);
                  return OpenChatMsgWidget(
                    key: index == 0 ? _lastAssistantMsg : UniqueKey(),
                    message: item,
                    markdownConfig: widget.markdownConfig,
                    assetBootAvatar: widget.assetBootAvatar,
                    assetUserAvatar: widget.assetUserAvatar,
                    tryAgain: _tryAgain,
                  );
                },
              ),
            ),
            widget.inputBuilder?.call(state, _submit) ??
                _defaultInputBuilder(state, _submit),
          ],
        ),
      ],
    );
  }

  void _submit(String value) {
    if (value.isEmpty) {
      return;
    }
    chat.add(ChatMessage.user(value));
    send();
  }

  void send({ChatMessage? initialMsg, bool addsAssistantMsg = true}) {
    if (isLLMChat) {
      List<ChatMessage> list = chat;
      if (initialMsg != null) {
        list = [initialMsg];
      }
      llmChatProvider.chat(list, onListen: _bootSaying).then((value) {
        setState(() {
          state = state.copyWith(saying: false);
          chat[chat.length - 1] = ChatMessage.assistant(value);
        });
      }).catchError(_onError);
    } else {
      String lastUserMsg = chat
          .lastWhere((element) => element.role == ChateMessageRole.user)
          .content;
      llmProvider
          .prompt(
        initialMsg?.content ?? lastUserMsg,
        onListen: _bootSaying,
      )
          .then((value) {
        setState(() {
          state = state.copyWith(saying: false);
          chat[chat.length - 1] = ChatMessage.assistant(value);
        });
      }).catchError(_onError);
    }
    setState(() {
      if (addsAssistantMsg) {
        _lastAssistantMsg = GlobalKey();
        chat.add(ChatMessage.assistant(''));
      }
      state = state.copyWith(loading: true);
    });
  }

  _onError(e) {
    _lastAssistantMsg?.currentState?.onError();
    setState(() {
      state = state.copyWith(
        loading: false,
        saying: false,
        error: true,
      );
    });
  }

  void _bootSaying(String text) {
    if (state.loading) {
      setState(() {
        state = state.copyWith(
          loading: false,
          saying: true,
        );
      });
    }
    _lastAssistantMsg?.currentState?.updateText(text);
  }

  void _tryAgain() => send(addsAssistantMsg: false);
}

typedef OpenChatInputBuilder = Widget Function(
  OpenChatWidgetState state,
  ValueChanged<String> submit,
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
