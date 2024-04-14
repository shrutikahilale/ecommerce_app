import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

String? selectedValue;

class DropDownBtn extends StatelessWidget {
  final List<String> items;
  final String selectedItemText;
  final Function(String?) onSelect;
  final BoxDecoration decoration; // Add decoration parameter
  const DropDownBtn({
    super.key,
    required this.items,
    required this.selectedItemText,
    required this.onSelect,
    required this.decoration, // Receive decoration parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        // Wrap the DropdownButton2 with Container to apply decoration
        decoration: decoration,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: SizedBox(
              width: 200,
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  selectedItemText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) {
                  onSelect(value);
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
