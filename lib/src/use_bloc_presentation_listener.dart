import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

/// Subscribes to the presentation stream and invokes `listener` on each event.
///
/// If [bloc] is omitted, [useBlocPresentationListener] will automatically perform
/// a lookup using [Provider] and the current `BuildContext`.
void useBlocPresentationListener<B extends BlocPresentationMixin<Object>>({
  required BlocPresentationWidgetListener listener,
  B? bloc,
}) {
  final context = useContext();
  final effectiveStream = bloc?.presentation ??
      context.select<B, Stream<BlocPresentationEvent>>(
        (bloc) => bloc.presentation,
      );

  useEffect(
    () {
      final subscription = effectiveStream.listen(
        (event) => listener(context, event),
      );

      return subscription.cancel;
    },
    [effectiveStream, listener],
  );
}
