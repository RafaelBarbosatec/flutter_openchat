import 'package:flutter/material.dart';
import 'package:flutter_openchat/src/llm/llm_provider.dart';
import 'package:markdown_widget/widget/markdown.dart';

class OpenChatMsgWidget extends StatefulWidget {
  final ChatMessage message;
  const OpenChatMsgWidget({super.key, required this.message});

  @override
  State<OpenChatMsgWidget> createState() => OpenChatMsgWidgetState();
}

class OpenChatMsgWidgetState extends State<OpenChatMsgWidget> {
  String text = '';
  bool get isUser => widget.message.role == 'user';
  bool get isLoading => text.isEmpty;
  @override
  void initState() {
    text = widget.message.content;
    super.initState();
  }

  void updateText(String text) {
    setState(() {
      this.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 16,
          left: isUser ? 64 : 8,
          right: isUser ? 8 : 64,
        ),
        width: isLoading ? 50 : null,
        height: isLoading ? 50 : null,
        decoration: BoxDecoration(
          color: isUser ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child:
            isLoading ? const CircularProgressIndicator() : _buildText(isUser),
      ),
    );
  }

  Widget _buildText(bool isUser) {
    if (isUser) {
      return Text(text);
    }
    return MarkdownWidget(
      data: text,
      shrinkWrap: true,
    );
  }
}
