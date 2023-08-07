import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:bloc_presentation/src/use_bloc_presentation_listener.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import 'bloc_presentation_mixin.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `event` and is responsible for executing in response to
/// new events.
typedef BlocPresentationWidgetListener = void Function(
  BuildContext context,
  BlocPresentationEvent event,
);

/// {@template bloc_presentation_listener}
/// Widget that listens to new presentation events in a specified [bloc].
/// {@endtemplate}
class BlocPresentationListener<B extends BlocPresentationMixin<dynamic>>
    extends SingleChildStatelessWidget {
  /// {@macro bloc_presentation_listener}
  const BlocPresentationListener({
    super.key,
    this.bloc,
    required this.listener,
    super.child,
  });

  /// The [bloc] that the [BlocPresentationListener] will interact with.
  /// If omitted, [BlocPresentationListener] will automatically perform a lookup using
  /// [Provider] and the current `BuildContext`.
  final B? bloc;

  /// The [BlocPresentationWidgetListener] which will be called on every new presentation event.
  final BlocPresentationWidgetListener listener;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return HookBuilder(
      builder: (context) {
        useBlocPresentationListener(
          listener: listener,
          bloc: bloc,
        );

        return child ?? const SizedBox();
      },
    );
  }
}
