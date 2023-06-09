# bloc_presentation

[![pub.dev badge][pub-badge]][pub-badge-link]
[![Build status][build-badge]][build-badge-link]

Extends blocs with an additional stream serving as a way of indicating
single-time events (so-called "_presentation events_").

## Installation

```sh
flutter pub add bloc_presentation
```

## Usage

First, create an event which will be emitted:

```dart
class FailedToUpvote implements BlocPresentationEvent {
  const FailedToUpvote(this.reason);

  final String reason;
}
```

Next, extend your Bloc/Cubit with the presentation mixin which will give you
access to the `emitPresentation` method:

```dart
class CommentCubit extends Cubit<CommentState> with BlocPresentationMixin {
  // body
}
```

Now in your methods instead of emitting new state, you can emit a single-time
presentation event without overwriting your Bloc/Cubit state:

```dart
void upvote() {
  // upvoting logic

  if (!success) {
    // we can emit it and forget about cleaning it from the state
    emitPresentation(const FailedToUpvote('bad connection'));
  } else {
    emit(/* new state */);
  }
}
```

In this case above, we do not want to lose our Bloc/Cubit state after a
non-fatal failure. Instead, we want to communicate this failure and not emit any
new states. Then, in the UI code one can react to such events using
`BlocPresentationListener` or `useBlocPresentationListener`:

```dart
BlocPresentationListener<CommentCubit>(
  listener: (context, event) {
    if (event is FailedToUpvote) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
		..showSnackBar(SnackBar(content: Text(event.reason)));
    }
  },
  child: MyWidget(),
)
```

By default, `CommentCubit` will be looked up using `package:provider` in the
widget tree. However, a bloc can be provided directly using the
`BlocPresentationListener.bloc` parameter (analogous to how `package:bloc`
listeners work).

### Example

[Here it is.](example/lib)

[pub-badge]: https://img.shields.io/pub/v/bloc_presentation.svg?logo=dart
[pub-badge-link]: https://pub.dev/packages/bloc_presentation
[build-badge]: https://img.shields.io/github/actions/workflow/status/leancodepl/bloc_presentation/bloc_presentation-test.yml?branch=master
[build-badge-link]: https://github.com/leancodepl/bloc_presentation/actions/workflows/bloc_presentation-test.yml
