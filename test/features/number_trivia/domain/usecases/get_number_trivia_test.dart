import 'package:clean_architecture_tdd/core/usecases/usecases.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late int tNumber;
  // late NumberTrivia tNumberTrivia;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(
        numberTriviaRepository: mockNumberTriviaRepository);
  });
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  test('should get trivia from the repository', () async {
    //arrange
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));
    //act
    final result = await useCase(NoParams());
    print(result);
    //assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
