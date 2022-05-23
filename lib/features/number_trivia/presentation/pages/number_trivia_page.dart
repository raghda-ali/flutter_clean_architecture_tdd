import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/trivia_control.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:clean_architecture_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        backgroundColor: Colors.green.shade800,
      ),
      body: BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaInitial) {
                    return const MessageDisplay(message: 'Start Searching!');
                  } else if (state is NumberTriviaLoading) {
                    return const LoadingWidget();
                  } else if (state is NumberTriviaLoaded) {
                    return TriviaDisplay(numberTrivia: state.numberTrivia);
                  } else if (state is NumberTriviaFailure) {
                    return MessageDisplay(message: state.errorMessage);
                  } else {
                    return const Text('Unexpected Error!');
                  }
                },
              ),
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}