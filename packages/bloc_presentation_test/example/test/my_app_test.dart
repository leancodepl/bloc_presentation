import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_presentation_test_example/comment_cubit.dart';
import 'package:bloc_presentation_test_example/main.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCommentCubit1 extends MockPresentationCubit<CommentState>
    implements CommentCubit {}

class MockCommentCubit2 extends MockCubit<CommentState> //
    implements
        CommentCubit {}

void main() {
  mainMockPresentationCubit();
  mainWhenListenPresentation();
}

void mainMockPresentationCubit() {
  late MockCommentCubit1 commentCubit;

  setUp(() {
    commentCubit = MockCommentCubit1();
  });

  tearDown(() {
    commentCubit.close();
  });

  Future<void> setupScreen(
    WidgetTester tester, {
    CommentState? initialState,
    List<CommentState> states = const [],
    List<BlocPresentationEvent>? presentationEvents,
  }) async {
    whenListen<CommentState>(
      commentCubit,
      Stream.fromIterable(states),
      initialState: initialState ?? const CommentInitialState(),
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
        'shows SnackBar with proper message when cubit has emitted '
        'BlocPresentationEvent',
        (tester) async {
          await setupScreen(
            tester,
            initialState: _commentReadyState,
          );

          commentCubit.emitMockPresentation(_failedToUpvoteEvent);

          await tester.pumpAndSettle();

          final snackBar1 = find.byType(SnackBar);

          expect(snackBar1, findsOneWidget);
          expect(
            find.descendant(
              of: snackBar1,
              matching: find.textContaining(_failedToUpvoteEvent.reason),
            ),
            findsOneWidget,
          );

          commentCubit.emitMockPresentation(_successfulUpvoteEvent);

          await tester.pumpAndSettle();

          final snackBar2 = find.byType(SnackBar);

          expect(snackBar2, findsOneWidget);
          expect(
            find.descendant(
              of: snackBar2,
              matching: find.textContaining(_successfulUpvoteEvent.message),
            ),
            findsOneWidget,
          );
        },
      );
    },
  );
}

void mainWhenListenPresentation() {
  late StreamController<BlocPresentationEvent> presentationController;
  late MockCommentCubit2 commentCubit;

  setUp(() {
    commentCubit = MockCommentCubit2();
  });

  tearDown(() {
    commentCubit.close();
  });

  Future<void> setupScreen(
    WidgetTester tester, {
    CommentState? initialState,
    List<CommentState> states = const [],
    List<BlocPresentationEvent>? presentationEvents,
  }) async {
    whenListen<CommentState>(
      commentCubit,
      Stream.fromIterable(states),
      initialState: initialState ?? const CommentInitialState(),
    );

    presentationController = whenListenPresentation(
      commentCubit,
      initialEvents: presentationEvents,
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
        'shows SnackBar with proper message when cubit has emitted '
        'BlocPresentationEvent',
        (tester) async {
          await setupScreen(
            tester,
            initialState: _commentReadyState,
            presentationEvents: [_failedToUpvoteEvent],
          );

          await tester.pumpAndSettle();

          final snackBar1 = find.byType(SnackBar);

          expect(snackBar1, findsOneWidget);
          expect(
            find.descendant(
              of: snackBar1,
              matching: find.textContaining(_failedToUpvoteEvent.reason),
            ),
            findsOneWidget,
          );

          presentationController.add(_successfulUpvoteEvent);

          await tester.pumpAndSettle();

          final snackBar2 = find.byType(SnackBar);

          expect(snackBar2, findsOneWidget);
          expect(
            find.descendant(
              of: snackBar2,
              matching: find.textContaining(_successfulUpvoteEvent.message),
            ),
            findsOneWidget,
          );
        },
      );

      // This test shows that presentation stream is automatically mocked even
      // if presentation events have not been specified in
      // whenListenPresentation (cubit's presentation getter returns empty
      // stream by default).
      testWidgets(
        'does not SnackBar bar BlocPresentationEvent has not been emitted',
        (tester) async {
          await setupScreen(
            tester,
            initialState: _commentReadyState,
          );

          await tester.pumpAndSettle();

          final snackBar = find.byType(SnackBar);

          expect(snackBar, findsNothing);
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
const _successfulUpvoteEvent = SuccessfulUpvote('Successful upvote');
