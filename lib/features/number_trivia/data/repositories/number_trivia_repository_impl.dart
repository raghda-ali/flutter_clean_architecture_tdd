import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/platform/network_info.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSources remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final trivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(trivia);
        return Right(trivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
