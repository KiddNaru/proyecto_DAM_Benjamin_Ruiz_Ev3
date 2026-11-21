import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetallePage extends StatelessWidget {

  final QueryDocumentSnapshot publicacion;

  const DetallePage({super.key, required this.publicacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 154, 157, 250),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 154, 157, 250),
        foregroundColor: Colors.white,
        title: Text('Informacion'),
      ),

      body: Center(
        child: Text(publicacion['titulo'], style: TextStyle(color: Colors.white, fontSize: 24),),
      ),
    );
  }
}