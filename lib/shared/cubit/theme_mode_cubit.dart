import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit() : super(ThemeModeInitial());

  /// Get Instance of this cubit using context
  static ThemeModeCubit get(BuildContext context) =>
      BlocProvider.of<ThemeModeCubit>(context);

  /// ThemeMode Saved Using get_storage
  ThemeMode mode = ThemeMode.system;

  /// Get ThemeMode
  getThemeMode() {
    print(GetStorage().read('theme'));
    String? stringMode = GetStorage().read('theme');
    mode = stringMode == ThemeMode.dark.name
        ? ThemeMode.dark
        : stringMode == ThemeMode.light.name
            ? ThemeMode.light
            : ThemeMode.system;
    emit(GetThemeState());
  }

  /// Update ThemeMode and save it to get_storage
  updateThemeMode(ThemeMode mode) => {
        GetStorage().write('theme', mode.name).then((value) => getThemeMode()),
        emit(UpdateThemeState()),
      };
}
