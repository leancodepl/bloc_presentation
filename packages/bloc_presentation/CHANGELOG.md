# 1.1.0

- Bump dependency on `flutter_bloc` to `9.0.0`. (#37, thanks @bobekos)

# 1.0.1

- Removed dependency on `provider`.

# 1.0.0

- **BREAKING**: Removed `useBlocPresentationListener` hook. Use `useOnStreamChanged` from `flutter_hooks` instead.
- Removed dependency on `flutter_hooks`.

# 0.4.0

- **BREAKING**: `BlocPresentationMixin` is now generic over the type of the presentation event (see #17)
- **BREAKING**: removed `BlocPresentationEvent` marker type

# 0.3.0

- Bump minimum Flutter version to `3.10.0` (#22)
- Bump dependency on `flutter_hooks` to `^0.20.0` (#22)

# 0.2.1+2

- Fix example path in README

# 0.2.1+1

- Improve README

# 0.2.1

- Replace listener's bloc state type bound with `dynamic` (by @petrnymsa)

# 0.2.0

- Bump minimum Flutter version to 3.3.0.

# 0.1.1

- Loosen Dart SDK constraint to >=2.12.0

# 0.1.0

- Initial release

# 0.0.0

- Parking package name. Publishing soon.
