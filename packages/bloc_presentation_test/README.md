# bloc_presentation_test

[![pub.dev badge][pub-badge]][pub-badge-link]
[![Build status][build-badge]][build-badge-link]

A package which makes testing `BlocPresentationMixin`ed `Bloc`s/`Cubit`s more straightforward.
To be used with `bloc_presentation` package.

## Installation

```sh
flutter pub add --dev bloc_presentation_test
```

## Usage

There are 2 ways of stubbing `presentation` stream:

1. using `whenListenPresentation` function
2. extending target `BlocPresentationMixin`ed `Bloc`/`Cubit` with `MockPresentationBloc`/`MockPresentationCubit`

### 1. Approach - `whenListenPresentation`

First, create a mock class of your `BlocPresentationMixin`ed `Bloc`/`Cubit`.
For example, you can use `bloc_test` package to achieve that.

```dart
class MockCommentCubit extends MockCubit implements CommentCubit {}
```

Then, create an instance of `MockCommentCubit` and obtain `StreamController` by calling `whenListenPresentation` with
a newly created mocked cubit.

```dart
final mockCubit = MockCommentCubit();

final controller = whenListenPresentation(mockCubit);
```

It will stub `MockCommentCubit`'s `presentation` stream, so you are able to subscribe to this stream.
Obtained controller can be used for adding events to `presentation` stream.

The returned `StreamController` is disposed in `Cubit`'s/`Bloc`'s `close` method. 
If you override the stub for this method then you need to dispose the controller manually.

```dart
controller.add(const FailedToUpvote());
```

If you specify `initialEvents` argument, `presentation` stream will be stubbed with a stream of given events.

```dart
final controller = whenListenPresentation(
  mockCubit,
  const [FailedToUpvote(), SuccessfulUpvote()],
);
```

### 2. Approach - `MockPresentationCubit`/`MockPresentationBloc`

First, create a mock class of your `BlocPresentationMixin`ed `Bloc`/`Cubit` using `MockPresentationBloc`/`MockPresentationCubit`.

```dart
class MockCommentCubit extends MockPresentationCubit<CommentState> implements CommentCubit {}
```

Then, create an instance of a `MockCommentCubit` and call `emitMockPresentation`.

```dart
final mockCubit = MockCommentCubit();

mockCubit.emitMockPresentation(const FailedToUpvote());
```

It will add `FailedToUpvoteEvent` to `presentation` stream.

After all, remember to call `MockCommentCubit`'s `close` method.

[pub-badge]: https://img.shields.io/pub/v/bloc_presentation_test.svg?logo=dart

[pub-badge-link]: https://pub.dev/packages/bloc_presentation_test

[build-badge]: https://img.shields.io/github/actions/workflow/status/leancodepl/bloc_presentation/bloc_presentation_test-test.yml?branch=master

[build-badge-link]: https://github.com/leancodepl/bloc_presentation/actions/workflows/bloc_presentation_test-test.yml
