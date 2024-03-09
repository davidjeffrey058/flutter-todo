
part of 'selection_bloc.dart';
abstract class SelectionState{
  List<int> selectedList;
  SelectionState({required this.selectedList});
}

class SelectionStateInitial extends SelectionState{
  SelectionStateInitial({required selectedList}) : super(selectedList: selectedList);
}

class SelectionStateUpdated extends SelectionState{
  SelectionStateUpdated({required selectedList}) : super(selectedList: selectedList);
}