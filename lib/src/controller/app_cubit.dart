import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  bool isLoggedIn = false;
  String? email;
  Future getState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      email = prefs.getString('email');
    } else {
      email = null;
    }
    emit(AppStateChanged());
  }
}
