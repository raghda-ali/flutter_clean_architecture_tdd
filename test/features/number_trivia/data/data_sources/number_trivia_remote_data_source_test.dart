import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
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
  void setUpMockHttpClientSuccess200() {
    when(() => mockClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailureError404() {
    when(() => mockClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
      (_) async => http.Response('Something wrong', 404),
    );
  }

  setUp(() {
    mockClient = MockHttpClient();
    remoteDataSourcesImpl =
        NumberTriviaRemoteDataSourcesImpl(client: mockClient);
  });
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL with number being the endPoint and the application/json header',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      remoteDataSourcesImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ));
    });
    test('should return NumberTrivia when the response is 200(success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result =
          await remoteDataSourcesImpl.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpClientFailureError404();
      //act
      final call = remoteDataSourcesImpl.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL with number being the endPoint and the application/json header',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      remoteDataSourcesImpl.getRandomNumberTrivia();
      //assert
      verify(() => mockClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'},
          ));
    });
    test('should return NumberTrivia when the response is 200(success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await remoteDataSourcesImpl.getRandomNumberTrivia();
      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpClientFailureError404();
      //act
      final call = remoteDataSourcesImpl.getRandomNumberTrivia();
      //assert
      expect(() => call, throwsA(isInstanceOf<ServerException>()));
    });
  });
}
