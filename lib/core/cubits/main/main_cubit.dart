import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState.initial());

  void changeNavigationIndex(int index) {
    emit(state.copyWith(bottomNavigationIndex: index));
  }

  void resetNavigationIndex() {
    emit(state.copyWith(bottomNavigationIndex: 0));
  }
}
