import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/hotel_controller.dart';

class HotelDetailsByOwnerPage extends StatefulWidget {
  const HotelDetailsByOwnerPage({super.key});

  @override
  State<HotelDetailsByOwnerPage> createState() =>
      _HotelDetailsByOwnerPageState();
}

class _HotelDetailsByOwnerPageState extends State<HotelDetailsByOwnerPage> {
  final HotelController _hotelController = HotelController();

  final TextEditingController hotelNameController = TextEditingController();
  final TextEditingController hotelAddressController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  String? selectedCity;
  bool isLoading = false;

  final List<String> cities = [
    "Delhi",
    "Mumbai",
    "Bengaluru",
    "Hyderabad",
    "Chennai",
    "Kolkata",
    "Pune",
    "Ahmedabad",
    "Jaipur",
    "Lucknow",
  ];

  List<Map<String, dynamic>> roomCategories = [];
  final List<String> features = [
    "Free Wi-Fi",
    "Breakfast Included",
    "Air Conditioning",
    "Parking",
    "Swimming Pool",
    "TV",
    "Mini Bar",
    "24/7 Room Service",
  ];

  File? hotelImage;
  final ImagePicker _picker = ImagePicker();

  /// Pick Image
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        hotelImage = File(pickedFile.path);
      });
    }
  }

  /// Pick Time
  Future<void> pickTime(TextEditingController controller) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      controller.text = time.format(context);
    }
  }

  void addCategory() {
    setState(() {
      roomCategories.add({
        "categoryName": "",
        "price": "",
        "description": "",
        "selectedFeatures": <String>[],
      });
    });
  }

  void removeCategory(int index) {
    setState(() {
      roomCategories.removeAt(index);
    });
  }

  /// Save Hotel
  Future<void> saveHotelDetails() async {
    if (hotelImage == null) {
      _showSnackBar("Please select a hotel image");
      return;
    }
    if (hotelNameController.text.trim().isEmpty ||
        hotelAddressController.text.trim().isEmpty ||
        selectedCity == null ||
        checkInController.text.trim().isEmpty ||
        checkOutController.text.trim().isEmpty ||
        roomCategories.isEmpty) {
      _showSnackBar("Please fill all details");
      return;
    }

    setState(() => isLoading = true);

    String? result = await _hotelController.saveHotel(
      hotelName: hotelNameController.text.trim(),
      hotelAddress: hotelAddressController.text.trim(),
      city: selectedCity!,
      checkIn: checkInController.text.trim(),
      checkOut: checkOutController.text.trim(),
      hotelImage: hotelImage!,
      roomCategories: roomCategories,
    );

    setState(() => isLoading = false);

    if (result == null) {
      _showSnackBar("Hotel saved successfully");
      clearForm();
    } else {
      _showSnackBar("Error: $result");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void clearForm() {
    hotelNameController.clear();
    hotelAddressController.clear();
    checkInController.clear();
    checkOutController.clear();
    setState(() {
      selectedCity = null;
      roomCategories.clear();
      hotelImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Hotel Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black),
                            image: hotelImage != null
                                ? DecorationImage(
                                    image: FileImage(hotelImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: hotelImage == null
                              ? const Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                    size: 50,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 15),
                      buildTextField("Hotel Name", hotelNameController),
                      buildTextField("Hotel Address", hotelAddressController),
                      buildDropdown(),
                      buildTimePicker("Check-in Time", checkInController),
                      buildTimePicker("Check-out Time", checkOutController),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Room Categories",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: addCategory,
                            child: const Text("+ Add Category"),
                          ),
                        ],
                      ),
                      Column(
                        children: List.generate(
                          roomCategories.length,
                          buildRoomCard,
                        ),
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: saveHotelDetails,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.all(15),
                              ),
                              child: const Text(
                                "Save Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        value: selectedCity,
        hint: const Text("Select City"),
        items: cities
            .map((city) => DropdownMenuItem(value: city, child: Text(city)))
            .toList(),
        onChanged: (value) => setState(() => selectedCity = value),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildTimePicker(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () => pickTime(controller),
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

  Widget buildRoomCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category ${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeCategory(index),
                ),
              ],
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: "Room Category Name",
              ),
              onChanged: (val) => roomCategories[index]['categoryName'] = val,
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Base Price"),
              onChanged: (val) => roomCategories[index]['price'] = val,
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
              onChanged: (val) => roomCategories[index]['description'] = val,
            ),
            const SizedBox(height: 10),
            const Text("Features:"),
            Wrap(
              spacing: 8,
              children: features.map((feature) {
                bool isSelected = roomCategories[index]['selectedFeatures']
                    .contains(feature);
                return FilterChip(
                  label: Text(feature),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        roomCategories[index]['selectedFeatures'].add(feature);
                      } else {
                        roomCategories[index]['selectedFeatures'].remove(
                          feature,
                        );
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
