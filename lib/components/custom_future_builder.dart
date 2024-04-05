import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatefulWidget {
  final Future<T>? future;
  final Widget Function(AsyncSnapshot<T> snapshot) widgetWithData;
  final Widget Function(AsyncSnapshot<T> snapshot) widgetWithError;
  final Widget others;

  const CustomFutureBuilder({
    super.key,
    required this.future,
    required this.widgetWithData,
    required this.widgetWithError,
    this.others = const Center(child: CircularProgressIndicator()),
  });

  @override
  State<CustomFutureBuilder<T>> createState() => _CustomFutureBuilderState<T>();
}

class _CustomFutureBuilderState<T> extends State<CustomFutureBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (context, snapshot) {
        Widget child;

        if (snapshot.hasData) {
          child = widget.widgetWithData(snapshot);
        } else if (snapshot.hasError) {
          child = widget.widgetWithError(snapshot);
        } else {
          child = widget.others;
        }

        return child;
      },
    );
  }
}
