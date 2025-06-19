part of 'box_layout_cubit.dart';

sealed class BoxLayoutState extends Equatable {
  const BoxLayoutState();
}

 class BoxLayoutInitial extends BoxLayoutState {
  @override
  List<Object?> get props => [identityHashCode(this)];
}
