import 'package:flutter/material.dart';
import 'package:flutter_openchat/flutter_openchat.dart';

class FlutterOpenChatController extends ChangeNotifier {
  OpenChatWidgetState state = OpenChatWidgetState();
  List<ChatMessage> chat = [];
  bool _isLLMChat = false;
  final LLMProvider llmProvider;

  LLMChat get llmChat => llmProvider as LLMChat;
  LLMPrompt get llmPrompt => llmProvider as LLMPrompt;

  String get lastUserMsg => chat.isNotEmpty
      ? chat
          .lastWhere((element) => element.role == ChatMessageRole.user)
          .content
      : '';

  FlutterOpenChatController(this.llmProvider) {
    _isLLMChat = llmProvider is LLMChat;
  }

  void send(
    String text,
    Function(String text) onSaying,
    Function onError, {
    bool addsInChat = true,
  }) {
    if (addsInChat) {
      chat.add(ChatMessage.user(text));
    }

    if (_isLLMChat) {
      _sendChat(chat, onSaying, onError);
    } else {
      _sendPrompt(lastUserMsg, onSaying, onError);
    }
    safeNotifyListeners(() {
      chat.add(ChatMessage.assistant(''));
      state = state.copyWith(loading: true);
    });
  }

  void _sendChat(
    List<ChatMessage> chat,
    Function(String text) onSaying,
    Function onError,
  ) {
    llmChat.chat(chat, onListen: (text) {
      if (state.loading) {
        safeNotifyListeners(() {
          state = state.copyWith(saying: true, loading: false);
        });
      }
      onSaying(text);
    }).then((value) {
      safeNotifyListeners(() {
        state = state.copyWith(saying: false);
        chat[chat.length - 1] = ChatMessage.assistant(value);
      });
    }).catchError((_) => _onError(onError));
  }

  void _sendPrompt(
    String prompt,
    Function(String text) onSaying,
    Function onError,
  ) {
    llmPrompt.prompt(prompt).then((value) {
      safeNotifyListeners(() {
        String text = value.toString();
        state = state.copyWith(saying: false, loading: false);
        onSaying(text);
        chat[chat.length - 1] = ChatMessage.assistant(text);
      });
    }).catchError((_) => _onError(onError));
  }

  _onError(Function onError) {
    safeNotifyListeners(() {
      state = state.copyWith(
        loading: false,
        saying: false,
        error: true,
      );
      onError();
    });
  }

  void safeNotifyListeners(void Function() call) {
    call();
    Future.delayed(Duration.zero, notifyListeners);
  }
}
