import 'package:dechamps_game/src/home/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';

import 'game/game_bloc.dart';
import 'game/game_widget.dart';
import 'game/joystick/joystick_widget.dart';
import 'home_module.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var gameBloc = HomeModule.to.bloc<GameBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: gameBloc.maxConcurrenceController,
      builder: (context, maxConcurrenceSnapshot) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Scaffold(
              backgroundColor: Colors.grey[300],
              drawer: DrawerWidget(),
              appBar: AppBar(
                centerTitle: true,
                title: Text("Teló game"),
                actions: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 10),
                    child: StreamBuilder<int>(
                      stream: gameBloc.pointsOut,
                      builder: (context, snapshot) {
                        return Text(
                          "Points: ${snapshot.data ?? 0}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              body: StreamBuilder<GameModel>(
                stream: gameBloc.gameOut,
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: GameWidget(),
                        ),
                      ),
                      Expanded(child: JoystickWidget()),
                    ],
                  );
                },
              ),
            ),
            if (maxConcurrenceSnapshot.data ?? false)
              Container(
                color: Colors.black38,
                width: double.infinity,
                height: double.infinity,
                child: AlertDialog(
                  title: Text("Número máximo de conexões atingida!"),
                  content: Text(
                      "Apesar do número máximo ter sido atingido, o app ficará tentando reconectar em background automaticamente. Assim que aumentarmos o número de conexões, você não precisará fazer nada para reconectar e começar a jogar com a turma!"),
                ),
              ),
          ],
        );
      },
    );
  }
}
