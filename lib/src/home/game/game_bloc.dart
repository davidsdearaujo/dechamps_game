import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dechamps_game/src/shared/models/game_model.dart';
export 'package:dechamps_game/src/shared/models/game_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_repository.dart';

class GameBloc extends BlocBase {
  final AppRepository repository;
  final _gameController = BehaviorSubject<GameModel>();
  final maxConcurrenceController = BehaviorSubject<bool>();
  Observable<GameModel> get gameOut => _gameController.stream;
  Observable<int> get pointsOut => _gameController.stream
      .map((model) => model.players[repository.sid]?.score);

  Observable get errorOut => repository.dataOut.switchMap(filter);

  GameBloc(this.repository) {
    repository.dataOut
        .switchMap(filter)
        .where((model) => model != null)
        .listen((data) {
      _gameController.add(data);
    });
  }

  void moveLeft() {
    var response = _gameController.value;
    if (response.players[repository.sid].x > 0) {
      response.players[repository.sid].x--;
      _gameController.add(response);
      repository.send("42[\"player-move\",\"left\"]");
    }
  }

  void moveRight() {
    var response = _gameController.value;
    if (response.players[repository.sid].x <
        _gameController.value.canvasWidth - 1) {
      response.players[repository.sid].x++;
      _gameController.add(response);
      repository.send("42[\"player-move\",\"right\"]");
    }
  }

  void moveUp() {
    var response = _gameController.value;
    if (response.players[repository.sid].y > 0) {
      response.players[repository.sid].y--;
      _gameController.add(response);
      repository.send("42[\"player-move\",\"up\"]");
    }
  }

  void moveDown() {
    var response = _gameController.value;
    if (response.players[repository.sid].y <
        _gameController.value.canvasHeight - 1) {
      response.players[repository.sid].y++;
      _gameController.add(response);
      repository.send("42[\"player-move\",\"down\"]");
    }
  }

  Stream<GameModel> filter(EventGameModel model) async* {
    switch (model.event) {
      case "bootstrap":
        yield GameModel.fromJson(model.data);
        break;

      case "player-update":
        var response = _gameController.value;
        var socketId = model.data["socketId"];
        var newState = Player.fromJson(socketId, model.data["newState"]);
        if (response != null) response.players[socketId] = newState;
        yield response;
        break;

      case "player-remove":
        var response = _gameController.value;
        response.players.remove(model.data);
        yield response;
        break;

      case "fruit-remove":
        var response = _gameController.value;
        response.fruits.remove(model.data["fruitId"]);
        yield response;
        break;

      case "fruit-add":
        var response = _gameController.value;
        response.fruits[model.data["fruitId"].toString()] =
            Fruit.fromJson(model.data);
        yield response;
        break;

      case "update-player-score":
        var response = _gameController.value;
        response.players[repository.sid].score = model.data;
        yield response;
        break;

      case "show-max-concurrent-connections-message":
        if (!(maxConcurrenceController.value ?? false)) maxConcurrenceController.add(true);
        break;

      case "hide-max-concurrent-connections-message":
        maxConcurrenceController.add(false);
        break;

      default:
        yield* Observable.error("Header não implementado");
        break;
    }
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() async {
    await _gameController.drain();
    _gameController.close();
    maxConcurrenceController.close();
    super.dispose();
  }
}
