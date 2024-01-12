import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/screens/home.dart';

class DrawerCubit extends Cubit<DrawerOptions>{
  DrawerCubit() : super(DrawerOptions.tasks);

  void selectedOption(DrawerOptions option) => emit(option);
}