import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:bloc_presentation_example/comment_cubit.dart';
import 'package:bloc_presentation_example/main.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCommentCubit extends MockCubit<CommentState>
    implements CommentCubit {}

void main() {
  late MockCommentCubit commentCubit;

  setUp(() {
    commentCubit = MockCommentCubit();
  });

  Future<void> setupScreen(
    WidgetTester tester, {
    CommentState? initialState,
    List<CommentState> states = const [],
    List<BlocPresentationEvent> presentationEvents = const [],
  }) async {
    whenListen<CommentState>(
      commentCubit,
      Stream.fromIterable(states),
      initialState: initialState ?? const CommentInitialState(),
    );

    whenListenPresentation2(
      commentCubit,
      presentationEvents,
    );

    await tester.pumpWidget(
      _TestApp(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CommentCubit>.value(value: commentCubit),
          ],
          child: const MyHomePage(),
        ),
      ),
    );
    await tester.pump();
  }

  group(
    'MyHomePage',
    () {
      testWidgets(
        'shows SnackBar with error message when cubit has emitted '
        'FailedToUpvote presentation event',
        (tester) async {
          await setupScreen(
            tester,
            initialState: _commentReadyState,
            presentationEvents: [_failedToUpvoteEvent],
          );

          await tester.pumpAndSettle();

          final snackBar = find.byType(SnackBar);

          expect(snackBar, findsOneWidget);
          expect(
            find.descendant(
              of: snackBar,
              matching: find.textContaining(_failedToUpvoteEvent.reason),
            ),
            findsOneWidget,
          );
        },
      );
    },
  );
}

class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
    );
  }
}

const _commentReadyState = CommentReadyState('Content', 1, 0);
const _failedToUpvoteEvent = FailedToUpvote('Bad connection');
