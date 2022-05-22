import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concreteNumberTrivia;
  final GetRandomNumberTrivia randomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : concreteNumberTrivia = concrete,
        randomNumberTrivia = random,
        super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      // await Future.sync(
      //   () => inputEither.fold(
      //     (failure) =>
      //         emit(const Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)),
      //     (integer) async {
      //       emit(Loading());
      //     },
      //   ),
      // );
    });
  }

  NumberTriviaState get initialState => Empty();

  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {}
}
