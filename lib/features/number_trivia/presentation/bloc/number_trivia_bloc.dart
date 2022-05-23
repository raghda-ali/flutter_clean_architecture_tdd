import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/usecases/usecases.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';
const String UNEXPECTED_ERROR = 'Unexpected Error';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concreteNumberTrivia;
  final GetRandomNumberTrivia randomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concreteNumberTrivia,
    required this.randomNumberTrivia,
    required this.inputConverter,
  }) :
        super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      final inputEither =
      inputConverter.stringToUnsignedInteger(event.numberString);

      await Future.sync(
            () =>
            inputEither.fold(
                  (failure) =>
                  emit(const NumberTriviaFailure(
                      errorMessage: INVALID_INPUT_FAILURE_MESSAGE)),
                  (integer) async {
                emit(NumberTriviaLoading());

                final failureOrTrivia =
                await concreteNumberTrivia(Params(number: integer));
                _eitherLoadedOrErrorState(emit, failureOrTrivia);
              },
            ),
      );
    });
    on<GetTriviaForRandomNumber>(
          (event, emit) async {
        emit(NumberTriviaLoading());
        final failureOrTrivia = await randomNumberTrivia(NoParams());
        _eitherLoadedOrErrorState(emit, failureOrTrivia);
      },
    );
  }

  void _eitherLoadedOrErrorState(Emitter<NumberTriviaState> emit,
      Either<Failure, NumberTrivia> failureOrTrivia) =>
      failureOrTrivia.fold(
            (failure) =>
            emit(
              NumberTriviaFailure(
                errorMessage: _mapFailureToMessage(failure),
              ),
            ),
            (trivia) => emit(NumberTriviaLoaded(numberTrivia: trivia)),
      );

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_ERROR;
    }
  }

  NumberTriviaState get initialState => NumberTriviaEmpty();

  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event,) async* {}

}