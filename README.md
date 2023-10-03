| Package                                                 | Documentation                                         | pub                                                                                                                | CI                                                                                 |
|---------------------------------------------------------|:-----------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------:|
| [`bloc_presentation`][bloc_presentation-link]           | [Documentation][bloc_presentation-documentation]      | [![bloc_presentation pub.dev badge][bloc_presentation-pub-badge]][bloc_presentation-pub-badge-link]                | [![][bloc_presentation-build-badge]][bloc_presentation-build-badge-link]           |
| [`bloc_presentation_test`][bloc_presentation_test-link] | [Documentation][bloc_presentation_test-documentation] | [![bloc_presentation_test pub.dev badge][bloc_presentation_test-pub-badge]][bloc_presentation_test-pub-badge-link] | [![][bloc_presentation_test-build-badge]][bloc_presentation_test-build-badge-link] |

## pub.dev release process

Tag your desired commit with `<package_name>-v<version>` and let the GitHub Actions do the rest.

## How to use BlocPresentationMixin with flutter_hooks

Let's assume you have a cubit that emits presentation events:

```dart
class MyCubit extends Cubit<MyState> with BlocPresentationMixin {
    (...)
}
```

then put inside your `HookWidget`'s `build` method:
```dart
useOnStreamChange(
  bloc.presentation, 
  (event) {
    // Implement your listener here
  },
)
```

[bloc_presentation-link]: https://github.com/leancodepl/bloc_presentation/tree/master/packages/bloc_presentation
[bloc_presentation-documentation]: https://pub.dev/documentation/bloc_presentation/latest/
[bloc_presentation-pub-badge]: https://img.shields.io/pub/v/bloc_presentation
[bloc_presentation-pub-badge-link]: https://pub.dev/packages/bloc_presentation
[bloc_presentation-build-badge]: https://img.shields.io/github/actions/workflow/status/leancodepl/bloc_presentation/bloc_presentation-test.yml?branch=master
[bloc_presentation-build-badge-link]: https://github.com/leancodepl/bloc_presentation/actions/workflows/bloc_presentation-test.yml

[bloc_presentation_test-link]: https://github.com/leancodepl/bloc_presentation/tree/master/packages/bloc_presentation_test
[bloc_presentation_test-documentation]: https://pub.dev/documentation/bloc_presentation_test/latest/
[bloc_presentation_test-pub-badge]: https://img.shields.io/pub/v/bloc_presentation_test
[bloc_presentation_test-pub-badge-link]: https://pub.dev/packages/bloc_presentation_test
[bloc_presentation_test-build-badge]: https://img.shields.io/github/actions/workflow/status/leancodepl/bloc_presentation/bloc_presentation_test-test.yml?branch=master
[bloc_presentation_test-build-badge-link]: https://github.com/leancodepl/bloc_presentation/actions/workflows/bloc_presentation_test-test.yml