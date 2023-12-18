import 'package:flutter_openchat/flutter_openchat.dart';
import 'package:flutter_openchat/src/data/openchat_team/openchat_team_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class ClientMock extends Mock implements http.Client {}

void main() {
  late OpenChatTeamRepository repository;
  late http.Client client;
  setUp(() {
    final uri = Uri.parse('https://example.com');
    client = ClientMock();
    final request = http.Request('POST', uri);
    registerFallbackValue(request);
    repository = OpenChatTeamRepository(
      client: client,
      uri: uri,
      model: ChatModel.mistralv3Dot2(),
      temperature: 0.5,
    );
  });

  test('Should return correct response', () async {
    String responseString = 'Hello chat!';
    when(() => client.send(any())).thenAnswer((invocation) {
      return Future.value(
        http.StreamedResponse(
          Stream.value(
            responseString.codeUnits,
          ),
          200,
        ),
      );
    });

    final stream = await repository.send([ChatMessage.user('Hello!')]);
    final resp = await stream.data;
    expect(resp, responseString);
  });
}
