import 'dart:math';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentCubit extends Cubit<CommentState> with BlocPresentationMixin {
  CommentCubit() : super(const CommentInitialState());

  void fetch() {
    // fetching comment...
    emit(const CommentReadyState('Hello world', 123, 3));
  }

  void upvote() {
    final state = this.state;
    if (state is! CommentReadyState) {
      return;
    }

    final success = Random().nextBool();

    // Upvoting might fail, but storing this failure in state does not feel right.
    // This is a one time failure that should be communicated to the listeners,
    // but not necessarily persisted in the state.
    if (!success) {
      // we can emit it and forget about cleaning it from the state
      emitPresentation(const FailedToUpvote('bad connection'));
    } else {
      emitPresentation(const SuccessfulUpvote('Successful upvote'));
      emit(CommentReadyState(state.content, state.userId, state.upvotes + 1));
    }
  }
}

class FailedToUpvote implements BlocPresentationEvent {
  const FailedToUpvote(this.reason);

  final String reason;
}

class SuccessfulUpvote implements BlocPresentationEvent {
  const SuccessfulUpvote(this.message);

  final String message;
}

abstract class CommentState {
  const CommentState();
}

class CommentInitialState implements CommentState {
  const CommentInitialState();
}

class CommentReadyState implements CommentState {
  const CommentReadyState(this.content, this.userId, this.upvotes);

  final String content;
  final int userId;
  final int upvotes;
}
