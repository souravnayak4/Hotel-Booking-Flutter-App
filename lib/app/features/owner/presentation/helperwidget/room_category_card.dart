import 'package:flutter/material.dart';

class RoomCategoryCard extends StatefulWidget {
  final int index;
  final List<String> features;
  final Map<String, dynamic> data;
  final VoidCallback onDelete;

  const RoomCategoryCard({
    super.key,
    required this.index,
    required this.features,
    required this.data,
    required this.onDelete,
  });

  @override
  State<RoomCategoryCard> createState() => _RoomCategoryCardState();
}

class _RoomCategoryCardState extends State<RoomCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category ${widget.index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Category Name"),
              onChanged: (value) => widget.data["categoryName"] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              onChanged: (value) => widget.data["price"] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 2,
              onChanged: (value) => widget.data["description"] = value,
            ),
            const SizedBox(height: 10),
            const Text(
              "Select Features:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: widget.features.map((feature) {
                final selected = widget.data["selectedFeatures"].contains(
                  feature,
                );
                return FilterChip(
                  label: Text(feature),
                  selected: selected,
                  onSelected: (bool value) {
                    setState(() {
                      if (value) {
                        widget.data["selectedFeatures"].add(feature);
                      } else {
                        widget.data["selectedFeatures"].remove(feature);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
