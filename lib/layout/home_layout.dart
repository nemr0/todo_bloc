import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_bloc/modules/archived_tasks/archived_view.dart';
import 'package:todo_bloc/modules/done_tasks/done_view.dart';
import 'package:todo_bloc/modules/tasks/tasks_view.dart';

import '../shared/components/custom_text_field.dart';

/// Task Status enum {todo : [TaskView], done : [DoneView], archived : [ArchivedView],}
enum TaskStatus { todo, done, archived }

List<Map> tasks = [];

/// Layout of Home Page includes :
/// - [AppBar].
/// - body (refers to [TasksView],[DoneView],[ArchivedView]).
/// - Floating Action Button.
class HomeLayout extends StatefulWidget {
  const HomeLayout({
    super.key,
  });

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  /// get data from tasks table
  Future<List<Map>> getFromDB() async =>
      await db.rawQuery('SELECT * FROM tasks');

  /// on database create and open
  /// version '1'
  Future<Database> openDB() async => await openDatabase('todo.db',
      version: 1,
      onCreate: (db, i) => db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)'),
      onOpen: (db) async {
        db.query('tasks').then((value) => print(value));
      });

  /// inserting task to db
  Future<int?> insertToDB(String title, String time, String date,
          {TaskStatus? status}) async =>
      await db.insert('tasks', {
        'title': title,
        'time': time,
        'date': date,
        'status':
            status == null ? TaskStatus.todo.toString() : status.toString()
      });

  /// [BottomNavigationBar] currentIndex
  int _index = 0;

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

  /// [PageController] for [PageView]
  late PageController _bodyPageController;
  late PageController _appBarPageController;

  /// Text Editing Controllers for Bottom Sheet
  late TextEditingController titleController;
  late TextEditingController timeController;
  late TextEditingController dateController;
  late Database db;

  // overriding initState method
  @override
  void initState() {
    super.initState();
    openDB().then((value) async {
      db = value;
      tasks = await getFromDB();
    });

    // Initializing the body & appbar Page Controller
    _bodyPageController = PageController();
    _appBarPageController = PageController();
    // Initializing Text Editing Controller for BottomSheet
    titleController = TextEditingController();
    timeController = TextEditingController();
    dateController = TextEditingController();
  }

  // overriding dispose method
  @override
  void dispose() {
    // Disposing the body&appbar Page Controller
    _bodyPageController.dispose();
    _appBarPageController.dispose();
    // Disposing Text Editing Controller for BottomSheet
    titleController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  /// On [BottomNavigationBar] Icon Press or [PageView] switch in [AppBar] or
  /// body
  void _onSwitch(int index, {bool? isAppBarOrBody}) {
    setState(() {
      // setting new index
      _index = index;
      //using this page controller you can make beautiful animation effects
      if (isAppBarOrBody == null || isAppBarOrBody == true) {
        _bodyPageController.animateToPage(_index,
            duration: const Duration(milliseconds: 150),
            curve: Curves.bounceInOut);
      }
      if (isAppBarOrBody == null || isAppBarOrBody == false) {
        _appBarPageController.animateToPage(_index,
            duration: const Duration(milliseconds: 150),
            curve: Curves.bounceInOut);
      }
    });
  }

  /// Scaffold key to control bottomSheet and more...
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Form Key to Validate
  final formKey = GlobalKey<FormState>();

  /// a flag to show if bottom nav key is active
  bool isBottomSheetShown = false;
  PersistentBottomSheetController? bottomSheetController;

  /// overriding build method for [HomeLayout]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: MediaQuery.of(context).size.height * .09,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
            ),
            title: SizedBox(
              height: 50,
              child: PageView.builder(
                onPageChanged: (i) => _onSwitch(i, isAppBarOrBody: true),
                itemBuilder: (context, index) => Center(
                  child: Text(
                    labels[index],
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                itemCount: bodyWidgets.length,
                controller: _appBarPageController,
              ),
            )),
        body: GestureDetector(
          onTap: () {
            if (bottomSheetController != null) {
              bottomSheetController?.close();
              setState(() => isBottomSheetShown = false);
            }
          },
          child: PageView.builder(
            onPageChanged: (i) => _onSwitch(i, isAppBarOrBody: false),
            itemBuilder: (context, index) => bodyWidgets[index],
            itemCount: bodyWidgets.length,
            controller: _bodyPageController,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onFABPress,
          tooltip: 'Increment',
          child: Icon(isBottomSheetShown ? Icons.add : Icons.circle_outlined),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                label: 'Tasks',
                icon: Icon(
                  Icons.menu_open_outlined,
                )),
            BottomNavigationBarItem(
                label: 'Done',
                icon: Icon(
                  Icons.check_circle_outline_outlined,
                )),
            BottomNavigationBarItem(
                label: 'Archived',
                icon: Icon(
                  Icons.archive_outlined,
                )),
          ],
          currentIndex: _index,
          onTap: (i) => _onSwitch(i),
        ));
  }

  /// ON [FloatingActionButton] Pressed
  onFABPress() {
    {
      // If Bottom Sheet is Open
      if (isBottomSheetShown) {
        // If title, time and date are valid (not empty)
        if (formKey.currentState?.validate() == true) {
          // insert task
          insertToDB(
              titleController.text, timeController.text, dateController.text);
          titleController.text = '';
          timeController.text = '';
          dateController.text = '';
          // close Bottom Sheet
          Navigator.pop(context);
          // setState(() => isBottomSheetShown = false);
        }
      }
      // if bottom sheet is closed
      else {
        // open it
        bottomSheetController = scaffoldKey.currentState?.showBottomSheet(
          (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .35,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomTextField(
                      icon: const Icon(Icons.watch_later_rounded),
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      label: 'Title',
                      hintText: 'New Task Title',
                      validator: (String? s) {
                        if (s == null || s.isEmpty) {
                          return 'Enter A Correct Title';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      isClickable: false,
                      icon: const Icon(Icons.calendar_today_outlined),
                      controller: timeController,
                      keyboardType: TextInputType.datetime,
                      label: 'Time',
                      hintText: 'HH:MM AM',
                      onTap: () {
                        showTimePicker(
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                context: context,
                                initialTime: TimeOfDay.now(),
                                helpText: 'Please Specify The Task Time')
                            .then((value) => setState(
                                () => timeController.text = value == null
                                    ? timeController.text.isEmpty
                                        ? ''
                                        : timeController.text
                                    : value.format(context)));
                      },
                      validator: (String? s) {
                        if (s == null || s.isEmpty) {
                          return 'Enter A Correct Time';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      isClickable: false,
                      icon: const Icon(Icons.calendar_month_outlined),
                      controller: dateController,
                      keyboardType: TextInputType.datetime,
                      label: 'Date',
                      hintText: 'DD/MM/YYYY',
                      onTap: () {
                        DateTime now = DateTime.now();
                        const Duration addedOrSubtracted = Duration(days: 30);
                        showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: now.subtract(addedOrSubtracted),
                                lastDate: now.add(addedOrSubtracted))
                            .then((value) => dateController.text = value == null
                                ? dateController.text.isEmpty
                                    ? ''
                                    : dateController.text
                                : value.toString().substring(0, 10));
                      },
                      validator: (String? s) {
                        if (s == null || s.isEmpty) {
                          return 'Enter A Correct Date';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
        );
        bottomSheetController?.closed
            .then((value) => {setState(() => isBottomSheetShown = false)});
        setState(() => isBottomSheetShown = true);
      }
    }
  }
}
