// To parse this JSON data, do
//
//     final gameModel = gameModelFromJson(jsonString);

import 'dart:convert';

GameModel gameModelFromJson(String str) => GameModel.fromJson(json.decode(str));

String gameModelToJson(GameModel data) => json.encode(data.toJson());

class GameModel {
    int canvasWidth;
    int canvasHeight;
    Map<String, Player> players;
    Map<String, Fruit> fruits;

    GameModel({
        this.canvasWidth,
        this.canvasHeight,
        this.players,
        this.fruits,
    });

    factory GameModel.fromJson(Map<String, dynamic> json) => new GameModel(
        canvasWidth: json["canvasWidth"],
        canvasHeight: json["canvasHeight"],
        players: new Map.from(json["players"]).map((k, v) => new MapEntry<String, Player>(k, Player.fromJson(k, v))),
        fruits: new Map.from(json["fruits"]).map((k, v) => new MapEntry<String, Fruit>(k, Fruit.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "canvasWidth": canvasWidth,
        "canvasHeight": canvasHeight,
        "players": new Map.from(players).map((k, v) => new MapEntry<String, dynamic>(k, v.toJson())),
        "fruits": new Map.from(fruits).map((k, v) => new MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Fruit {
    int x;
    int y;

    Fruit({
        this.x,
        this.y,
    });

    factory Fruit.fromJson(Map<String, dynamic> json) => new Fruit(
        x: json["x"],
        y: json["y"],
    );

    Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
    };
}

class Player {
    String sid;
    int x;
    int y;
    int score;

    Player({
        this.x,
        this.y,
        this.score,
        this.sid,
    });

    factory Player.fromJson(String sid, Map<String, dynamic> json) => new Player(
        x: json["x"],
        y: json["y"],
        score: json["score"],
        sid: sid,
    );

    Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
        "score": score,
    };
}
