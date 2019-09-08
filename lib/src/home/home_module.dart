import 'package:dechamps_game/src/home/drawer/drawer_bloc.dart';
import 'package:dechamps_game/src/home/game/joystick/joystick_bloc.dart';
import 'package:dechamps_game/src/app_module.dart';
import 'package:dechamps_game/src/home/game/game_bloc.dart';
import 'package:dechamps_game/src/home/home_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:dechamps_game/src/home/home_page.dart';

class HomeModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => DrawerBloc(AppModule.to.bloc())),
        Bloc((i) => JoystickBloc(AppModule.to.get())),
        Bloc((i) => GameBloc(AppModule.to.get())),
        Bloc((i) => HomeBloc()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => HomePage();

  static Inject get to => Inject<HomeModule>.of();
}
