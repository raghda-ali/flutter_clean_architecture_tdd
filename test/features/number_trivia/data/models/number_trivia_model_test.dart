import 'dart:convert';

import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures.reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(text: 'Test', number: 1);
  test('should be a subclass of Number trivia entity', () {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  group('fromJson', () {
    test('should return a valid model when json number is an integer',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
    test('should return a valid model when json number is an double', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a json map containing a proper data', () async {
      //arrange
      final result = tNumberTriviaModel.toJson();
      final expectedJsonMap = {
        "text": "Test",
        "number": 1,
      };
      //act
      expect(result, expectedJsonMap);
    });
  });
}
