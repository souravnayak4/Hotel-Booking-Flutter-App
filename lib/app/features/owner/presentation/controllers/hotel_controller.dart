import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Upload image to Firebase Storage
  Future<String> uploadImage(File imageFile) async {
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    final ref = FirebaseStorage.instance
        .ref()
        .child("hotel_images")
        .child(fileName);

    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  /// Save Hotel Details
  Future<String?> saveHotel({
    required String hotelName,
    required String hotelAddress,
    required String city,
    required String checkIn,
    required String checkOut,
    required File hotelImage,
    required List<Map<String, dynamic>> roomCategories,
  }) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return "User not logged in";

      // Owner ID from logged-in user
      String ownerId = currentUser.uid;

      // Upload image and generate hotelId
      String imageUrl = await uploadImage(hotelImage);
      String hotelId = "${ownerId}_${DateTime.now().millisecondsSinceEpoch}";

      // Admin details (Static OR can fetch from Firestore if needed)
      const String adminId = "ADMIN_UID";
      const String adminEmail = "test1@mail.com";
      const String adminName = "hello";

      // Prepare room categories array
      List<Map<String, dynamic>> formattedCategories = roomCategories.map((
        cat,
      ) {
        return {
          "categoryName": cat["categoryName"] ?? "",
          "price": cat["price"] ?? "",
          "description": cat["description"] ?? "",
          "features": cat["selectedFeatures"] ?? [],
        };
      }).toList();

      // ✅ Hotel Data Map
      Map<String, dynamic> hotelData = {
        "adminId": adminId,
        "adminEmail": adminEmail,
        "adminName": adminName,
        "hotelName": hotelName,
        "hotelAddress": hotelAddress,
        "city": city,
        "checkIn": checkIn,
        "checkOut": checkOut,
        "ownerId": ownerId,
        "hotelImage": imageUrl,
        "roomCategories": formattedCategories,
        "createdAt": FieldValue.serverTimestamp(),
      };

      // Save in Firestore
      await firestore.collection("hotels").doc(hotelId).set(hotelData);

      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }
}
