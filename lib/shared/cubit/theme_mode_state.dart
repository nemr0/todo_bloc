part of 'theme_mode_cubit.dart';

@immutable
abstract class ThemeModeState {}

/// Initial state (gets saved one)
class ThemeModeInitial extends ThemeModeState {}

/// Get Theme State (using ThemeCubit to get saved state from get_storage)
class GetThemeState extends ThemeModeState {}

/// Update Theme State (using ThemeCubit to update saved state from get_storage)
class UpdateThemeState extends ThemeModeState {}
