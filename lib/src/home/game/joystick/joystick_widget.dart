import 'package:dechamps_game/src/home/home_module.dart';
import 'package:flutter/material.dart';

import '../game_bloc.dart';
import 'joystick_bloc.dart';

class JoystickWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonWidget(icon: Icons.arrow_upward),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ButtonWidget(icon: Icons.arrow_back),
            SizedBox(width: 100),
            ButtonWidget(icon: Icons.arrow_forward),
          ],
        ),
        ButtonWidget(icon: Icons.arrow_downward),
      ],
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final JoystickBloc bloc = HomeModule.to.bloc();
  final GameBloc gameBloc = HomeModule.to.bloc();

  ButtonWidget({Key key, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(icon),
      onPressed: () {
        if (icon == Icons.arrow_back) {
          gameBloc.moveLeft();
        } else if (icon == Icons.arrow_downward) {
          gameBloc.moveDown();
        } else if (icon == Icons.arrow_forward) {
          gameBloc.moveRight();
        } else if (icon == Icons.arrow_upward) {
          gameBloc.moveUp();
        }
      },
    );
  }
}
