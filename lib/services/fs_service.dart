import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  Stream<QuerySnapshot> categorias(){
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }
}