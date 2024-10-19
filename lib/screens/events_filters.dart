import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/*
================
More Filters Screen
================
*/
class MoreFiltersScreen extends StatefulWidget {
  final String selectedCity;
  final String selectedGender;

  const MoreFiltersScreen({
    Key? key,
    required this.selectedCity,
    required this.selectedGender,
  }) : super(key: key);

  @override
  State<MoreFiltersScreen> createState() => _MoreFiltersScreenState();
}

class _MoreFiltersScreenState extends State<MoreFiltersScreen> {
  @override
  Widget build(BuildContext context) {
    String city = widget.selectedCity;
    String gender = widget.selectedGender;

    return Scaffold(
      appBar: AppBar(
        title: const Text('More Filters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDropdown(
              label: 'City',
              value: city,
              items: <String>['All', 'London', 'Brighton', 'New York'],
              onChanged: (String? newValue) {
                city = newValue!;
              },
            ),
            const SizedBox(height: 16),
            buildDropdown(
              label: 'Gender',
              value: gender,
              items: <String>['All', 'Male', 'Female', 'Mixed'],
              onChanged: (String? newValue) {
                gender = newValue!;
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Pass the selected filters back to the main screen
                Navigator.pop(context, {'city': city, 'gender': gender});
              },
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  // Dropdown Appearance Widget
  Widget buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
