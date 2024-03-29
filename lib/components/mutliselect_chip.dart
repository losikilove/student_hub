import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class MultiSelectChip<T> extends StatefulWidget {
  final List<T> listOf;
  // this function is called when parent needs to get list of selected items
  final void Function(List<T> selectedItems) onHelper;
  const MultiSelectChip({
    super.key,
    required this.listOf,
    required this.onHelper,
  });

  @override
  State<MultiSelectChip<T>> createState() => _MultiSelectChipState<T>();
}

class _MultiSelectChipState<T> extends State<MultiSelectChip<T>> {
  List<T> _selectedItems = [];
  late List<ValueItem<T>> _options;

  @override
  void initState() {
    super.initState();

    // init value-items
    setState(() {
      _options = widget.listOf
          .map((item) => ValueItem(label: item.toString(), value: item))
          .toList();
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
