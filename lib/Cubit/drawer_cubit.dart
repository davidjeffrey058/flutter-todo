import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/screens/components/boxes.dart';
import 'package:todo/screens/home.dart';

class DrawerCubit extends Cubit<DrawerOptions>{

  DrawerCubit() : super(getDrawerValue() ?? DrawerOptions.tasks);

  void selectedOption(DrawerOptions option) => emit(option);
}

DrawerOptions? getDrawerValue(){
  switch(configBox.get('drawerValue')){
    case 1:
      return DrawerOptions.myDay;
    case 2:
      return DrawerOptions.tasks;
    case 3:
      return DrawerOptions.important;
    default:
      return null;
  }
}