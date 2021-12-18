import 'package:bloc_presentation/src/bloc_presentation_event.dart';
import 'package:bloc_presentation/src/use_bloc_presentation_listener.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nested/nested.dart';

import 'bloc_presentation_mixin.dart';

typedef BlocPresentationWidgetListener = void Function(
  BuildContext,
  BlocPresentationEvent,
);

class BlocPresentationListener<C extends BlocPresentationMixin<Object>>
    extends SingleChildStatelessWidget {
  const BlocPresentationListener({
    Key? key,
    this.cubit,
    required this.listener,
    Widget? child,
  }) : super(key: key, child: child);

  final C? cubit;
  final BlocPresentationWidgetListener listener;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return _BlocPresentationListenerImpl<C>(
      listener: listener,
      cubit: cubit,
      child: child ?? const SizedBox(),
    );
  }
}

class _BlocPresentationListenerImpl<C extends BlocPresentationMixin<Object>>
    extends HookWidget {
  const _BlocPresentationListenerImpl({
    Key? key,
    this.cubit,
    required this.listener,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final C? cubit;
  final BlocPresentationWidgetListener listener;

  @override
  Widget build(BuildContext context) {
    useBlocPresentationListener(
      listener: listener,
      cubit: cubit,
    );

    return child;
  }
}
