part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class NumberTriviaInitial extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class NumberTriviaEmpty extends NumberTriviaState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NumberTriviaLoading extends NumberTriviaState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  const NumberTriviaLoaded({required this.numberTrivia});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NumberTriviaFailure extends NumberTriviaState {
  final String errorMessage;

  const NumberTriviaFailure({required this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}
