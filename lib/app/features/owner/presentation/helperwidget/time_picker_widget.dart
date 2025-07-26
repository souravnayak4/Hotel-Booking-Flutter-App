import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const TimePickerWidget({
    super.key,
    required this.label,
    required this.controller,
  });

  Future<void> _pickTime(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) controller.text = time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickTime(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.text.isEmpty ? label : controller.text),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}
