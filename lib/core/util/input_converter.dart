import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    int integer = int.parse(str);
    try {
      if (integer < 0) return Left(InvalidInputFailure());
      return Right(int.parse(str));
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
