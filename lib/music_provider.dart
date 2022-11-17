import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practica_1_music/post.dart';
import 'package:record/record.dart';

class musicProvider with ChangeNotifier {
  List<dynamic> _favoritos = [];
  List<dynamic> get getListaFavs => _favoritos;

  bool _inFavs = false;
  bool get isFav => _inFavs;

  APIRep peticion = APIRep();
  Record _record = Record();

  String _escuchando = "Toque para escuchar";
  bool _animar = false;
  bool _encontrado = false;
  bool get animar => _animar;
  String get escuchando => _escuchando;
  bool get encontrado => _encontrado;

  dynamic _cancion = null;
  dynamic get getCancion => _cancion;

  void setCancion(dynamic song) {
    _cancion = song;
    notifyListeners();
  }

  void notFound() {
    _encontrado = false;
    notifyListeners();
  }

  void Escuchar() {
    _escuchando = "Escuchando...";
    notifyListeners();
  }

  void dejarEscuchar() {
    _escuchando = "Toque para escuchar";
    notifyListeners();
  }

  void animacion() {
    _animar = !animar;
    notifyListeners();
  }

  void noSongSelect() {
    _cancion = null;
    notifyListeners();
  }

  //Para agregar y borrar de favoritos
  Future<void> addSong(dynamic song) async {
    try {
      FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "favSongs": FieldValue.arrayUnion([song])
      });
      getSongsList();
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> getSongsList() async {
    try {
      var user = await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      _favoritos = user.data()!["favSongs"];
      notifyListeners();
    } catch (e) {
      notifyListeners();
      return;
    }
  }

  Future<void> deleteSong(dynamic songObj) async {
    try {
      FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "favSongs": FieldValue.arrayRemove([songObj])
      });
      getSongsList();
      notifyListeners();
    } catch (e) {
      notifyListeners();
      return;
    }
  }

  bool inFavoritos(dynamic songObj) {
    for (var i = 0; i < _favoritos.length; i++) {
      if (songObj["title"] == _favoritos[i]["title"] &&
          songObj["artist"] == _favoritos[i]["artist"] &&
          songObj["release_date"] == _favoritos[i]["release_date"]) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> recording() async {
    Directory? dir = await getTemporaryDirectory();
    if (await _record.hasPermission()) {
      await _record.start(
        path: '${dir.path}/maybeASong.m4a',
      );
    }

    bool isRecording = await _record.isRecording();
    if (isRecording) {
      Timer(Duration(seconds: 6), () async {
        String? filePath = await _record.stop();
        File audioFile = File(filePath!);
        Uint8List audioBytes = audioFile.readAsBytesSync();
        String audioBinary = base64Encode(audioBytes);
        var response = await peticion.postToAPI(audioBinary);
        if (response.statusCode == 200) {
          try {
            var res = jsonDecode(response.body)["result"];
            setCancion({
              "image": res["spotify"]["album"]["images"][0]["url"],
              "title": res["title"],
              "album": res["apple_music"]["albumName"],
              "artist": res["artist"],
              "release_date": res["release_date"],
              "spotify": res["spotify"]["external_urls"]["spotify"],
              "podcast": res["song_link"],
              "apple_music": res["apple_music"]["url"],
            });
            _encontrado = true;
            notifyListeners();
          } catch (e) {
            return;
          }
        }
      });
    }
  }
}
