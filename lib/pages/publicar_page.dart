import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/fs_service.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';


class PublicarPage extends StatefulWidget {
  const PublicarPage({super.key});

  @override
  State<PublicarPage> createState() => _PublicarPageState();
}

class _PublicarPageState extends State<PublicarPage> {

  final tituloCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  final ubicacionCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  DateTime fechaSeleccionada = DateTime.now();
  TimeOfDay horaSeleccionada = TimeOfDay.now();

  Uint8List? fotoBytes;

  String? tipoSeleccionado;
  String? categoriaSeleccionada;

  bool guardando = false;

  @override

  void dispose(){
    tituloCtrl.dispose();
    descripcionCtrl.dispose();
    ubicacionCtrl.dispose();
    super.dispose();
  }

  Future<void> seleccionarFoto(ImageSource origen) async {
    final XFile? foto = await ImagePicker().pickImage(
      source: origen,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 60,
    );

    if (foto == null){
      return;
    }

    final Uint8List bytes = await foto.readAsBytes();

    if (!mounted) return;

    if(bytes.lengthInBytes > 900000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La foto es muy grande')
        ),
      );

      return;
    }

    setState(() {
      fotoBytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 162, 234),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 147, 162, 234),

        title: Text('Nueva Publicacion', style: TextStyle(color: Colors.white),),
      ),

      body: Padding(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          
              children: [
                Text('Que vas a publicar?', style: TextStyle(color: Colors.white, fontSize: 20),),
          
                SizedBox(height: 25,),
          
                TextFormField(
                  controller: tituloCtrl,
                  style: TextStyle(color: Colors.white),
          
                  decoration: InputDecoration(labelText: 'Nombre Objeto', labelStyle: TextStyle(color: Colors.white38)),
          
                  validator: (value){
                    if (value == null || value.trim().isEmpty){
                      return 'Ingrese nombre';
                    }
          
                    return null;
                  }
                ),
          
                SizedBox(height: 25,),
          
                TextFormField(
                  controller: descripcionCtrl,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white),
          
                  decoration: InputDecoration(labelText: 'Descripcion', labelStyle: TextStyle(color: Colors.white38)),
          
                  validator: (value){
                    if (value == null || value.trim().isEmpty){
                      return 'Ingrese Descripcion';
                    }
          
                    return null;
                  }
                ),
          
                SizedBox(height: 25,),
          
                DropdownButtonFormField<String>(
          
                  dropdownColor:  Color.fromARGB(255, 22, 26, 49),
                  style: TextStyle(color: Colors.white70),
          
                  decoration: InputDecoration(
          
                    labelText: 'Tipo de publicacion',
                    labelStyle: TextStyle(color: Colors.white38)
          
                  ),
          
                  items: [
                    DropdownMenuItem(
                      value: 'Perdido',
                      child: Text('Perdido')
                    ),
          
                    DropdownMenuItem(
                      value: 'Encontrado',
                      child: Text('Encontrado')
                    ),
                  ], 
                  onChanged: (value) {
                    tipoSeleccionado = value;
                  },
          
                  validator: (value) {
                    if(value == null){
                      
                      return 'Seleccione algun campo';
          
                    }
          
                    return null;
                  },
                ),
          
                SizedBox(height: 25,),
                
                StreamBuilder<QuerySnapshot>(
                  stream: FsService().categorias(), 
                  builder: (context, snapshot) {
                    if (snapshot.hasError){
                      return Text('Error en cargar las categorias');
                    }
          
                    if (!snapshot.hasData){
                      return CircularProgressIndicator();
                    }
          
                    var categorias = snapshot.data!.docs;
          
                    return DropdownButtonFormField<String>(
          
                      dropdownColor: Color.fromARGB(255, 16, 26, 36),
          
                      style: TextStyle(color: Colors.white),
          
                      isExpanded: true,
          
                      decoration: InputDecoration(labelText: 'Categoria', labelStyle: TextStyle(color: Colors.white70)),
          
                      items: categorias.map((categoria){
                        return DropdownMenuItem(
                          value: categoria['nombre'] as String,
                          child: Text(categoria['nombre'] as String),
                        );
                      }).toList(), 
          
                      onChanged: (value) {
                        categoriaSeleccionada = value;
                      },
          
                      validator: (value) {
                        if (value == null){
                          return 'Seleccione categoria';
                        }
                        return null;
                      },
                    );
          
                  }
                ),
          
                SizedBox(height: 25,),
          
                TextFormField(
                  controller: ubicacionCtrl,
                  style: TextStyle(color: Colors.white),
          
                  decoration: InputDecoration(
                    labelText: 'Ubicacion donde se encontro el objeto',
                    labelStyle: TextStyle(color: Colors.white70)
                  ),
          
                  validator: (value) {
                    if (value == null || value.trim().isEmpty){
                      return 'Ingrese la ubicacion';
                    }
          
                    return null;
                  },
                ),
          
                SizedBox(height: 25,),
          
                Row(
                  children: [
                    Expanded(
                      child: Text('Fecha: ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada)}',
                      style: TextStyle(color: Colors.white),
                    )
                    ),
          
                    IconButton(
                      onPressed: () {
                        showDatePicker(
                          context: context, 
                          firstDate: DateTime(2000), 
                          lastDate: DateTime.now(),
                          initialDate: fechaSeleccionada,
                        ).then((fecha){
                          if (fecha != null){
                            setState(() {
                              fechaSeleccionada = fecha;
                            });
                          }
                        });
                      }, 
                      icon: Icon(Icons.calendar_month, color: Colors.white,)
                    )
                  ],
                ),
          
                SizedBox(height: 25,),
          
                Row(
                  children: [
                    Expanded(
                      child: Text('Hora: ${horaSeleccionada.hour.toString().padLeft(2, '0')}:${horaSeleccionada.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.white),
                    )
                    ),
          
                    IconButton(
                      onPressed: () {
                        showTimePicker(
                          context: context, 
                          initialTime: horaSeleccionada, 
                        ).then((hora){
                          if (hora != null && mounted){
                            setState(() {
                              horaSeleccionada = hora;
                            });
                          }
                        });
                      }, 
                      icon: Icon(Icons.access_time, color: Colors.white,)
                    )
                  ],
                ),
          
                SizedBox(height: 25,),
          
                ElevatedButton.icon(
                  onPressed: () => seleccionarFoto(ImageSource.gallery), 
                  icon: Icon(Icons.photo_library),
                  label: Text('Elije Foto')
                ),
                SizedBox(height: 25,),

                ElevatedButton.icon(
                  onPressed: () => seleccionarFoto(ImageSource.camera), 
                  icon: Icon(Icons.camera_alt),
                  label: Text('Foto'),
                ),
          
                SizedBox(height: 25,),
          
                if (fotoBytes != null)
                  Image.memory(
                    fotoBytes!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  
          
                SizedBox(height: 25,),
          
                ElevatedButton(
                  onPressed: guardando ? null : () async {
                    bool formularioValido = formKey.currentState!.validate();

                    if (fotoBytes == null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Es obligatorio poner foto')
                        )
                      );

                      return;
                    }

                    if (!formularioValido) {
                      return;
                    }

                    final usuario = FirebaseAuth.instance.currentUser;

                    if (usuario == null){
                      return;
                    }

                    DateTime fechaHora = DateTime(

                      fechaSeleccionada.year,
                      fechaSeleccionada.month,
                      fechaSeleccionada.day,
                      horaSeleccionada.hour,
                      horaSeleccionada.minute,

                    );

                    final campos = [

                      tituloCtrl.text.trim(),
                      descripcionCtrl.text.trim(),
                      tipoSeleccionado!,
                      categoriaSeleccionada!,
                      ubicacionCtrl.text.trim(),
                      usuario.uid,
                      usuario.displayName ?? 'Usuario'

                    ].join();

                    int tamano = fotoBytes!.lengthInBytes + utf8.encode(campos).length + 10000;

                    if (tamano >= 900000){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('La foto pesa mucho'),
                      ));

                      return;
                    }

                    setState(() {
                      guardando = true;
                    });
                    
                    try {

                      await FsService().agregarPublicacion(
                        tituloCtrl.text.trim(), 
                        descripcionCtrl.text.trim(), 
                        tipoSeleccionado!, 
                        categoriaSeleccionada!, 
                        ubicacionCtrl.text.trim(), 
                        fechaHora, 
                        fotoBytes!, 
                        usuario.uid, 
                        usuario.displayName ?? 'Usuario'
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Publicacion guardada'))
                      );

                      Navigator.pop(context);

                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al guardar: $e'))
                      );
                    } finally {
                      if (mounted){
                        setState(() {
                          guardando = false;
                        });
                      }
                    }

                  }, 
                  child: Text('Publicar')
                )
          
              ],
            )
          ),
        ),
      ),
    );
  }
}