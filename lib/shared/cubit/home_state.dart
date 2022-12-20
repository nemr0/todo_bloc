part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}

/// On Index of bottomNavBar, PageController Change
class HomeChangeScreenState extends HomeState {}

/// Change is bottom Sheet Shown state
class SetIsBottomSheetShownState extends HomeState {}

/// for Database
/// Create
class CreateOrOpenDBState extends HomeState {}

/// Get
class GetFromDBState extends HomeState {}

/// Insert
class InsertToDBState extends HomeState {}

/// Loading
class LoadingDBState extends HomeState {}

/// Update Status of a task
class UpdateTaskState extends HomeState {}

/// Delete Status of a task
class DeleteTaskState extends HomeState {}
