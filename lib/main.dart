import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/custom_bloc_observer.dart';
import 'package:todo_bloc/shared/styles/styles.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_bloc/shared/cubit/theme_mode_cubit.dart';
import 'layout/home_layout.dart';

/// Main ( Start Point )
void main() {
  GetStorage.init();
  // changing bloc observer to a custom one in ./custom_bloc_observer.dart
  Bloc.observer = CustomBlocObserver();
  runApp(const MaterialAppConfig());
}

/// Material App Configuration
class MaterialAppConfig extends StatelessWidget {
  const MaterialAppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeModeCubit>(
      create: (context) => ThemeModeCubit()..getThemeMode(),
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          ThemeMode mode = ThemeModeCubit.get(context).mode;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: mode,
            home: HomeLayout(),
          );
        },
      ),
    );
  }
}
