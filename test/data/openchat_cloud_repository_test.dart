import 'package:flutter_openchat/src/data/openchat_cloud/model/openchat_cloud_response.dart';
import 'package:flutter_openchat/src/data/openchat_cloud/openchat_could_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class ClientMock extends Mock implements http.Client {}

void main() {
  late OpenChatCouldRepository repository;
  late http.Client client;
  setUp(() {
    final uri = Uri.parse('https://example.com');
    client = ClientMock();
    final request = http.Request('POST', uri);
    registerFallbackValue(request);
    repository = OpenChatCouldRepository(
      client: client,
      token: '',
      uri: uri,
    );
  });

  test('Should return correct response', () async {
    String responseString = 'Hello chat!';
    when(() => client.send(any())).thenAnswer((invocation) {
      return Future.value(
        http.StreamedResponse(
          Stream.value(
            OpenChatCloudResponse(
              response: OpenChatCloudResponseResponse(
                text: responseString,
              ),
              type: 'text',
            ).toJson().codeUnits,
          ),
          200,
        ),
      );
    });

    final stream = await repository.send('Hello');
    final resp = await stream.data;
    expect(resp.response.text, responseString);
  });
}
