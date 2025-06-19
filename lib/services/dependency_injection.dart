import 'package:get_it/get_it.dart';

import '../cubits/box_layout_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<BoxLayoutCubit>(BoxLayoutCubit());
}

