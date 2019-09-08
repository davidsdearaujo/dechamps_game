import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dechamps_game/src/shared/models/event_game_model.dart';
export 'package:dechamps_game/src/shared/models/event_game_model.dart';
import 'package:dechamps_game/src/shared/utils/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:websocket/websocket.dart';

class AppRepository extends Disposable {
  String sid;
  int timeout;
  var _dataController = BehaviorSubject<EventGameModel>();
  Observable<EventGameModel> get dataOut => _dataController.stream;
  


  WebSocket ws;
  bool isDispose = false;

  AppRepository() {
    connect();
    // dataOut.listen(print);
  }

  void send(String data) => ws.addUtf8Text(data.codeUnits);
  

  Future<void> connect() async {
    try {
      print("Connecting...");
      ws = await WebSocket.connect(API_URL);
      print("Connected!");

      var subscription = ws.stream.listen((str) {
        String data = str;
        int index = int.parse(data.replaceAll(RegExp(r"[\[{].+"), ""));
        switch (index) {
          case 0:
            var json = jsonDecode(data.replaceFirst("0", ""));
            sid = json["sid"];
            timeout = json["pingInterval"];
            break;

          case 42:
            var json = jsonDecode(data.replaceFirst("42", ""));
            if (json[0] is String) {
              _dataController.add(EventGameModel(json[0], json.length > 1 ? json[1] : null));
            }
            break;
        }
        print(data);
      });

      var timer = Timer.periodic(Duration(milliseconds: timeout), (timer){
        send("2");
        print("Keep Alive");
      });

      //?EIO=3&transport=polling&t=MqFFcgx&sid=Ggs3y8AZz26CrZhQAACK
      await ws.done;
      timer.cancel();
      print("Disconnected");

      //Cancels
      await subscription.cancel();
      if (ws.closeCode != null) ws.close();
      if (!isDispose) reconnect(); //Reconnection
    } catch (ex) {
      if (!isDispose) reconnect();
      print(ex);
    }
  }

  Future<void> reconnect() async {
    return Future.delayed(Duration(seconds: 2), connect);
  }

  void dispose() {
    isDispose = true;
    _dataController.close();
    ws.close();
  }
}
