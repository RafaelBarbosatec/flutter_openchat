import 'package:flutter/material.dart';
import 'package:flutter_openchat/flutter_openchat.dart';
import 'package:flutter_openchat/src/chat/widgets/openchat_msg_widget.dart';
import 'package:markdown_widget/widget/markdown.dart';

class MsgWidgetDefault extends StatelessWidget {
  final OpenChatItemMessageState state;
  final VoidCallback onTryAgain;
  const MsgWidgetDefault({super.key, required this.state, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    bool isUser = state.role == ChateMessageRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser && state.assetBootAvatar != null) ...[
            const SizedBox(width: 8),
            _buildAvatar(context,state.assetBootAvatar!)
          ],
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                top: 16,
                left: isUser ? 32 : 8,
                right: isUser ? 8 : 32,
              ),
              width: state.isLoading ? 50 : null,
              height: state.isLoading ? 50 : null,
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : state.error
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
              child: _buildMsgContent(context,isUser),
            ),
          ),
          if (isUser && state.assetUserAvatar != null) ...[
            _buildAvatar(context,state.assetUserAvatar!),
            const SizedBox(width: 8),
          ]
        ],
      ),
    );
  }

  Widget _buildImage(String asset) {
    if (asset.contains('http')) {
      return Image.network(asset);
    }
    return Image.asset(asset);
  }

  Widget _buildAvatar(BuildContext context,String asset) {
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

  Widget _buildText(BuildContext context, bool isUser) {
    if (isUser) {
      return Text(
        state.text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.background,
            ),
      );
    }
    return MarkdownWidget(
      data: state.text,
      shrinkWrap: true,
      config: state.markdownConfig,
    );
  }

  Widget _buildLoading() {
    return const CircularProgressIndicator();
  }

  Widget _buildError(BuildContext context) {
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
          onPressed: onTryAgain,
          child: const Text('Try again'),
        ),
      ],
    );
  }

  Widget _buildMsgContent(BuildContext context, bool isUser) {
    if (state.error) {
      return _buildError(context);
    }
    if (state.isLoading) {
      return _buildLoading();
    }

    return _buildText(context,isUser);
  }
}
