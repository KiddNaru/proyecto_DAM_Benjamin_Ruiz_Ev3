import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/fs_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 162, 234),

      appBar: AppBar(

        backgroundColor: Color.fromARGB(255, 147, 162, 234),
        title: Text('Hola, ${usuario?.displayName ?? "Usuario"}', style: TextStyle(color: Colors.white, fontSize: 27),),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            }, 
            icon: Icon(Icons.logout, color: Colors.white,)
          )
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(25),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text('Objetos Perdidos USM', style: TextStyle(color: Colors.white38,fontSize: 16,)),

            SizedBox(height: 50,),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FsService().categorias(), 
                builder: (context, snapshot){
                  
                  if (snapshot.hasError){
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var categorias = snapshot.data!.docs;

                  return ListView.separated( 
                    separatorBuilder: (context, index) {
                      return Divider();
                    }, 
                    itemCount: categorias.length,
                    itemBuilder: (context, index){
                      var categoria = categorias[index];

                      return ListTile(
                        title: Text(categoria['nombre']),
                      );
                    }, 
                  );

                }
              )
            )
          ],
        ),
      ),
    );
  }
}