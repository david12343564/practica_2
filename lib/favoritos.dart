import 'package:flutter/material.dart';
import 'package:practica_1_music/cancion_favorita.dart';
import 'package:practica_1_music/home.dart';
import 'package:practica_1_music/music_provider.dart';
import 'package:provider/provider.dart';

class favoritos extends StatelessWidget {
  const favoritos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favoritos"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (() {
              context.read<musicProvider>().notFound();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            }),
          ),
        ),
        body: ListView.builder(
          itemCount: context.watch<musicProvider>().getListaFavs.length,
          itemBuilder: (BuildContext context, int index) {
            return cancionfav(
              song: context.read<musicProvider>().getListaFavs[index],
            );
          },
        ));
  }
}
