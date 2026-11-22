import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class FsService {
  Stream<QuerySnapshot> categorias(){
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  Future<void> agregarPublicacion(
    String titulo,
    String descripcion,
    String tipo,
    String categoria,
    String ubicacion,
    DateTime fecha,
    Uint8List fotoBytes,
    String autorUid,
    String autorNombre
  ) {
    return FirebaseFirestore.instance.collection('publicaciones').doc().set({

      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'categoria': categoria,
      'ubicacion': ubicacion,
      'fecha': Timestamp.fromDate(fecha),
      'foto': Blob(fotoBytes),
      'estado': 'Vigente',
      'autorUid': autorUid,
      'autorNombre': autorNombre,

    });
  }

  Stream<QuerySnapshot> publicaciones(){
    return FirebaseFirestore.instance.collection('publicaciones').snapshots();
  }

  Future<void> devuelto(String id){
    return FirebaseFirestore.instance.collection('publicaciones').doc(id).update({'estado': 'Devuelto'});
  }

  Future<void> eliminar(String id){
    return FirebaseFirestore.instance.collection('publicaciones').doc(id).delete();
  }
}