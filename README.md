[![Flutter](https://img.shields.io/badge/Made%20with-Flutter-blue.svg)](https://flutter.dev/)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)
[![pub package](https://img.shields.io/pub/v/flutter_openchat.svg)](https://pub.dev/packages/flutter_openchat)

![](https://raw.githubusercontent.com/RafaelBarbosatec/flutter_openchat/main/img/openchat.png)

Flutter package that help integrate your app with open source chat [openchat](https://openchat.team)

## Features

* Use [OpenChatTeam](https://openchat.team) in your app
* Use only LLMProviders to generate text in your app.

## Usage

### OpenChat Team

To use the chat available in [OpenChatTeam](https://openchat.team/) you just use `FlutterOpenChatWidget` passing `OpenChatTeamLLM` in llm param :

```dart

    FlutterOpenChatWidget(
        llm: OpenChatTeamLLM(),
    ),

```

### Customization

This chat is entirely customizable take a look some params to do it:

```dart

    FlutterOpenChatWidget(
        llm: OpenChatTeamLLM(),
        assetBotAvatar: 'botAvatar.png', // You can pass the image asset to bot. It accept url image too.
        assetUserAvatar: 'userAvatar.png', // You can pass the image asset to user. It accept url image too.
        background: MyWidget(), // Here you can customize the chat background
        backgroundEmpty: MyWidget(), // Here you can customize the chat background when there is not messages.
        markdownConfig: MarkdownConfig(), // Here you can settings the markdown style od the bot saying.
    ),

```

If you need recreate the input widget with your way just pass the `inputBuilder`:

```dart

    FlutterOpenChatWidget(
        llm: OpenChatTeamLLM(),
        inputBuilder: (OpenChatWidgetState state,ValueChanged<String> submit) {
          return MyInputWidget(state,submit);
        }
    ),

```


If you need recreate the messages widget with your way just pass the `msgBuilder`:

```dart

    FlutterOpenChatWidget(
        llm: OpenChatTeamLLM(),
        msgBuilder: (BuildContext context, OpenChatItemMessageState state, VoidCallback tryAgain) {
          return MyMsgWidget(state,tryAgain);
        }
    ),

```

### Initial prompt

Yeah, It have support to it. Just init your widget passing the param `initialPrompt`:

```dart

    FlutterOpenChatWidget(
        llm: OpenChatTeamLLM(),
        initialPrompt: 'You are an AI software engineer...',
    ),

```


### Using only the llm to build anything

You can use only the llm calls to give a response and create anything. To it jus use `OpenChatTeamLLM` or `OpenChatCloudLLM`:

```dart

    final llm = OpenChatTeamLLM()
    llm.prompt('What is gravity?',onListen:(text){
        print(text);
    }).then((value){
        print(value);
    })

```

```dart

    final llm = OpenChatTeamLLM()
    llm.chat([
         ChatMessage.assistant('bla bla bla'),
         ChatMessage.user('Ok, thank you!'),
    ],onListen:(text){
        print(text);
    }).then((value){
        print(value);
    })

```