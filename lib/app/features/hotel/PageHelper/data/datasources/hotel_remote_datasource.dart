import 'package:cloud_firestore/cloud_firestore.dart';

class HotelRemoteDataSource {
  Future<Stream<QuerySnapshot>> getAllHotels() async {
    return FirebaseFirestore.instance.collection("hotels").snapshots();
  }
}
