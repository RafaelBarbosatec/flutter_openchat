import 'package:flutter/material.dart';
import 'package:flutter_openchat/src/llm/llm_provider.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/markdown.dart';

class OpenChatMsgWidget extends StatefulWidget {
  final ChatMessage message;
  final MarkdownConfig? markdownConfig;
  final String? assetUserAvatar;
  final String? assetBootAvatar;
  final VoidCallback? tryAgain;
  const OpenChatMsgWidget({
    super.key,
    required this.message,
    this.markdownConfig,
    this.assetUserAvatar,
    this.assetBootAvatar,
    this.tryAgain,
  });

  @override
  State<OpenChatMsgWidget> createState() => OpenChatMsgWidgetState();
}

class OpenChatMsgWidgetState extends State<OpenChatMsgWidget> {
  String text = '';
  bool error = false;
  bool get isUser => widget.message.role == ChateMessageRole.user;
  bool get isLoading => text.isEmpty && !isUser && !error;
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser && widget.assetBootAvatar != null) ...[
            const SizedBox(width: 8),
            _buildAvatar(widget.assetBootAvatar!)
          ],
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                top: 16,
                left: isUser ? 32 : 8,
                right: isUser ? 8 : 32,
              ),
              width: isLoading ? 50 : null,
              height: isLoading ? 50 : null,
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : error
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 20),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: _buildMsgContent(),
            ),
          ),
          if (isUser && widget.assetUserAvatar != null) ...[
            _buildAvatar(widget.assetUserAvatar!),
            const SizedBox(width: 8),
          ]
        ],
      ),
    );
  }

  Widget _buildText(bool isUser) {
    if (isUser) {
      return Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.background,
            ),
      );
    }
    return MarkdownWidget(
      data: text,
      shrinkWrap: true,
      config: widget.markdownConfig,
    );
  }

  Widget _buildLoading() {
    return const CircularProgressIndicator();
  }

  Widget _buildAvatar(String asset) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(50),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: _buildImage(asset),
      ),
    );
  }

  Widget _buildImage(String asset) {
    if (asset.contains('http')) {
      return Image.network(asset);
    }
    return Image.asset(asset);
  }

  void onError() {
    setState(() {
      error = true;
    });
  }

  Widget _buildMsgContent() {
    if (error) {
      return _buildError();
    }
    if (isLoading) {
      return _buildLoading();
    }

    return _buildText(isUser);
  }

  Widget _buildError() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Something was wrong',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.background,
              ),
        ),
        TextButton(
          onPressed: () {
            widget.tryAgain?.call();
            setState(() {
              error = false;
            });
          },
          child: const Text('Try again'),
        ),
      ],
    );
  }
}
