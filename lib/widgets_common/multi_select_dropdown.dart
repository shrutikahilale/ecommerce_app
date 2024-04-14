// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MultiSelectDropDown extends StatefulWidget {
  final BoxDecoration decoration;
  final String label;
  final List<String> items;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectDropDown({
    super.key,
    required this.decoration,
    required this.items,
    required this.onSelectionChanged,
    required this.label,
  });

  @override
  _MultiSelectDropDownState createState() => _MultiSelectDropDownState();
}

class _MultiSelectDropDownState extends State<MultiSelectDropDown> {
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: widget.decoration,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.4, // Set the width based on your requirement
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: widget.items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    enabled: false,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = selectedItems.contains(item);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? selectedItems.remove(item)
                                  : selectedItems.add(item);
                            });
                            widget.onSelectionChanged(selectedItems);
                          },
                          child: Container(
                            height: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                if (isSelected)
                                  const Icon(Icons.check_box_outlined)
                                else
                                  const Icon(Icons.check_box_outline_blank),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
                value: selectedItems.isEmpty ? null : selectedItems.last,
                onChanged: (value) {},
                selectedItemBuilder: (context) {
                  return widget.items.map(
                    (item) {
                      return Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          selectedItems.join(', '),
                          style: const TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      );
                    },
                  ).toList();
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  height: 40,
                  width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
