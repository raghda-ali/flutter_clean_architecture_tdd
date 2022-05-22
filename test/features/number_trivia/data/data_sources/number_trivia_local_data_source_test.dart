import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtures.reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('get last number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from the shared preferences when there is one in the cache',
        () async {
      //arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      //act
      final result =
          await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
      //assert
      verify(() => mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw a CacheException when there is not a cached value',
        () async {
      //arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      //act
      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
      //assert
      expect(() => call, throwsA(isInstanceOf<CacheException>()));
    });
  });
  group('cached number trivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');
    test('should call shared preferences to cache the data', () async {
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      when(() => mockSharedPreferences.setString(
              cachedNumberTrivia, expectedJsonString))
          .thenAnswer((_) async => true);
      //act
      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      verify(() => mockSharedPreferences.setString(
          cachedNumberTrivia, expectedJsonString));
    });
  });
}
