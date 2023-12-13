import 'package:flutter/material.dart';
import 'package:flutter_openchat/flutter_openchat.dart';
import 'package:flutter_openchat/src/chat/widgets/openchat_input_widget.dart';
import 'package:flutter_openchat/src/chat/widgets/openchat_msg_widget.dart';

class FlutterOpenChatWidget extends StatefulWidget {
  final LLMProvider llm;
  final OpenChatInputBuilder? inputBuilder;
  final EdgeInsetsGeometry? chatPadding;
  const FlutterOpenChatWidget({
    super.key,
    required this.llm,
    this.inputBuilder,
    this.chatPadding,
  });

  @override
  State<FlutterOpenChatWidget> createState() => _FlutterOpenChatWidgetState();
}

class _FlutterOpenChatWidgetState extends State<FlutterOpenChatWidget> {
  List<ChatMessage> chat = [];
  bool loading = false;
  bool saying = false;
  bool isLLMChat = false;
  GlobalKey<OpenChatMsgWidgetState>? _lastAssistantMsg;

  LLMChatProvider get llmChatProvider => widget.llm as LLMChatProvider;
  LLMProvider get llmProvider => widget.llm;

  OpenChatInputBuilder get _defaultInputBuilder => (saying, submit) {
        return OpenchatInputWidget(
          submit: submit,
          enabled: !saying,
        );
      };

  @override
  void initState() {
    isLLMChat = widget.llm is LLMChatProvider;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                message: item,
                key: index == 0 ? _lastAssistantMsg : UniqueKey(),
              );
            },
          ),
        ),
        widget.inputBuilder?.call(saying, _submit) ??
            _defaultInputBuilder(saying, _submit),
      ],
    );
  }

  void _submit(String value) {
    setState(() {
      chat.add(ChatMessage.user(value));
      chat.add(ChatMessage.assistant(''));
      _lastAssistantMsg = GlobalKey();
      loading = true;
    });
    if (isLLMChat) {
      llmChatProvider.chat(chat, onListen: _bootSaying).then((value) {
        setState(() {
          saying = false;
          chat[chat.length - 1] = ChatMessage.assistant(value);
        });
      });
    } else {
      llmProvider.prompt(chat.last.content, onListen: _bootSaying);
    }
  }

  void _bootSaying(String text) {
    if (loading) {
      setState(() {
        saying = isLLMChat;
        loading = false;
      });
    }
    _lastAssistantMsg?.currentState?.updateText(text);
  }
}

typedef OpenChatInputBuilder = Widget Function(
  bool saying,
  ValueChanged<String> submit,
);
