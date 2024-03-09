
part of 'selection_bloc.dart';

sealed class SelectionEvent{}

class Select extends SelectionEvent{
  int id;
  Select({required this.id});
}

class SelectAll extends SelectionEvent {
  List<int> allSelection;
  SelectAll({required this.allSelection});
}

class Remove extends SelectionEvent{
  int id;
  Remove({required this.id});
}

class RemoveAll extends SelectionEvent{
  List<int> emptyList = [];
}