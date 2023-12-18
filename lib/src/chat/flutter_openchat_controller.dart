import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_openchat/flutter_openchat.dart';

class FlutterOpenChatController extends ChangeNotifier {
  OpenChatWidgetState state = OpenChatWidgetState();
  List<ChatMessage> chat = [];
  bool _isLLMChat = false;
  final LLMProvider llmProvider;
  String intialPrompt = '';

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
    bool isInitialPrompt = false,
  }) {
    if (isInitialPrompt) {
      intialPrompt = text;
    } else {
      chat.add(ChatMessage.user(text));
    }
    chat.add(ChatMessage.assistant(''));
    state = state.copyWith(loading: true);
    safeNotifyListeners();

    if (_isLLMChat) {
      _sendChat(
        [
          if (intialPrompt.isNotEmpty) ChatMessage.user(intialPrompt),
          ...chat,
        ],
        onSaying,
        onError,
      );
    } else {
      _sendPrompt(isInitialPrompt ? text : lastUserMsg, onSaying, onError);
    }
  }

  void tryAgain(Function(String text) onSaying, Function onError) {
    if (_isLLMChat) {
      _sendChat(
        [
          if (intialPrompt.isNotEmpty) ChatMessage.user(intialPrompt),
          ...chat,
        ],
        onSaying,
        onError,
      );
    } else {
      _sendPrompt(
        chat.isEmpty ? intialPrompt : lastUserMsg,
        onSaying,
        onError,
      );
    }
  }

  void _sendChat(
    List<ChatMessage> chat,
    Function(String text) onSaying,
    Function onError,
  ) {
    llmChat.chat(chat, onListen: (text) {
      if (state.loading) {
        state = state.copyWith(saying: true, loading: false);
        safeNotifyListeners();
      }
      onSaying(text);
    }).then((value) {
      state = state.copyWith(saying: false);
      if (this.chat.isNotEmpty) {
        this.chat[this.chat.length - 1] = ChatMessage.assistant(value);
      } else {
        this.chat.add(ChatMessage.assistant(value));
      }
      safeNotifyListeners();
    }).catchError((_) {
      if (kDebugMode) {
        print('$llmChat (catchError): $_');
      }
      return _onError(onError);
    });
  }

  void _sendPrompt(
    String prompt,
    Function(String text) onSaying,
    Function onError,
  ) {
    llmPrompt.prompt(prompt).then((value) {
      String text = value.toString();
      state = state.copyWith(saying: false, loading: false);
      onSaying(text);
      chat[chat.length - 1] = ChatMessage.assistant(text);
      safeNotifyListeners();
    }).catchError((_) {
      if (kDebugMode) {
        print('$llmPrompt (catchError): $_');
      }
      return _onError(onError);
    });
  }

  _onError(Function onError) {
    state = state.copyWith(
      loading: false,
      saying: false,
      error: true,
    );
    onError();
    safeNotifyListeners();
  }

  void safeNotifyListeners() {
    Future.delayed(Duration.zero, notifyListeners);
  }
}
