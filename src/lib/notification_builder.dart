// A widget that builds using notifications dispatched via the build context.
library notification_builder;

import 'package:flutter/widgets.dart';

typedef _NotificationBuilderFunc<T extends Notification> = Widget Function(
  BuildContext context,
  T? notification,
  Widget? child,
);

typedef _BuildWhenCallback<T extends Notification> = bool Function(
  T notification,
);

class NotificationBuilder<T extends Notification> extends StatefulWidget {
  const NotificationBuilder({
    Key? key,
    required this.builder,
    this.child,
    this.buildWhen,
  }) : super(key: key);

  /// The main builder method that is used to render your widget.
  ///
  ///  ---
  ///
  /// `notification` parameter will be null at first.
  ///  However, you can use a fallback value:
  ///
  /// ```dart
  /// builder: (context, notification, child) {
  ///   // So at first, this widget will be built using the white colour.
  ///   final color = notification.color ?? Colors.white;
  ///
  ///   return ColoredBox(color: color, child: child);
  /// }
  /// ```
  final _NotificationBuilderFunc<T> builder;

  /// The child widget to pass to the [builder].
  ///
  /// If a [builder] callback's return value contains a subtree that does not depend on notification,
  /// it's more efficient to build that subtree once instead of rebuilding it on every animation tick.
  ///
  /// If the pre-built subtree is passed as the [child] parameter,
  /// the [NotificationBuilder] will pass it back to the [builder] function so that it can be incorporated into the build.
  ///
  /// Using this pre-built child is entirely optional,
  /// but can improve performance significantly in some cases and is therefore a good practice.
  final Widget? child;

  /// The callback that is fired before rebuilding.
  /// If the result is false, notification is ignored and the widget is not rebuit.
  final _BuildWhenCallback<T>? buildWhen;

  @override
  State<NotificationBuilder<T>> createState() => _NotificationBuilderState<T>();
}

class _NotificationBuilderState<T extends Notification>
    extends State<NotificationBuilder<T>> {
  T? _notification;

  late Widget _buildResult;

  bool _onNotification(T notification) {
    if (notification != _notification) {
      setState(() {
        _notification = notification;
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final notification = _notification;

    if (notification == null) {
      return _buildResult = NotificationListener(
        onNotification: _onNotification,
        child: widget.builder(context, null, widget.child),
      );
    }

    final buildWhen = widget.buildWhen;

    if (buildWhen != null) {
      final toBuild = buildWhen(notification);

      if (!toBuild) {
        return _buildResult;
      }
    }

    return _buildResult = NotificationListener(
      onNotification: _onNotification,
      child: widget.builder(context, notification, widget.child),
    );
  }
}
