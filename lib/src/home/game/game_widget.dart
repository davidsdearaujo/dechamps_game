import 'package:dechamps_game/src/home/home_module.dart';
import 'package:flutter/material.dart';

import 'game_bloc.dart';

class GameWidget extends StatelessWidget {
  final GameBloc bloc = HomeModule.to.bloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameModel>(
      stream: bloc.gameOut,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: AspectRatio(
            aspectRatio: snapshot.data.canvasWidth / snapshot.data.canvasHeight,
            child: SizedBox(
              height: snapshot.data.canvasHeight.toDouble(),
              width: snapshot.data.canvasWidth.toDouble(),
              child: GridView.builder(
                itemCount: snapshot.data.canvasWidth * snapshot.data.canvasHeight,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: snapshot.data.canvasWidth,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  var color = Colors.white;

                  //Players
                  var players = snapshot.data.players.values;
                  Player playerInIndex;

                  var _players = players.where((player) {
                    var _index = player.y * snapshot.data.canvasWidth + player.x;
                    return _index == index;
                  }).toList();
                  
                  if (_players.length > 0) playerInIndex = _players[0];

                  if (playerInIndex?.sid == bloc.repository.sid)
                    color = Colors.orange;
                  else if (playerInIndex != null) color = Colors.grey;
                  //Players End
                  
                  //Fruits
                  else{
                    var fruits = snapshot.data.fruits.values;
                    bool isFruit = fruits.where((fruit) {
                      var _index = fruit.y * snapshot.data.canvasWidth + fruit.x;
                      return _index == index;
                    }).length > 0;

                    if (isFruit) color = Colors.green;
                  }
                  //Fruits End

                  return Container(
                    color: color,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
