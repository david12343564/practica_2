import 'package:flutter/material.dart';
import 'package:practica_1_music/seleccion.dart';
import 'package:provider/provider.dart';

import 'music_provider.dart';

class cancionfav extends StatelessWidget {
  final dynamic song;

  const cancionfav({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 400,
      child: Stack(
        children: [
          Positioned.fill(
              child: MaterialButton(
            onPressed: () {
              context.read<musicProvider>().setCancion(song);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => seleccion()));
            },
            child: Image.network(
              "${song["image"]}",
              fit: BoxFit.fill,
            ),
          )),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 71, 145, 205),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${song["title"]}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${song["artist"]}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )),
          Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text("Eliminar de favs"),
                          content: Text("Quieres eliminar de favoritos?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancelar")),
                            TextButton(
                                onPressed: () async {
                                  await context
                                      .read<musicProvider>()
                                      .deleteSong(song);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Eliminar"))
                          ],
                        );
                      }));
                },
                icon: Icon(Icons.favorite),
                color: Colors.red,
              ))
        ],
      ),
    );
  }
}
