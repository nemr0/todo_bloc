import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/shared/cubit/home_cubit.dart';
import 'package:todo_bloc/shared/cubit/theme_mode_cubit.dart';

class ThemeModeFAB extends StatelessWidget {
  const ThemeModeFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        var c = ThemeModeCubit.get(context);
        return FloatingActionButton(
          onPressed: () {
            HomeCubit hc = HomeCubit.get(context);
            hc.setIndex(0);
            c.mode == ThemeMode.system
                ? c.updateThemeMode(ThemeMode.light)
                : c.mode == ThemeMode.light
                    ? c.updateThemeMode(ThemeMode.dark)
                    : c.updateThemeMode(ThemeMode.system);
            // hc.isBottomSheetShownSetter(false);
            // hc.setIndex(index);
          },
          child: Icon(c.mode == ThemeMode.system
              ? Icons.brightness_4_rounded
              : c.mode == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.dark_mode),
        );
      },
    );
  }
}
