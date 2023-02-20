import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:bloc_presentation_example/comment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bloc_presentation Demo',
      theme: ThemeData(),
      home: BlocProvider(
        create: (context) => CommentCubit()..fetch(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocPresentationListener<CommentCubit>(
      listener: (context, event) {
        // we know we will receive this event once
        if (event is FailedToUpvote) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(event.reason)));
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<CommentCubit, CommentState>(
            builder: (context, state) {
              if (state is! CommentReadyState) {
                return const CircularProgressIndicator();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Comment by user with ID: ${state.userId}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(state.content),
                  Text('${state.upvotes} upvotes'),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<CommentCubit>().upvote(),
          tooltip: 'Upvote!',
          child: const Icon(Icons.arrow_upward),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
