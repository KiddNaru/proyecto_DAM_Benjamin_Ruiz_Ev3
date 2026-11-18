import 'package:flutter/material.dart';

class PublicarPage extends StatefulWidget {
  const PublicarPage({super.key});

  @override
  State<PublicarPage> createState() => _PublicarPageState();
}

class _PublicarPageState extends State<PublicarPage> {

  final tituloCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override

  void dispose(){
    tituloCtrl.dispose();
    descripcionCtrl.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 162, 234),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 147, 162, 234),

        title: Text('Nueva Publicacion', style: TextStyle(color: Colors.white),),
      ),

      body: Padding(
        padding: EdgeInsets.all(25),
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

              ElevatedButton(
                onPressed: () {
                  formKey.currentState!.validate();
                }, 
                child: Text('Enviar')
              )

            ],
          )
        ),
      ),
    );
  }
}