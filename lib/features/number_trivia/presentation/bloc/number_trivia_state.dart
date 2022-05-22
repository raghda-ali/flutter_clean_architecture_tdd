part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class NumberTriviaInitial extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  const Loaded({required this.numberTrivia});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class Error extends NumberTriviaState {
  final String errorMessage;

  const Error({required this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}
