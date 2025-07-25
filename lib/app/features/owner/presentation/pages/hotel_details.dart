import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HotelDetailsByOwnerPage extends StatefulWidget {
  const HotelDetailsByOwnerPage({super.key});

  @override
  State<HotelDetailsByOwnerPage> createState() =>
      _HotelDetailsByOwnerPageState();
}

class _HotelDetailsByOwnerPageState extends State<HotelDetailsByOwnerPage> {
  final TextEditingController hotelNameController = TextEditingController();
  final TextEditingController hotelAddressController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  String? selectedCity;
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
    "Chandigarh",
    "Surat",
    "Indore",
    "Bhopal",
    "Nagpur",
    "Goa",
    "Mysuru",
    "Varanasi",
    "Coimbatore",
    "Patna",
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

  void addCategory() {
    setState(() {
      roomCategories.add({
        "categoryName": "",
        "price": "",
        "description": "",
        "selectedFeatures": <String>{},
      });
    });
  }

  void removeCategory(int index) {
    setState(() {
      roomCategories.removeAt(index);
    });
  }

  Future<void> pickTime(TextEditingController controller) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      controller.text = time.format(context);
    }
  }

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

  Future<String> uploadImageToFirebase() async {
    if (hotelImage == null) return "";
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    final ref = FirebaseStorage.instance
        .ref()
        .child("hotel_images")
        .child(fileName);
    await ref.putFile(hotelImage!);
    return await ref.getDownloadURL();
  }

  Future<void> saveHotelDetails() async {
    try {
      const String adminId = "ADMIN_UID"; // Replace with actual admin UID

      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not logged in")));
        return;
      }

      String ownerId = currentUser.uid;

      // Upload image to Firebase
      String imageUrl = await uploadImageToFirebase();

      // Prepare hotel data
      Map<String, dynamic> hotelData = {
        "hotelName": hotelNameController.text.trim(),
        "hotelAddress": hotelAddressController.text.trim(),
        "city": selectedCity,
        "checkIn": checkInController.text.trim(),
        "checkOut": checkOutController.text.trim(),
        "ownerId": ownerId,
        "adminId": adminId,
        "hotelImage": imageUrl, // ✅ Image URL saved
        "createdAt": FieldValue.serverTimestamp(),
        "roomCategories": roomCategories.map((category) {
          return {
            "categoryName": category["categoryName"],
            "price": category["price"],
            "description": category["description"],
            "features": (category["selectedFeatures"] as Set<String>).toList(),
          };
        }).toList(),
      };

      await FirebaseFirestore.instance.collection("hotels").add(hotelData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hotel details saved successfully!")),
      );

      hotelNameController.clear();
      hotelAddressController.clear();
      checkInController.clear();
      checkOutController.clear();
      setState(() {
        selectedCity = null;
        roomCategories.clear();
        hotelImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving hotel: $e")));
    }
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 2.0,
                                color: Colors.black,
                              ),
                              image: hotelImage != null
                                  ? DecorationImage(
                                      image: FileImage(hotelImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: hotelImage == null
                                ? const Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                    size: 35,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      /// Hotel Name
                      buildTextField(
                        "Hotel Name",
                        hotelNameController,
                        "Enter Hotel Name",
                      ),

                      /// Hotel Address
                      buildTextField(
                        "Hotel Address",
                        hotelAddressController,
                        "Enter Hotel Address",
                      ),

                      /// City Dropdown
                      const Text(
                        "City",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCity,
                            hint: const Text("Select City"),
                            items: cities.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCity = value;
                              });
                            },
                          ),
                        ),
                      ),

                      /// Check-in
                      buildTimePicker("Check-in Time", checkInController),
                      buildTimePicker("Check-out Time", checkOutController),

                      /// Room Categories
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text("+ Add Category"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// Dynamic Room Categories
                      Column(
                        children: List.generate(roomCategories.length, (index) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Category ${index + 1}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => removeCategory(index),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Room Category Name",
                                    ),
                                    onChanged: (val) =>
                                        roomCategories[index]['categoryName'] =
                                            val,
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: const InputDecoration(
                                      labelText: "Base Price",
                                      prefixIcon: Icon(Icons.currency_rupee),
                                    ),
                                    onChanged: (val) =>
                                        roomCategories[index]['price'] = val,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: TextField(
                                      maxLines: 3,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Description",
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) =>
                                          roomCategories[index]['description'] =
                                              val,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Features:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    children: features.map((feature) {
                                      bool isSelected =
                                          roomCategories[index]['selectedFeatures']
                                              .contains(feature);
                                      return FilterChip(
                                        label: Text(feature),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              roomCategories[index]['selectedFeatures']
                                                  .add(feature);
                                            } else {
                                              roomCategories[index]['selectedFeatures']
                                                  .remove(feature);
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
                        }),
                      ),

                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: saveHotelDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Save Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTimePicker(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => pickTime(controller),
          child: Container(
            margin: const EdgeInsets.only(top: 8, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              controller.text.isEmpty ? "Select $label" : controller.text,
            ),
          ),
        ),
      ],
    );
  }
}
