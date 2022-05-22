import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });
  test(
      'initialState should be empty',
      () => {
            //assert
            expect(bloc.initialState, Empty()),
          });
  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'Test', number: 1);
    test(
        'should call the InputConverter to validate and convert the string to unsigned int',
        () async {
      //arrange
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(const Right(tNumberParsed));
      //act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));
      //assert
      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });
    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));
        final expected = [
          Empty(),
          const Error(errorMessage: 'INVALID_INPUT_FAILURE_MESSAGE'),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );
    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(const GetTriviaForConcreteNumber(
          numberString: tNumberString,
        ));
        await untilCalled(()=>mockGetConcreteNumberTrivia(any()));
        // assert
        verify(()=>mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      },
    );
  });
}
