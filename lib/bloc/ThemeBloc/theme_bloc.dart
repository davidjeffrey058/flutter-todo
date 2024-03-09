import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/components/boxes.dart';

sealed class ThemeEvent {}

final class DarkModeTheme extends ThemeEvent{}
final class LightModeTheme extends ThemeEvent{}

ThemeMode? _savedThemeMode(){
  bool? isDark = configBox.get('isDark');
  if(isDark != null){
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }
  return null;
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode>{
  ThemeBloc() : super(_savedThemeMode() ?? ThemeMode.light){
    on<DarkModeTheme>((event, emit) => emit(ThemeMode.dark));
    on<LightModeTheme>((event, emit) => emit(ThemeMode.light));
  }

  @override
  void onChange(Change<ThemeMode> change) {
    super.onChange(change);
    if (kDebugMode) {
      print(change);
    }
  }
}