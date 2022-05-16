import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure,Type>?> call(Params parameters);
}
class NoParams extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}