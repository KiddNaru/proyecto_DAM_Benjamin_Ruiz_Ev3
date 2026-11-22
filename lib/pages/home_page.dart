import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/publicar_page.dart';
import '../services/fs_service.dart';
import 'detalle_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool publicacionesUsuario = false;

  @override
  Widget build(BuildContext context) {

    final usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 181, 190, 233),

      appBar: AppBar(

        backgroundColor: Color.fromARGB(255, 170, 179, 224),
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

            TextButton(
              onPressed: () {
                setState(() {
                  publicacionesUsuario = !publicacionesUsuario;
                });
              }, 
              child: Text(publicacionesUsuario?'Ver todas las publicaciones':'Ver mis publicacioens', style: TextStyle(color: Color.fromARGB(255, 121, 114, 255)),)
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FsService().publicaciones(), 
                builder: (context, snapshot) {

                  if (snapshot.hasError){

                    return Center(
                      child: Text('Error al cargar las publicaciones'),
                    );

                  }

                  if (!snapshot.hasData) {

                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  }

                  var publicaciones = snapshot.data!.docs;

                  if(publicacionesUsuario) {
                    publicaciones = publicaciones.where((publicacion){
                      return publicacion['autorUid'] == FirebaseAuth.instance.currentUser?.uid;
                    }).toList();
                  }

                  if (publicaciones.isEmpty){
                    return Center(
                      child: Text('No hay publicacionbes'),
                    );
                  }

                  return ListView.separated(
                    itemCount: publicaciones.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 12);
                    },

                    itemBuilder: (context, index) {
                      var publicacion = publicaciones[index];

                      Blob foto = publicacion['foto'] as Blob;

                      return Container(
                        padding: EdgeInsets.all(12),

                        decoration: BoxDecoration(color: Color.fromARGB(255, 153, 135, 241)),

                        child: Row(
                          children: [
                            Image.memory(
                              foto.bytes,
                              width: 85,
                              height: 85,
                              fit: BoxFit.cover,
                            ),

                            SizedBox(width: 15,),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    publicacion['titulo'],
                                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                  ),

                                  SizedBox(height: 6,),

                                  Text(
                                    '${publicacion['tipo']} - ${publicacion['categoria']}', style: TextStyle(color: Colors.white54),
                                  ),

                                  SizedBox(height: 8,),

                                  Text(
                                    publicacion['estado'],
                                    style: TextStyle(color: publicacion['estado'] == 'Devuelto'?const Color.fromARGB(255, 120, 181, 239): const Color.fromARGB(255, 182, 61, 61)),
                                  )
                                ],
                              )
                            ),

                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => DetallePage(publicacion: publicacion)
                                  )
                                );
                              }, 
                              icon: Icon(Icons.chevron_right, color: Colors.white,)
                            )
                          ],
                        ),
                      );
                    },
                  );

                }
              )

            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: Color.fromARGB(255, 194, 216, 249,),

        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PublicarPage()));
        },

        child: Icon(Icons.add),
      ),
    );
  }
}