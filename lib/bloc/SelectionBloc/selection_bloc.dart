

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
part 'selection_state.dart';
part 'selection_event.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState>{
  SelectionBloc() : super(SelectionStateInitial(selectedList: <int>[])){
    on<Select>(_select);
    on<SelectAll>(_selectAll);
    on<Remove>(_remove);
    on<RemoveAll>(_removeAll);
  }

  void _select(Select event, Emitter<SelectionState> emitter){
    state.selectedList.add(event.id);
    emitter(SelectionStateUpdated(selectedList: state.selectedList));
  }

  void _selectAll(SelectAll event, Emitter<SelectionState> emitter){
    state.selectedList = event.allSelection;
    emitter(SelectionStateUpdated(selectedList: state.selectedList));
  }

  void _remove(Remove event, Emitter<SelectionState> emitter){
    state.selectedList.removeAt(event.id);
    emitter(SelectionStateUpdated(selectedList: state.selectedList));
  }

  void _removeAll(RemoveAll event, Emitter<SelectionState> emitter){
    state.selectedList = event.emptyList;
    emitter(SelectionStateUpdated(selectedList: state.selectedList));
  }

  @override
  void onChange(Change<SelectionState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print(change);
      print(state.selectedList);
    }
  }
}
