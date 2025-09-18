part of 'main_cubit.dart';

class MainState extends Equatable {
  final int bottomNavigationIndex;

  const MainState({required this.bottomNavigationIndex});

  MainState copyWith({int? bottomNavigationIndex}) {
    return MainState(
      bottomNavigationIndex:
          bottomNavigationIndex ?? this.bottomNavigationIndex,
    );
  }

  factory MainState.initial() {
    return MainState(bottomNavigationIndex: 0);
  }

  @override
  List<Object?> get props => [bottomNavigationIndex];
}
