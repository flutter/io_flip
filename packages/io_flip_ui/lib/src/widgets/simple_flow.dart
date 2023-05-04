import 'package:flutter/widgets.dart';

/// Signature for callbacks that are to receive and return a value
/// of the same type.
typedef ValueUpdater<T> = T Function(T current);

/// {@template simple_flow}
/// A flow-builder like stepper widget that allows to build a flow of steps
/// in a form.
/// {@endtemplate}
class SimpleFlow<T> extends StatefulWidget {
  /// {@macro simple_flow}
  const SimpleFlow({
    required this.initialData,
    required this.onComplete,
    required this.stepBuilder,
    super.key,
    this.child,
  });

  /// Get a [SimpleFlowState] from the [BuildContext].
  static SimpleFlowState<T> of<T>(BuildContext context) {
    final result =
        context.getInheritedWidgetOfExactType<_SimpleFlowInherited<T>>();
    assert(result != null, 'No ${_SimpleFlowInherited<T>} found in context');
    return result!.state;
  }

  /// The initial data to be used in the flow.
  final ValueGetter<T> initialData;

  /// Called when the flow is marked as completed.
  final ValueChanged<T> onComplete;

  /// The builder for each step of the flow.
  final ValueWidgetBuilder<T> stepBuilder;

  /// Optional child widget to be passed to [stepBuilder].
  final Widget? child;

  @override
  State<SimpleFlow<T>> createState() => _SimpleFlowState<T>();
}

/// Public interface to manipulate the simple flow widget state.
abstract class SimpleFlowState<T> {
  /// Update the current data.
  void update(ValueUpdater<T> updater);

  /// Mark the flow as completed.
  void complete(ValueUpdater<T> updater);
}

class _SimpleFlowState<T> extends State<SimpleFlow<T>>
    implements SimpleFlowState<T> {
  late T data;

  @override
  void initState() {
    super.initState();

    data = widget.initialData();
  }

  @override
  void complete(ValueUpdater<T> updater) {
    setState(() {
      data = updater(data);
      widget.onComplete(data);
    });
  }

  @override
  void update(ValueUpdater<T> updater) {
    setState(() {
      data = updater(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _SimpleFlowInherited<T>(
      state: this,
      child: Builder(
        builder: (context) {
          return widget.stepBuilder(context, data, widget.child);
        },
      ),
    );
  }
}

class _SimpleFlowInherited<T> extends InheritedWidget {
  const _SimpleFlowInherited({
    required super.child,
    required this.state,
  });

  final SimpleFlowState<T> state;

  @override
  bool updateShouldNotify(_SimpleFlowInherited<T> old) {
    return false;
  }
}

/// Adds utility methods to [BuildContext] to manipulate the simple flow widget.
extension SimpleFlowContext on BuildContext {
  /// Update the current data.
  void updateFlow<T>(ValueUpdater<T> updater) {
    SimpleFlow.of<T>(this).update(updater);
  }

  /// Mark the flow as completed.
  void completeFlow<T>(ValueUpdater<T> updater) {
    SimpleFlow.of<T>(this).complete(updater);
  }
}
