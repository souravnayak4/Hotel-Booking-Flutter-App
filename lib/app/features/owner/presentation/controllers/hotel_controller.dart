import 'dart:io';
import 'package:hotelbooking/app/core/services/cloudinary_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Upload image to Cloudinary
  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/${CloudinaryConfig.cloudName}/image/upload",
      );
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = CloudinaryConfig.uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      final jsonRes = json.decode(resBody);

      if (response.statusCode == 200 && jsonRes['secure_url'] != null) {
        return jsonRes['secure_url'];
      } else {
        print("Cloudinary upload failed: $jsonRes");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  /// Save Hotel Details to Firestore
  Future<String?> saveHotel({
    required String hotelName,
    required String hotelAddress,
    required String aboutPlace,
    required String city,
    required String checkIn,
    required String checkOut,
    required File hotelImage,
    required List<Map<String, dynamic>> roomCategories,
  }) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return "User not logged in";

      String ownerId = currentUser.uid;

      // Upload Hotel Main Image
      String? imageUrl = await uploadImage(hotelImage);
      if (imageUrl == null) return "Hotel image upload failed";

      // Upload Room Images
      List<Map<String, dynamic>> formattedCategories = [];
      for (var room in roomCategories) {
        File? roomImgFile = room['image'];
        if (roomImgFile == null) continue;

        String? roomImageUrl = await uploadImage(roomImgFile);
        if (roomImageUrl == null) return "Room image upload failed";

        formattedCategories.add({
          "categoryName": room["categoryName"] ?? "",
          "price": room["price"] ?? "",
          "description": room["description"] ?? "",
          "features": room["selectedFeatures"] ?? [],
          "image": roomImageUrl,
        });
      }

      String hotelId = "${ownerId}_${DateTime.now().millisecondsSinceEpoch}";

      const String adminId = "757525244555222";
      const String adminEmail = "admin@mail.com";
      const String adminName = "admin";

      Map<String, dynamic> hotelData = {
        "adminId": adminId,
        "adminEmail": adminEmail,
        "adminName": adminName,
        "hotelName": hotelName,
        "hotelAddress": hotelAddress,
        "aboutPlace": aboutPlace,
        "city": city,
        "checkIn": checkIn,
        "checkOut": checkOut,
        "hotelownerId": ownerId,
        "hotelImage": imageUrl,
        "roomCategories": formattedCategories,
        "createdAt": FieldValue.serverTimestamp(),
      };

      await firestore.collection("hotels").doc(hotelId).set(hotelData);
      return null;
    } catch (e) {
      return "Error saving hotel: $e";
    }
  }
}
