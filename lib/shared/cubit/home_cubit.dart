import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/task_status_enum.dart';
import '../../modules/archived_tasks/archived_view.dart';
import '../../modules/done_tasks/done_view.dart';
import '../../modules/tasks/tasks_view.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  /// Get Instance of this cubit using context
  static HomeCubit get(BuildContext context) =>
      BlocProvider.of<HomeCubit>(context);

  /// [BottomNavigationBar] , [PageController]s currentIndex
  int index = 0;

  /// Sets a new index and emits state
  void setIndex(int newIndex) =>
      {index = newIndex, emit(HomeChangeScreenState())};

  /// null for bottom nav bar true for body and false for appbar
  bool? isBody;

  void isBodySetter(bool? newValue) => isBody;

  /// Bottom Sheet Controller
  PersistentBottomSheetController? bottomSheetController;

  /// a flag to show if bottom nav key is active
  bool _isBottomSheetShown = false;

  /// get flag to show if bottom nav key is active
  get isBottomSheetShown => _isBottomSheetShown;

  /// set the flag to show if bottom nav key is active on change
  void isBottomSheetShownSetter(bool newValue) =>
      {_isBottomSheetShown = newValue, emit(SetIsBottomSheetShownState())};

  /// refers to [TasksView],[DoneView],[ArchivedView]
  final List<Widget> bodyWidgets = const [
    TasksView(),
    DoneView(),
    ArchivedView(),
  ];

  /// [AppBar] Labels
  final List<String> labels = const [
    'All Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  /// Sqflite
  //////////////////////////////////////////////////

  /// Local Sqflite Instance
  Database? db;

  /// on database create and open
  /// version '1'
  void createOrOpenDB() async => await openDatabase('todo.db',
      version: 1,
      onCreate: (db, i) => {
            db.execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)'),
            print('- Database Created'),
            emit(CreateOrOpenDBState())
          },
      onOpen: (db) async {
        if (kDebugMode) print('- Database Opened');
        emit(LoadingDBState());
        getFromDB(db);
      }).then((Database value) => db = value);

  /// get data from tasks table
  void getFromDB(Database? db) async => {
        emit(LoadingDBState()),

        /// querying to get
        await db?.rawQuery('SELECT * FROM tasks').then((value) {
          /// setting tasks to empty
          newTasks = [];
          doneTasks = [];
          archivedTasks = [];
          if (kDebugMode) print(value);

          /// adding values upon status
          for (var element in value) {
            print(element);

            /// if it is a new task
            if (element['status'] == TaskStatus.todo.name) {
              newTasks.add(element);
            }

            /// if it is a done task
            else if (element['status'] == TaskStatus.done.name) {
              doneTasks.add(element);
            }

            /// if it is an archived task
            else {
              archivedTasks.add(element);
            }
          }
          emit(GetFromDBState());
        })
      };
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  /// inserting task to db
  void insertTaskToDB(String title, String time, String date,
          {TaskStatus? status}) async =>
      {
        emit(LoadingDBState()),
        await db?.insert('tasks', {
          'title': title,
          'time': time,
          'date': date,
          'status': status == null ? TaskStatus.todo.name : status.name
        }).then((value) {
          emit(InsertToDBState());
          if (kDebugMode) print('$value is Inserted Successfully');
          getFromDB(db);
        })
      };

  /// Update Task in DB
  updateTaskInDB(TaskStatus status, int id) =>
      db?.rawUpdate('UPDATE tasks set status = ? WHERE id = ?', [
        status.name,
        id
      ]).then((value) =>
          {emit(LoadingDBState()), getFromDB(db), emit(UpdateTaskState())});

  /// Delete Task in Db
  deleteTaskInDB(int id) =>
      db?.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value) =>
          {emit(LoadingDBState()), getFromDB(db), emit(DeleteTaskState())});

////////////////////////////////////
  ///end Sqflite
////////////////////////////////////

}
