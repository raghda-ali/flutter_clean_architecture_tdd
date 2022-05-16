import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaDataSources{
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}