import 'dart:convert';

import 'package:clean_architecture_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixtures.reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourcesImpl remoteDataSourcesImpl;
  late MockHttpClient mockClient;
  setUp(() {
    mockClient = MockHttpClient();
    remoteDataSourcesImpl =
        NumberTriviaRemoteDataSourcesImpl(client: mockClient);
  });
  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL with number being the endPoint and the application/json header',
        () async {
      //arrange
      when(() => mockClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
        (_) async => http.Response(fixture('trivia.json'), 200),
      ); //act
      remoteDataSourcesImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ));
    });
    test(
        'should return NumberTrivia when the response is 200(success)',
            () async {
          //arrange
          when(() => mockClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
                (_) async => http.Response(fixture('trivia.json'), 200),
          ); //act
          final result = await remoteDataSourcesImpl.getConcreteNumberTrivia(tNumber);
          //assert
         expect(result, equals(tNumberTriviaModel));
        });
  });
}
