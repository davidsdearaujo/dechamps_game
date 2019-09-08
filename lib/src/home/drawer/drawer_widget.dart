import 'package:dechamps_game/src/home/game/game_bloc.dart';
import 'package:flutter/material.dart';

import '../home_module.dart';

class DrawerWidget extends StatelessWidget {
  final gameBloc = HomeModule.to.bloc<GameBloc>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<GameModel>(
        stream: gameBloc.gameOut,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          var players = snapshot.data.players;
          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(25),
                color: Theme.of(context).primaryColor,
                child: SafeArea(
                  child: Text(
                    "Top 10 Score",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    var current = players.values.elementAt(index);
                    return ListTile(
                      selected: gameBloc.repository.sid == current.sid,
                      title: Text("${index+1}º ${current.sid}"),
                      trailing: Text(current.score.toString()),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
