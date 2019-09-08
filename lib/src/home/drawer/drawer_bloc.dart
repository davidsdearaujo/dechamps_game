import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dechamps_game/src/home/game/game_bloc.dart';

class DrawerBloc extends BlocBase {
  final GameBloc gameBloc;
  DrawerBloc(this.gameBloc);

  Stream<List<Player>> get playersOut => gameBloc.gameOut.map((model) =>
      model.players.values
        .toList()
        ..sort((x, y) => x?.score?.compareTo(y?.score))
      ).take(10);

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    super.dispose();
  }
}
