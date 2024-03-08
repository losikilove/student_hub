import 'package:flutter/material.dart';

class CustomOption<T> extends StatefulWidget {
  // this function is called when you want to set value to others in parent
  final void Function(T? optionValue) onHelper;
  final List<T> options;
  final bool isExpanded;

  const CustomOption({
    super.key,
    required this.options,
    required this.onHelper,
    this.isExpanded = true,
  });

  @override
  State<CustomOption<T>> createState() => _CustomOptionState<T>();
}

class _CustomOptionState<T> extends State<CustomOption<T>> {
  late T _optionValue;
  late List<T> _options;

  @override
  void initState() {
    super.initState();
    _optionValue = widget.options.first;
    _options = widget.options;
    widget.onHelper(_optionValue);
  }

  void onSelected(T? value) {
    setState(() {
      _optionValue = value as T;
    });

    // handle the option in parent
    widget.onHelper(_optionValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return DropdownMenu<T>(
            enableSearch: false,
            width: widget.isExpanded ? constraints.maxWidth : null,
            menuHeight: 250,
            initialSelection: _optionValue,
            hintText: '',
            inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onSelected: onSelected,
            // set up elements of options
            dropdownMenuEntries: _options.map<DropdownMenuEntry<T>>((T option) {
              return DropdownMenuEntry(
                value: option,
                label: option.toString(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
