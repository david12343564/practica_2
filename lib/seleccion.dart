import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practica_1_music/home.dart';
import 'package:practica_1_music/music_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class seleccion extends StatelessWidget {
  seleccion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Here you go'),
          leading: IconButton(
              onPressed: () {
                context.read<musicProvider>().notFound();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(Icons.arrow_back)),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () async {
                  if (context
                      .read<musicProvider>()
                      .inFavoritos(context.read<musicProvider>().getCancion)) {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: Text("Eliminar de Favs"),
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
                                        .deleteSong(context
                                            .read<musicProvider>()
                                            .getCancion);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Eliminar"))
                            ],
                          );
                        }));
                  } else {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: Text("Agregar a favs"),
                            content:
                                Text("Quiere agregar la canción a favoritos?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancelar")),
                              TextButton(
                                  onPressed: () async {
                                    await context.read<musicProvider>().addSong(
                                        context
                                            .read<musicProvider>()
                                            .getCancion);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Agregar"))
                            ],
                          );
                        }));
                  }
                },
                child: Icon(Icons.favorite,
                    color: context.watch<musicProvider>().inFavoritos(
                            context.read<musicProvider>().getCancion)
                        ? Colors.red
                        : Colors.white),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                  "${context.read<musicProvider>().getCancion["image"]}"),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${context.read<musicProvider>().getCancion["title"]}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${context.read<musicProvider>().getCancion["album"]}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${context.read<musicProvider>().getCancion["artist"]}",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "${context.read<musicProvider>().getCancion["release_date"]}",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ],
                ),
              ),
              SizedBox(),
              Column(
                children: [
                  Text(
                    "Abrir con: ",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          tooltip: "Ver en spotify",
                          onPressed: () {
                            _launchLink(
                                "${context.read<musicProvider>().getCancion["spotify"]}");
                          },
                          icon: FaIcon(FontAwesomeIcons.spotify)),
                      IconButton(
                          tooltip: "Ver en Podcast",
                          onPressed: () {
                            _launchLink(
                                "${context.read<musicProvider>().getCancion["podcast"]}");
                          },
                          icon: FaIcon(FontAwesomeIcons.podcast)),
                      IconButton(
                          tooltip: "Ver en Apple Music",
                          onPressed: () {
                            _launchLink(
                                "${context.read<musicProvider>().getCancion["apple_music"]}");
                          },
                          icon: FaIcon(FontAwesomeIcons.apple))
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  Future<void> _launchLink(String url) async {
    // ignore: deprecated_member_use
    if (!await launch(url)) throw "No se pudo acceder a: $url";
  }
}
