import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_1_music/Auth/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "img/kirby.gif",
                  ),
                  fit: BoxFit.cover)),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Sign In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image.asset(
                "img/music.png",
                height: 120,
              ),
              SizedBox(height: 200),
              Text(
                "Utiliza un red social",
              ),
              MaterialButton(
                child: Text("Iniciar con Google"),
                color: Colors.green,
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
