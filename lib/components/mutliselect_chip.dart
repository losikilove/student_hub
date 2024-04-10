import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class MultiSelectChip<T> extends StatefulWidget {
  final List<T>? initialList;
  final List<T> listOf;
  // this function is called when parent needs to get list of selected items
  final void Function(List<T> selectedItems) onHelper;
  const MultiSelectChip({
    super.key,
    required this.listOf,
    required this.onHelper,
    this.initialList,
  });

  @override
  State<MultiSelectChip<T>> createState() => _MultiSelectChipState<T>();
}

class _MultiSelectChipState<T> extends State<MultiSelectChip<T>> {
  late List<T> _selectedItems;
  late List<ValueItem<T>> _initialOptions;
  late List<ValueItem<T>> _options;

  @override
  void initState() {
    super.initState();

    // init value-items
    setState(() {
      _options = widget.listOf
          .map((item) => ValueItem(label: item.toString(), value: item))
          .toList();
      if (widget.initialList != null) {
        _selectedItems = widget.initialList!;
        _initialOptions = widget.initialList!
            .map((item) => ValueItem(label: item.toString(), value: item))
            .toList();
      } else {
        _selectedItems = [];
        _initialOptions = [];
      }
    });

    widget.onHelper(_selectedItems);
  }

  void onOptionSelected(List<ValueItem<T>> selectedOptions) {
    setState(() {
      _selectedItems = selectedOptions.map((item) => item.value!).toList();
    });

    widget.onHelper(_selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown<T>(
      fieldBackgroundColor: Theme.of(context).colorScheme.onSecondary,
      optionsBackgroundColor: Theme.of(context).colorScheme.onSecondary,
      dropdownBackgroundColor: Theme.of(context).colorScheme.onSecondary,
      borderRadius: 0.0,
      hint: 'Choose skills',
      onOptionSelected: onOptionSelected,
      options: _options,
      selectedOptions: _initialOptions,
      selectionType: SelectionType.multi,
      dropdownHeight: 250,
      chipConfig: ChipConfig(
        wrapType: WrapType.wrap,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      selectedOptionIcon: const Icon(Icons.check),
    );
  }
}
