import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/fs_service.dart';

class DetallePage extends StatelessWidget {

  final QueryDocumentSnapshot publicacion;

  const DetallePage({super.key, required this.publicacion});

  @override
  Widget build(BuildContext context) {

    final Blob foto = publicacion['foto'] as Blob;
    final Timestamp fecha = publicacion['fecha'] as Timestamp;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 154, 157, 250),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 154, 157, 250),
        foregroundColor: Colors.white,
        title: Text('Informacion'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Image.memory(foto.bytes, width: double.infinity, height: 250, fit: BoxFit.contain,),

              SizedBox(height: 25,),

              Text(publicacion['titulo'], style: TextStyle(color: Colors.white, fontSize: 28),),

              SizedBox(height: 15,),

              Text('Tipo: ${publicacion['tipo']}' ,style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),

              SizedBox(height: 15,),

              Text('Categoria: ${publicacion['categoria']}' ,style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),

              SizedBox(height: 10,),

              Text('Estado: ${publicacion['estado']}' ,style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),

              Divider(height: 40, color: Colors.white,),

              Text('Descripcion:',style: TextStyle(fontSize: 20, color:  Color.fromARGB(255, 255, 255, 255)),),

              SizedBox(height: 10,),

              Text('${publicacion['descripcion']}' ,style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),

              SizedBox(height: 25,),

              Text('Ubicacion: ${publicacion['ubicacion']}' ,style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),

              SizedBox(height: 15,),

              Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(fecha.toDate())}', style: TextStyle(color: Colors.white),),

              SizedBox(height: 15,),

              Text('Publicado por: ${publicacion['autorNombre']}' ,style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),

              SizedBox(height: 30,),

              if (FirebaseAuth.instance.currentUser?.uid == publicacion['autorUid'] && publicacion['estado'] == 'Vigente')
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () async {
                      try {

                        await FsService().devuelto(publicacion.id);

                        if (!context.mounted) return;

                        Navigator.pop(context);

                      } catch (e) {
                        
                        debugPrint('ERROR FIRESTORE: $e');
                        
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error de actualizacion, no se pudo actualizar')
                          )
                        );

                      }
                    }, 

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 114, 159, 255),
                      foregroundColor: Color.fromARGB(255, 0, 0, 0)
                    ),
                    child: Text('Marcar como devuelto')
                  ),
                ),

                SizedBox(height: 15,),

                if (FirebaseAuth.instance.currentUser?.uid == publicacion['autorUid'])
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context, 

                          builder: (dialogContext) {
                            return AlertDialog(
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),

                              title: Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.white),
                              ),

                              content: Text('Quieres eliminar la publicacion?', style: TextStyle(color: Colors.white),),

                              actions: [

                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(dialogContext);
                                  }, 
                                  child: Text('Cancelar')
                                ),

                                ElevatedButton(
                                  onPressed: () async {
                                    try {

                                      await FsService().eliminar(publicacion.id);

                                      if (!context.mounted || !dialogContext.mounted) return;

                                      Navigator.pop(dialogContext);
                                      Navigator.pop(context);

                                    } catch (e) {

                                      if (!context.mounted || !dialogContext.mounted) return;

                                      Navigator.pop(dialogContext);

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));

                                    }
                                  }, 
                                  child: Text('Eliminar')
                                )
                              ],
                            );
                          }
                        );
                      }, 

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white
                      ),

                      child: Text('Eliminar')
                    ),
                  )
            ],
          ),
        ),
      )
    );
  }
}