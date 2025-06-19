
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/box_layout_cubit.dart';
import 'dependency_injection.dart';

var blocProviders = [
  BlocProvider<BoxLayoutCubit>.value(value:  getIt<BoxLayoutCubit>()),
];
