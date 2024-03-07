import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

sealed class ThemeEvent {}

final class DarkModeTheme extends ThemeEvent{}

final class LightModeTheme extends ThemeEvent{}

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode>{
  ThemeBloc() : super(ThemeMode.light){
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