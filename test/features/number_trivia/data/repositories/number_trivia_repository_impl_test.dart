import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/platform/network_info.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSources extends Mock
    implements NumberTriviaRemoteDataSources {}

class MockLocalDataResources extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSources mockRemoteDataSources;
  late MockLocalDataResources mockLocalDataResources;
  late MockNetworkInfo mockNetworkInfo;
  setUp(() {
    mockRemoteDataSources = MockRemoteDataSources();
    mockLocalDataResources = MockLocalDataResources();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSources,
      localDataSource: mockLocalDataResources,
      networkInfo: mockNetworkInfo,
    );
  });
  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test', number: tNumber);
    // cast NumberTriviaModel to Entity
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check the device is online', () {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockNetworkInfo.isConnected);
    });
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is success',
          () async {
        //arrange
        when(() => mockRemoteDataSources.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSources.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTriviaModel)));
        print(result);
        print(tNumberTriviaModel);
      });
      test(
          'should cache the data locally when the call to remote data source is success',
          () async {
        //arrange
        when(() => mockRemoteDataSources.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSources.getConcreteNumberTrivia(tNumber));
        verify(
            () => mockLocalDataResources.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(() => mockRemoteDataSources.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(() => mockRemoteDataSources.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataResources);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'should return last locally cached data when the cached data is present',
              () async {
            //arrange
            when(()=>mockLocalDataResources.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
            //act
            final result = mockRemoteDataSources.getConcreteNumberTrivia(tNumber);
            //assert
                verifyZeroInteractions(mockRemoteDataSources);
                verify(()=> mockLocalDataResources.getLastNumberTrivia());
                expect(result, equals(const Right(tNumberTrivia)));
          });
    });
  });
}
