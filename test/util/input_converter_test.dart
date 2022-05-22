import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      //arrange
      const str = '123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, const Right(123));
    });
    test('should return failure when the string is not an integer', () async {
      //arrange
      const str = 'aaa';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return failure when the string is negative number', () async {
      //arrange
      const str = '-1';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
