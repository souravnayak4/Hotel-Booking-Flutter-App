import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfo(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .set(userInfoMap);
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Save hotel details in Firestore under the "hotels" collection
  Future<void> saveHotelDetails(
    String hotelId,
    Map<String, dynamic> data,
  ) async {
    await firestore.collection("hotels").doc(hotelId).set(data);
  }
}
