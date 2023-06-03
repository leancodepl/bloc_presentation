# bloc_presentation_test

[![pub.dev badge][pub-badge]][pub-badge-link]
[![Build status][build-badge]][build-badge-link]

A package which makes testing `bloc_presentation_mixin`ed `bloc`s / `cubit`s more straightforward.
To be used with `bloc_presentation` package.

## Installation

```sh
flutter pub add bloc_presentation_test
```

## Usage

There are 2 ways of stubbing `presentation` stream:

1. using `whenListenPresentation` function
2. extending targeted `bloc_presentation_mixin`ed `bloc` / `cubit` with `MockPresentationBloc` / `MockPresentationCubit`

### 1. Approach - `whenListenPresentation`

First, create a mock class of your `bloc_presentation_mixin`ed `bloc` / `cubit` using `MockCubit` from `bloc_test` package.

```dart
class MockCommentCubit extends MockCubit implements CommentCubit {}
```

Then, create an instance of `MockCommentCubit` and obtain `StreamController` by calling `whenListenPresentation` with newly created mocked cubit.

```dart
final mockCubit = MockCommentCubit();

final controller = whenListenPresentation(mockCubit);
```

It will stub `mockCubit`'s `presentation` stream, so you are able to subscribe to this stream. Obtained controller can be used for adding events to `presentation` stream.

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

### 2. Approach - `MockPresentationCubit` / `MockPresentationBloc`

First, create a mock class of your `bloc_presentation_mixin`ed `bloc` / `cubit` using .

```dart
class MockCommentCubit extends MockPresentationCubit<CommentState> implements CommentCubit {}
```

Then, create an instance of a `MockCommentCubit` and call `emitMockPresentation`.

```dart
final mockCubit = MockCommentCubit();

mockCubit.emitMockPresentation(const FailedToUpvote());
```

It will add `FailedToUpvoteEvent` to `presentation` stream.

[pub-badge]: https://img.shields.io/pub/v/bloc_presentation_test.svg?logo=dart
[pub-badge-link]: https://pub.dev/packages/bloc_presentation_test
[build-badge]: https://img.shields.io/github/actions/workflow/status/leancodepl/bloc_presentation/bloc_presentation_test-test.yml?branch=master
[build-badge-link]: https://github.com/leancodepl/bloc_presentation/actions/workflows/bloc_presentation_test-test.yml
