import 'package:cloud_firestore/cloud_firestore.dart';

class HotelDatabase {
  Future<Stream<QuerySnapshot>> getAllHotels() async {
    return await FirebaseFirestore.instance.collection("hotels").snapshots();
  }
}
