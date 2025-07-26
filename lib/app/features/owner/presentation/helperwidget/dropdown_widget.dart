import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final String? selectedCity;
  final List<String> cities;
  final ValueChanged<String?> onChanged;

  const DropdownWidget({
    super.key,
    required this.selectedCity,
    required this.cities,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCity,
          hint: const Text("Select City"),
          isExpanded: true,
          items: cities.map((city) {
            return DropdownMenuItem(value: city, child: Text(city));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
