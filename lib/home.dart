import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practica_1_music/Auth/bloc/auth_bloc.dart';
import 'package:practica_1_music/favoritos.dart';
import 'package:practica_1_music/music_provider.dart';
import 'package:practica_1_music/seleccion.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String mensaje = "Toque para escuchar";
  bool animar = false;

  @override
  Widget build(BuildContext context) {
    context.read<musicProvider>().getSongsList();
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 70),
              child: Text(
                "${context.watch<musicProvider>().escuchando}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            AvatarGlow(
              animate: context.read<musicProvider>().animar,
              glowColor: Color.fromARGB(255, 211, 159, 176),
              child: MaterialButton(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('img/music.png'),
                ),
                onPressed: () async {
                  context.read<musicProvider>().animacion();
                  context.read<musicProvider>().Escuchar();
                  await context.read<musicProvider>().recording();
                  Timer(const Duration(seconds: 8), () async {
                    context.read<musicProvider>().animacion();
                    context.read<musicProvider>().dejarEscuchar();
                    if (context.read<musicProvider>().encontrado) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => seleccion()));
                    } else {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                            content: Text("No se encontró la canción")));
                    }
                  });
                },
                shape: CircleBorder(),
              ),
              endRadius: 200.0,
            ),
            FloatingActionButton(
              heroTag: "button1",
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const favoritos()));
              },
              backgroundColor: Colors.white,
              tooltip: "Ver favoritos",
              child: Icon(
                Icons.favorite,
                color: Colors.black,
                size: 35,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: "Button2",
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
              },
              backgroundColor: Colors.red,
              tooltip: "Cerrar sesión",
              child: Icon(
                Icons.logout,
                color: Colors.white,
                size: 35,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
