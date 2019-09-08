import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dechamps_game/src/app_repository.dart';

class JoystickBloc extends BlocBase {
  final AppRepository repository;

  JoystickBloc(this.repository);


  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    super.dispose();
  }
}
